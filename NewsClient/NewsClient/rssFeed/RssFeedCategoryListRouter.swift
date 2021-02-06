//
//  RssFeedCategoryListRouter.swift
//  NewsClient
//
//  Created by Vishal M on 3/29/19.
//  Copyright © 2019 Vishal M. All rights reserved.
//

import RIBs

protocol RssFeedCategoryListInteractable: Interactable, RssFeedListener {
  var router: RssFeedCategoryListRouting? { get set }
  var listener: RssFeedCategoryListListener? { get set }
}

protocol RssFeedCategoryListViewControllable: ViewControllable {
  func pushRssFeed(viewController: ViewControllable)
}

final class RssFeedCategoryListRouter: ViewableRouter<RssFeedCategoryListInteractable, RssFeedCategoryListViewControllable>, RssFeedCategoryListRouting {
  
  private let rssFeedBuilder: RssFeedBuildable
  
  init(interactor: RssFeedCategoryListInteractable, viewController: RssFeedCategoryListViewControllable, rssFeedBuilder: RssFeedBuildable) {
    self.rssFeedBuilder = rssFeedBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func presentStories(feed: RssFeedResponse) {
    let rssFeedRouter = rssFeedBuilder.build(withListener: interactor, rssFeed: feed)
    attachChild(rssFeedRouter)
    viewController.pushRssFeed(viewController: rssFeedRouter.viewControllable)
  }
}
