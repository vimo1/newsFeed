import RIBs

protocol RootInteractable: Interactable, StoryListListener, SourceListener, RssFeedListener, RssFeedCategoryListListener {
  var router: RootRouting? { get set }
  var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
  func addTab(viewController: ViewControllable,
              withNavigation: Bool,
              tabBarItem: UITabBarItem)
  func present()
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
  
  init(interactor: RootInteractable,
       viewController: RootViewControllable,
       storyListBuilder: StoryListBuildable,
       rssFeedBuilder: RssFeedBuilder,
       sourceBuilder: SourceBuildable,
       rssFeedCategoryListBuilder: RssFeedCategoryListBuildable) {
    self.storyListBuilder = storyListBuilder
    self.rssFeedBuilder = rssFeedBuilder
    self.sourceBuilder = sourceBuilder
    self.rssFeedCategoryListBuilder = rssFeedCategoryListBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  override func didLoad() {
    super.didLoad()
    
    let storyListRouter = storyListBuilder.build(withListener: interactor)
    self.storyListRouter = storyListRouter
    attachChild(storyListRouter)
    viewController.addTab(viewController: storyListRouter.viewControllable,
                          withNavigation: true, tabBarItem: UITabBarItem(tabBarSystemItem: .featured, tag: 0))
    
    
    
//    let rssFeedRouter = rssFeedBuilder.build(withListener: interactor)
//    self.favListRouter = rssFeedRouter
//    attachChild(rssFeedRouter)
//    viewController.addTab(viewController: rssFeedRouter.viewControllable,
//                          withNavigation: true, tabBarItem: UITabBarItem(title: "Feed", image: UIImage(named: "rss_feed_36pt"), tag: 1))
    
    let rssFeedCategoryListRouter = rssFeedCategoryListBuilder.build(withListener: interactor)
    self.rssFeedCategoryListRouter = rssFeedCategoryListRouter
    attachChild(rssFeedCategoryListRouter)
    viewController.addTab(viewController: rssFeedCategoryListRouter.viewControllable,
                          withNavigation: true, tabBarItem: UITabBarItem(title: "Feed2", image: UIImage(named: "rss_feed_36pt"), tag: 3))
    
    let sourceRouter = sourceBuilder.build(withListener: interactor)
    self.sourceRouter = sourceRouter
    attachChild(sourceRouter)
    viewController.addTab(viewController: sourceRouter.viewControllable,
                          withNavigation: true, tabBarItem: UITabBarItem(tabBarSystemItem: .search, tag: 2))
    
    viewController.present()
  }
  
  // MARK: - Private
  
  private let storyListBuilder: StoryListBuildable
  private let rssFeedBuilder: RssFeedBuildable
  private let sourceBuilder: SourceBuildable
  private let rssFeedCategoryListBuilder: RssFeedCategoryListBuildable
  
  private var storyListRouter: ViewableRouting?
  private var favListRouter: ViewableRouting?
  private var sourceRouter: ViewableRouting?
  private var rssFeedCategoryListRouter: ViewableRouting?
}
