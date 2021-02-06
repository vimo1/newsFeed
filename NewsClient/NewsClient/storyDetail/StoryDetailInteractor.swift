//
//  StoryDetailInteractor.swift
//  NewsClient


import RIBs
import RxSwift

protocol StoryDetailRouting: ViewableRouting {
    func routeToCommentDetails(story: Story, comment: Comment)
}

protocol StoryDetailPresentable: Presentable {
    var listener: StoryDetailPresentableListener? { get set }
    var commentsTableView: UITableView { get }
    var comments: [Comment] { get set }
    
}

protocol StoryDetailListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class StoryDetailInteractor: PresentableInteractor<StoryDetailPresentable>, StoryDetailInteractable, StoryDetailPresentableListener {
    
    weak var router: StoryDetailRouting?
    weak var listener: StoryDetailListener?
    
    private var comments = [Comment]()
    private var commentIds = [Int]()
    private let story: Story
    private let startComment: Comment?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: StoryDetailPresentable,
                    story: Story,
                    startComment: Comment? = nil) {

        self.story = story
        self.startComment = startComment
        
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        if let kids = startComment?.kids ?? story.kids {
            commentIds.append(contentsOf: kids)
        }
        getComments(startIndex: 0)
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    //MARK: - StoryDetailPresentableListener
    
    func getComments(startIndex: Int) {
        guard startIndex < commentIds.count - 1 && startIndex == comments.count else { return }
        let endIndex = (startIndex + 9 < commentIds.count) ? startIndex + 9 : commentIds.count - 1;
        
        let subArray = commentIds[startIndex...endIndex]
        var commentsReceived = 0;
        
        for storyId in subArray {
          HackerNewsRequest.make(API.getComment(forId: String(storyId)))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { (comment) in
              self.comments.append(comment)
              commentsReceived += 1
              if commentsReceived == subArray.count {
                self.presenter.comments = self.comments
                self.presenter.commentsTableView.reloadData()
              }
            }).disposeOnDeactivate(interactor: self)          
        }
    }
    
    func commentSelected(atIndexPath: IndexPath) {
        let comment = comments[atIndexPath.row]
        router?.routeToCommentDetails(story: story, comment: comment)
    }
}
