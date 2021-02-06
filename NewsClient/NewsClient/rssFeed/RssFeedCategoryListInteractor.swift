//
//  RssFeedCategoryListInteractor.swift
//  NewsClient
//
//  Created by Vishal M on 3/29/19.
//  Copyright © 2019 Vishal M. All rights reserved.
//

import RIBs
import RxSwift

protocol RssFeedCategoryListRouting: ViewableRouting {
  func presentStories(feed: RssFeedResponse)
}

protocol RssFeedCategoryListPresentable: Presentable {
  var listener: RssFeedCategoryListPresentableListener? { get set }
  var feedCategoriesCollectionView: UICollectionView { get }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RssFeedCategoryListListener: class {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

typealias FeedsByCategory = (category: String, feeds:[RssFeedResponse])

final class RssFeedCategoryListInteractor: PresentableInteractor<RssFeedCategoryListPresentable>, RssFeedCategoryListInteractable, RssFeedCategoryListPresentableListener {  
  weak var router: RssFeedCategoryListRouting?
  weak var listener: RssFeedCategoryListListener?
  
  private let storySourcesStream: StorySourcesStream
  var stories = [Story]()
  var rssFeeds = [FeedsByCategory]()
  
  init(presenter: RssFeedCategoryListPresentable, storySourcesStream: StorySourcesStream) {
    self.storySourcesStream = storySourcesStream
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // business logic here.
    getStories()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func getStories() {
    stories.removeAll()
    getRssFeedStories()
  }
  
  func getFeedFor(indexPath: IndexPath) -> RssFeedResponse? {
    guard rssFeeds.count > indexPath.section else {
      return nil
    }
    return (rssFeeds[indexPath.section]).feeds[indexPath.row]
  }
  
  func selectedFeed(atIndexPath indexPath: IndexPath) {
    if let feed = getFeedFor(indexPath: indexPath) {
      router?.presentStories(feed: feed)
    }
  }
  
  //MARK :- private
  private func getRssFeedStories() {
    NewsRoomRequest.make(API.getRssJsonFeed())
      .observeOn(MainScheduler.instance)
      .subscribe(onSuccess: { rssFeedResponse in
        self.buildRssFeeds(rssFeedResponse: rssFeedResponse)
        self.presenter.feedCategoriesCollectionView.reloadData()
      })
      { _ in }.disposeOnDeactivate(interactor: self)
  }
  
  private func buildRssFeeds(rssFeedResponse: [RssFeedResponse]) {
    var mapCategoryFeed = [String:[RssFeedResponse]]()
    
    for rssFeed in rssFeedResponse {
      for category in rssFeed.categories {
        if mapCategoryFeed[category] != nil {
          mapCategoryFeed[category]?.append(rssFeed)
        } else {
          mapCategoryFeed[category] = [rssFeed]
        }
      }
    }
    
    for (key, value) in mapCategoryFeed {
      rssFeeds.append(FeedsByCategory(key, value))
    }
  }
}
