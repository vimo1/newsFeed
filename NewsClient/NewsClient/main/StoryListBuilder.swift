//
//  StoryListBuilder.swift
//  NewsClient
//

import RIBs
import FirebaseDatabase

protocol StoryListDependency: Dependency {
  var storySourcesStream: StorySourcesStream { get }
  var databaseReference: DatabaseReference { get }
}

final class StoryListComponent: Component<StoryListDependency>, StoryDetailDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol StoryListBuildable: Buildable {
    func build(showBookmarked: Bool, withListener listener: StoryListListener) -> StoryListRouting
}

final class StoryListBuilder: Builder<StoryListDependency>, StoryListBuildable {

    override init(dependency: StoryListDependency) {
        super.init(dependency: dependency)
    }

    func build(showBookmarked: Bool, withListener listener: StoryListListener) -> StoryListRouting {
        let component = StoryListComponent(dependency: dependency)
        let viewController = StoryListViewController()
      let interactor = StoryListInteractor(showBookmarked: showBookmarked,
                                           presenter: viewController,
                                           storySourcesStream: component.dependency.storySourcesStream)
        interactor.listener = listener
      
      let storyDetailBuilder = StoryDetailBuilder(dependency: component)
      return StoryListRouter(interactor: interactor, viewController: viewController, storyDetailBuilder: storyDetailBuilder)
    }
}

extension StoryListBuildable {
  func build(withListener listener: StoryListListener) -> StoryListRouting {
    return build(showBookmarked: false, withListener: listener)
  }
}
