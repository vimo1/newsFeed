import RIBs
import RxSwift
import UIKit
import SafariServices

protocol SourcePresentableListener: class {
  var exploreViewModel: ExploreViewModel? { get }
  var selectedSources: Set<String> { get }
  
  func source(selected: Bool, atIndexPath: IndexPath)
  func saveSources()
  func search(for: String)
}

final class SourceViewController: UIViewController, SourcePresentable, SourceViewControllable, SourceViewCellListener, StoryViewCellListener, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
  
  weak var listener: SourcePresentableListener?
  
  let sourcesTableView = UITableView()
  var searchController = UISearchController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Sources"
    navigationController?.navigationBar.prefersLargeTitles = false
    setupTableView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    listener?.saveSources()
    super.viewWillDisappear(animated)
  }
  
  private func setupTableView() {
    
    sourcesTableView.register(SourceViewCell.self, forCellReuseIdentifier: sourceCellId)
    sourcesTableView.register(CategoryHeaderViewCell.self, forCellReuseIdentifier: headerCellId)
    sourcesTableView.register(StoryImageRightViewCell.self, forCellReuseIdentifier: storyImageRightCellId)
    
    sourcesTableView.dataSource = self
    sourcesTableView.delegate = self
    sourcesTableView.rowHeight = UITableView.automaticDimension;
    sourcesTableView.estimatedRowHeight = 64.0;
    
    view.addSubview(sourcesTableView)
    
    sourcesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    sourcesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    sourcesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    sourcesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    sourcesTableView.translatesAutoresizingMaskIntoConstraints = false
    
    searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
    searchController.delegate = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
    
    definesPresentationContext = true
    
    if #available(iOS 11.0, *) {
      // For iOS 11 and later, place the search bar in the navigation bar.
      navigationItem.searchController = searchController
    } else {
      // For iOS 10 and earlier, place the search controller's search bar in the table view's header.
      sourcesTableView.tableHeaderView = searchController.searchBar
      sourcesTableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.size.height)
    }
  }
  
  func reloadData() {
    sourcesTableView.reloadData()
  }
  
  // MARK: - SourcePresentable
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
  
  // MARK: - SourceViewCellListener
  func switchToggled(for cell: SourceViewCell) {
    if let indexPath = sourcesTableView.indexPath(for: cell) {
      listener?.source(selected: cell.isSourceSelected, atIndexPath: indexPath)
    }
  }
  
  // MARK: - StoryViewCellListener
  func shareStory(cell: UITableViewCell) {
    guard let indexPath = sourcesTableView.indexPath(for: cell),
      let sourcesViewModel = listener?.exploreViewModel?.items[indexPath.section],
      sourcesViewModel.type == .story,
      let storyViewModel = sourcesViewModel as? StoryExploreViewModelItem else { return }
    
    let story = storyViewModel.stories[indexPath.row]
    
    let storyUrl = story.url ?? ""
    let shareContent = story.title + " " + storyUrl
    displayShareSheet(shareContent: shareContent)
  }
  
  // MARK: - UISearchResultsUpdating
  
  func updateSearchResults(for searchController: UISearchController) {
    // Strip out all the leading and trailing spaces.
    let whitespaceCharacterSet = CharacterSet.whitespaces
    let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
    listener?.search(for: strippedString)
  }
  
  private func displayShareSheet(shareContent:String) {
    let activityViewController = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
    present(activityViewController, animated: true, completion: {})
  }
  
  private let sourceCellId = "sourceCellId"
  private let headerCellId = "headerCellId"
  private let storyImageRightCellId = "stroyImageRightCellId"
}

// MARK: - UITableViewDataSource

extension SourceViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return listener?.exploreViewModel?.items.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listener?.exploreViewModel?.items[section].rowCount ?? 0
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if listener?.exploreViewModel?.items[section].rowCount ?? 0 > 0 {
      return listener?.exploreViewModel?.items[section].sectionName.uppercased()
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let sourcesViewModel = listener?.exploreViewModel?.items[indexPath.section] else { return UITableViewCell() }
    
    // create a new cell if needed or reuse an old one
    
    switch sourcesViewModel.type {
    case .source:
      if let sourcesExploreViewModelItem = sourcesViewModel as? SourceExploreViewModelItem {
        let sourceViewCell = tableView.dequeueReusableCell(withIdentifier: sourceCellId) as! SourceViewCell
        let source = sourcesExploreViewModelItem.sources[indexPath.row]
        sourceViewCell.title = source.name
        sourceViewCell.isSourceSelected = listener?.selectedSources.contains(source.id) ?? false
        sourceViewCell.listener = self
        return sourceViewCell
      }
    case .story:
        if let storyExploreViewModelItem = sourcesViewModel as? StoryExploreViewModelItem {
        let storyViewCell = tableView.dequeueReusableCell(withIdentifier: storyImageRightCellId) as! StoryImageRightViewCell
        let story = storyExploreViewModelItem.stories[indexPath.row]
        
        // set the text from the data model
        storyViewCell.title = story.title
        storyViewCell.url = story.url
        storyViewCell.imageUrl = story.urlToImage
        storyViewCell.time = story.time
        storyViewCell.listener = self
        return storyViewCell
      }
    }
    
    return UITableViewCell()
  }
  
  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let sourcesViewModel = listener?.exploreViewModel?.items[indexPath.section],
      sourcesViewModel.type == .story,
      let storyViewModel = sourcesViewModel as? StoryExploreViewModelItem else { return }
    let story = storyViewModel.stories[indexPath.row]
    presentStoryWebController(story: story)
  }
}
