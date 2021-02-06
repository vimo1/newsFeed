//
//  StoryDetailBuilder.swift
//  NewsClient


import RIBs

protocol StoryDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class StoryDetailComponent: Component<StoryDetailDependency>, StoryDetailDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol StoryDetailBuildable: Buildable {
    func build(story: Story, startComment: Comment?, withListener listener: StoryDetailListener) -> StoryDetailRouting
}

final class StoryDetailBuilder: Builder<StoryDetailDependency>, StoryDetailBuildable {
    override init(dependency: StoryDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(story: Story,
               startComment: Comment? = nil,
               withListener listener: StoryDetailListener) -> StoryDetailRouting {
        let component = StoryDetailComponent(dependency: dependency)
        let viewController = StoryDetailViewController(story: story)
        let interactor = StoryDetailInteractor(presenter: viewController, story: story, startComment: startComment)
        interactor.listener = listener
        
        let storyDetailBuilder = StoryDetailBuilder(dependency: component)
        return StoryDetailRouter(interactor: interactor,
                                 viewController: viewController,
                                 storyDetailBuilder: storyDetailBuilder)
    }
}

extension StoryDetailBuildable {
    func build(story: Story, withListener listener: StoryDetailListener) -> StoryDetailRouting {
        return build(story: story, startComment: nil, withListener: listener)
    }
}
