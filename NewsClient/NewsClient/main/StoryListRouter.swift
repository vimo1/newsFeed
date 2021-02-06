//
//  StoryListRouter.swift
//  NewsClient


import RIBs

protocol StoryListInteractable: Interactable, StoryDetailListener {
    var router: StoryListRouting? { get set }
    var listener: StoryListListener? { get set }
}

protocol StoryListViewControllable: ViewControllable {
    func pushCommentsController(storyDetailViewController: ViewControllable)
}

final class StoryListRouter: ViewableRouter<StoryListInteractable, StoryListViewControllable>, StoryListRouting {
    
    private let storyDetailBuilder: StoryDetailBuildable
    
    init(interactor: StoryListInteractable,
         viewController: StoryListViewControllable,
         storyDetailBuilder: StoryDetailBuildable) {
        self.storyDetailBuilder = storyDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
        
    }
    
    func routeToDetails(story: Story) {
        let storyDetailRouter = storyDetailBuilder.build(story: story, withListener: interactor)
        attachChild(storyDetailRouter)
        viewController.pushCommentsController(storyDetailViewController: storyDetailRouter.viewControllable)
    }
}
