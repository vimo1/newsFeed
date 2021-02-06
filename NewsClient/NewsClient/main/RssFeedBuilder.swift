//
//  RssFeedBuilder.swift
//  NewsClient
//

import RIBs
import FirebaseDatabase

protocol RssFeedDependency: Dependency {
}

final class RssFeedComponent: Component<RssFeedDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RssFeedBuildable: Buildable {
  func build(withListener listener: RssFeedListener, rssFeed: RssFeedResponse?) -> RssFeedRouting
}

final class RssFeedBuilder: Builder<RssFeedDependency>, RssFeedBuildable {
  
  override init(dependency: RssFeedDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: RssFeedListener, rssFeed: RssFeedResponse?) -> RssFeedRouting {
    let viewController = RssFeedViewController()
    let interactor = RssFeedInteractor(presenter: viewController, rssFeed: rssFeed)
    interactor.listener = listener
    return RssFeedRouter(interactor: interactor, viewController: viewController)
  }
}
