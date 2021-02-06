//
//  RssFeedInteractor.swift
//  NewsClient
//
//  Created by Vishal M on 2/24/19.
//  Copyright © 2019 Vishal M. All rights reserved.
//

import RIBs
import RxSwift

protocol RssFeedRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RssFeedPresentable: Presentable {
  var listener: RssFeedPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
  var storiesTableView: UITableView { get }
  func presentStoryWebController(story: Story)
}

protocol RssFeedListener: class {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RssFeedInteractor: PresentableInteractor<RssFeedPresentable>, RssFeedInteractable, RssFeedPresentableListener {

  weak var router: RssFeedRouting?
  weak var listener: RssFeedListener?
  
  let rssFeed: RssFeedResponse?
  var stories = [Story]()
  var rssFeeds = [RssFeedResponse]()
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(presenter: RssFeedPresentable, rssFeed: RssFeedResponse?) {
    self.rssFeed = rssFeed
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
  
  //MARK: - RssFeedPresentableListener
  func getStories() {
    stories.removeAll()
    getRssFeedStories()
  }
  
  func getStoryDetails(startIndex: Int) {
  }
  
  func getStory(atIndexPath indexPath: IndexPath) -> Story? {
    guard rssFeeds.count > indexPath.section,
      rssFeeds[indexPath.section].stories.count > indexPath.row else { return nil }
    return rssFeeds[indexPath.section].stories[indexPath.row]
  }
  
  func selectedStory(atIndexPath indexPath: IndexPath) {
    guard let story = getStory(atIndexPath: indexPath),
      story.url != nil else { return }
    presenter.presentStoryWebController(story: story)
  }
  
  func showCommentsForStory(atIndexPath: IndexPath) {
//    let story = stories[atIndexPath.row]
//    router?.routeToDetails(story: story)
  }
  
  
  //MARK :- private
  private func getRssFeedStories() {
    NewsRoomRequest.make(API.getRssJsonFeed(source: rssFeed?.source))
      .observeOn(MainScheduler.instance)
      .subscribe(onSuccess: { rssFeedResponse in
        self.rssFeeds = rssFeedResponse
        self.presenter.storiesTableView.reloadData()
      })
      { _ in }.disposeOnDeactivate(interactor: self)
  }

}
