//
//  StoryDetailViewController.swift
//  NewsClient
//

import RIBs
import RxSwift
import UIKit

protocol StoryDetailPresentableListener: class {
    func getComments(startIndex: Int)
    func commentSelected(atIndexPath: IndexPath)
}

final class StoryDetailViewController: UIViewController, StoryDetailPresentable, StoryDetailViewControllable,  UITableViewDelegate, UITableViewDataSource {
    
    weak var listener: StoryDetailPresentableListener?
    let commentsTableView = UITableView()
    
    private let commentCellId = "stroyCellId"
    private let story: Story
    private let startComment: Comment?
    var comments = [Comment]()
    
    init(story: Story, startComment: Comment? = nil) {
        self.story = story
        self.startComment = startComment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        setupTableView()
    }
    
    
    private func setupTableView() {
        commentsTableView.register(StoryViewCell.self, forCellReuseIdentifier: commentCellId)
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.estimatedRowHeight = 44.0;
        
        view.addSubview(commentsTableView)
        
        commentsTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        commentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        commentsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        commentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        commentsTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " " // otherwise header is not shown
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return comments.count
        }
    }
    
    fileprivate func setupComment(cell: StoryViewCell, comment: Comment) -> UITableViewCell {
        cell.htmlText = comment.text
//        cell.createdBy = comment.by
//        cell.time = comment.time
        if let kids = comment.kids, kids.count > 0 && comment.id != startComment?.id {
            cell.kids = kids
        } else {
            cell.kids = []
        }
        cell.points = 0
        cell.layoutMargins.left = 32
//      cell
        return cell
    }
    
    fileprivate func setupStory(cell: StoryViewCell) -> UITableViewCell {
        // set the text from the data model
      cell.title = story.title
        cell.url = story.url
//      cell.createdBy = story.by ?? ""
      cell.time = story.time
        cell.kids = []
      cell.points = story.score ?? 0
        cell.layoutMargins.left = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: commentCellId) as! StoryViewCell
        
        if indexPath.section == 0 {
            if let comment = startComment {
                return setupComment(cell: cell, comment: comment)
            }
            return setupStory(cell: cell)
        }
        return setupComment(cell: cell, comment: comments[indexPath.row])
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 8.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        listener?.getComments(startIndex: indexPath.row + 1)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 || comments[indexPath.row].kids?.count ?? 0 == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        listener?.commentSelected(atIndexPath: indexPath)
    }
    
    func pushCommentsController(storyDetailViewController: ViewControllable) {
        if let navigationController = self.navigationController {
            navigationController.pushViewController(storyDetailViewController.uiviewController, animated: true)
        }
    }
}

