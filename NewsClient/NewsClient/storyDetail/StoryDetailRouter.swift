//
//  StoryDetailRouter.swift
//  NewsClient


import RIBs

protocol StoryDetailInteractable: Interactable, StoryDetailListener {
    var router: StoryDetailRouting? { get set }
    var listener: StoryDetailListener? { get set }
}

protocol StoryDetailViewControllable: ViewControllable {
    func pushCommentsController(storyDetailViewController: ViewControllable)
}

final class StoryDetailRouter: ViewableRouter<StoryDetailInteractable, StoryDetailViewControllable>, StoryDetailRouting {

    private let storyDetailBuilder: StoryDetailBuildable
    
    init(interactor: StoryDetailInteractable,
         viewController: StoryDetailViewControllable,
         storyDetailBuilder: StoryDetailBuildable) {
        self.storyDetailBuilder = storyDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToCommentDetails(story: Story, comment: Comment) {
        let storyDetailRouter = storyDetailBuilder.build(story: story, startComment: comment, withListener: interactor)
        attachChild(storyDetailRouter)
        viewController.pushCommentsController(storyDetailViewController: storyDetailRouter.viewControllable)
    }
}
