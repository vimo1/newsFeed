//
//  StoryListViewController.swift
//  NewsClient
//
import RIBs
import RxSwift
import UIKit
import SafariServices

protocol StoryListPresentableListener: class {
  var storyIds: [Int] { get }
  var stories: [Story] { get }
  
  func getStories()
  func getSavedStories()
  func getStoryDetails(startIndex: Int)
  func saveStory(story: Story)
  func selectedStory(atIndexPath: IndexPath)
  func showCommentsForStory(atIndexPath: IndexPath)
}

final class StoryListViewController: UIViewController, StoryListPresentable, StoryListViewControllable, StoryViewCellListener {
  
  weak var listener: StoryListPresentableListener?
  let storiesTableView = UITableView()
  private var shuffledStoryCellIds: [String] = []
  
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action:
      #selector(StoryListViewController.handleRefresh(_:)),
                             for: UIControl.Event.valueChanged)
    
    return refreshControl
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    shuffledStoryCellIds.append(StoryListViewController.storyImageTopCellId)
    shuffledStoryCellIds.append(contentsOf: storyCellIds[...1].shuffled())
    shuffledStoryCellIds.append(contentsOf: storyCellIds.shuffled())
    shuffledStoryCellIds.append(contentsOf: storyCellIds[...1].shuffled())
    
    navigationItem.title = "HN"
    navigationController?.navigationBar.prefersLargeTitles = true
    setupTableView()
    
  }
  
  // MARK: - private
  private func setupTableView() {
    for (storyCellId, cellType) in storyCellIdTypeMap {
      storiesTableView.register(cellType, forCellReuseIdentifier: storyCellId)
    }
    
    storiesTableView.dataSource = self
    storiesTableView.delegate = self
    storiesTableView.addSubview(refreshControl)
    storiesTableView.rowHeight = UITableView.automaticDimension;
    storiesTableView.estimatedRowHeight = 128.0;
    
    view.addSubview(storiesTableView)
    
    storiesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    storiesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    storiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    storiesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    storiesTableView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func displayShareSheet(shareContent:String) {
    let activityViewController = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
    present(activityViewController, animated: true, completion: {})
  }
  
  // MARK: - StoryListPresentable
  func presentStoryWebController(story: Story) {
    if let storyUrl = story.url, let webUrl = URL(string: storyUrl) {
      let config = SFSafariViewController.Configuration()
      config.entersReaderIfAvailable = true
      config.barCollapsingEnabled = true
      let sfWebVC = SFSafariViewController(url: webUrl, configuration: config)
      sfWebVC.navigationItem.largeTitleDisplayMode = .never
      present(sfWebVC, animated: true)
    }
  }
  
  // MARK: - Listeners
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    listener?.getStories()
    refreshControl.endRefreshing()
  }
  
  func shareStory(cell: UITableViewCell) {
    guard let indexPath = storiesTableView.indexPath(for: cell),
      let story = listener?.stories[indexPath.row] else { return }
    
    let storyUrl = story.url ?? ""
    let shareContent = story.title + " " + storyUrl
    displayShareSheet(shareContent: shareContent)
  }
  
  func pushCommentsController(storyDetailViewController: ViewControllable) {
    if let navigationController = self.navigationController {
      navigationController.pushViewController(storyDetailViewController.uiviewController, animated: true)
    }
  }
  
  private static let storyImageLeftCellId = "storyImageLeftCellId"
  private static let storyImageRightCellId = "storyImageRightCellId"
  private static let storyImageTopCellId = "storyImageTopCellId"
  private static let storyNoImageCellId = "storyNoImageTopCellId"
  private let storyCellIds = [storyImageLeftCellId, storyImageRightCellId, storyImageTopCellId]
  private let storyCellIdTypeMap = [storyImageLeftCellId : StoryImageLeftViewCell.self,
                                    storyImageRightCellId : StoryImageRightViewCell.self,
                                    storyImageTopCellId: StoryImageTopViewCell.self,
                                    storyNoImageCellId: StoryNoImageViewCell.self]

}

extension StoryListViewController: UITableViewDataSource, UITableViewDelegate {
  // MARK: - UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listener?.stories.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard listener?.stories.count ?? 0 > indexPath.row,
      let story = listener?.stories[indexPath.row] else { return UITableViewCell() }
    
    let storyCellId: String
    if story.urlToImage?.count ?? 0 > 0 {
      // create a new cell if needed or reuse an old one
      let index = indexPath.row % shuffledStoryCellIds.count
      storyCellId = shuffledStoryCellIds[index]
    } else {
      storyCellId = StoryListViewController.storyNoImageCellId
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: storyCellId) as! StoryViewCell
    
    // set the text from the data model
    cell.title = story.title
    cell.url = story.url
    cell.imageUrl = story.urlToImage
    cell.time = story.time
    if let kids = story.kids {
      cell.kids = kids
    } else {
      cell.kids = []
    }
    cell.points = story.score ?? 0
    cell.listener = self
    
    return cell
  }
  
  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard indexPath.row < (listener?.storyIds.count ?? 0) - 1 && indexPath.row == (listener?.stories.count ?? 0) - 1 else { return }
    listener?.getStoryDetails(startIndex: indexPath.row + 1)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    listener?.selectedStory(atIndexPath: indexPath)
  }
  
  //Enable cell editing methods.
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    if let story = listener?.stories[indexPath.row] {
      
      let save = UITableViewRowAction(style: .normal, title: "Save") { [weak self] action, index in
        self?.listener?.saveStory(story: story)
      }
      //    if showBookmarked {
      //      save.title = "Remove"
      //    }
      save.backgroundColor = UIColor.gray
      
      let comments = UITableViewRowAction(style: .normal, title: "Comments") { [weak self] action, index in
        self?.listener?.showCommentsForStory(atIndexPath: index)
      }
      comments.backgroundColor = UIColor(red:0.61, green:0.15, blue:0.69, alpha:1.0)
      
      let share = UITableViewRowAction(style: .normal, title: "Share") { [weak self] action, index in
        let storyUrl = story.url ?? ""
        let shareContent = story.title + " " + storyUrl
        self?.displayShareSheet(shareContent: shareContent)
      }
      share.backgroundColor = UIColor.blue
      
      return [share, comments, save]
    }
    return[]
  }

}
