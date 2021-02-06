//
//  RssFeedCategoryListBuilder.swift
//  NewsClient


import RIBs

protocol RssFeedCategoryListDependency: Dependency {
  var storySourcesStream: StorySourcesStream { get }
}

final class RssFeedCategoryListComponent: Component<RssFeedCategoryListDependency>, RssFeedDependency {
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RssFeedCategoryListBuildable: Buildable {
  func build(withListener listener: RssFeedCategoryListListener) -> RssFeedCategoryListRouting
}

final class RssFeedCategoryListBuilder: Builder<RssFeedCategoryListDependency>, RssFeedCategoryListBuildable {
  
  override init(dependency: RssFeedCategoryListDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: RssFeedCategoryListListener) -> RssFeedCategoryListRouting {
    let component = RssFeedCategoryListComponent(dependency: dependency)
    let viewController = RssFeedCategoryListViewController()
    let interactor = RssFeedCategoryListInteractor(presenter: viewController, storySourcesStream: component.dependency.storySourcesStream)
    interactor.listener = listener
    
    let rssFeedBuilder = RssFeedBuilder(dependency: component)
    return RssFeedCategoryListRouter(interactor: interactor,
                                     viewController: viewController,
                                     rssFeedBuilder: rssFeedBuilder)
  }
}
