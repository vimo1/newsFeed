import RIBs
import FirebaseDatabase

protocol RootDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class RootComponent: Component<RootDependency>, StoryListDependency, SourceDependency, RssFeedDependency, RssFeedCategoryListDependency {
  
  var userStream: UserStream {
    return mutableUserStream
  }
  
  var storySourcesStream: StorySourcesStream {
    return mutableStorySourcesStream
  }
  
  var databaseReference: DatabaseReference {
    return shared { Database.database().reference() }
  }
  
  var mutableStorySourcesStream: MutableStorySourcesStream {
    return shared { MutableStorySourcesStreamImpl() }
  }
  
  //#pragma :- fileprivate
  fileprivate var mutableUserStream: MutableUserStream {
    return shared { MutableUserStreamImpl() }
  }
  
}

// MARK: - Builder

protocol RootBuildable: Buildable {
  func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {
  
  override init(dependency: RootDependency) {
    super.init(dependency: dependency)
  }
  
  func build() -> LaunchRouting {
    let component = RootComponent(dependency: dependency)
    let viewController = RootViewController()
    
    let interactor = RootInteractor(presenter: viewController,
                                    mutableUserStream: component.mutableUserStream,
                                    mutableStorySourcesStream: component.mutableStorySourcesStream,
                                    databaseReference: component.databaseReference)
    
    let storyListBuilder = StoryListBuilder(dependency: component)
    let rssFeedBuilder = RssFeedBuilder(dependency: component)
    let sourceBuilder = SourceBuilder(dependency: component)
    let rssFeedCategoryListBuilder = RssFeedCategoryListBuilder(dependency: component)
    return RootRouter(interactor: interactor,
                      viewController: viewController,
                      storyListBuilder: storyListBuilder,
                      rssFeedBuilder: rssFeedBuilder,
                      sourceBuilder: sourceBuilder,
                      rssFeedCategoryListBuilder: rssFeedCategoryListBuilder)
  }
}
