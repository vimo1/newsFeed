//
//  StoryListInteractor.swift
//  NewsClient
//


import RIBs
import UIKit
import Alamofire
import FirebaseAuth
import FirebaseDatabase
import SafariServices
import RxSwift

protocol StoryListRouting: ViewableRouting {
  func routeToDetails(story: Story)
}

protocol StoryListPresentable: Presentable {
  var listener: StoryListPresentableListener? { get set }
  var storiesTableView: UITableView { get }
  func presentStoryWebController(story: Story)
}

protocol StoryListListener: class {
}

final class StoryListInteractor: PresentableInteractor<StoryListPresentable>, StoryListInteractable, StoryListPresentableListener {
  
  weak var router: StoryListRouting?
  weak var listener: StoryListListener?
  
  private let showBookmarked: Bool
  var storyIds = [Int]()
  var stories = [Story]()
  private let storySourcesStream: StorySourcesStream
  private var selectedSources = ""
  
  init(showBookmarked: Bool, presenter: StoryListPresentable, storySourcesStream: StorySourcesStream) {
    self.showBookmarked = showBookmarked
    self.storySourcesStream = storySourcesStream
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    storySourcesStream.storySources
      .subscribe(onNext: { (selectedSources: String?) in
        if let selectedSources = selectedSources {
          self.selectedSources = selectedSources
          self.getStories()
        }
      }).disposeOnDeactivate(interactor: self)
  }
  
  override func willResignActive() {
    super.willResignActive()
  }

  // MARK: - StoryListPresentableListener
  func getStories() {
    stories.removeAll()
    if !self.selectedSources.isEmpty {
      self.getStoriesForSources(sources: selectedSources)
    }
    getNewsOrgHeadlines()
//    getHacerNewsStories()
  }
  
  func saveStory(story: Story) {
    if let _ = Auth.auth().currentUser/*, let storyId = story.id*/ {
      if showBookmarked {
        //                ServiceApis.removeStory(ref: ref, storyId: storyId)
        getSavedStories()
      } else {
        ServiceApis.saveStory(story: story)
      }
    }
  }
  
  func getNewsOrgHeadlines() {
    print("refreshing stories")
    if showBookmarked {
      getSavedStories()
      return
    }
    
    NewsApiRequest.make(API.getTopHeadlines())
      .observeOn(MainScheduler.instance)
      .subscribe(onSuccess: { (topHeadlinesResponse) in
        self.stories.append(contentsOf: topHeadlinesResponse.articles)
        self.presenter.storiesTableView.reloadData()
      }) { (error) in
        print(error)
      }.disposeOnDeactivate(interactor: self)
  }
  
  //MARK :- private
  private func getHacerNewsStories() {
    HackerNewsRequest.make(API.getNewStories())
      .observeOn(MainScheduler.instance)
      .subscribe(onSuccess: {storyIds in
        self.storyIds.removeAll()
        self.storyIds.append(contentsOf: storyIds)
        self.getStoryDetails(startIndex: 0)
        })
      { _ in }.disposeOnDeactivate(interactor: self)
  }
  
  private func getStoriesForSources(sources: String) {
    guard !sources.isEmpty else { return }
    NewsApiRequest.make(API.getTopHeadlines(sources: sources))
      .observeOn(MainScheduler.instance)
      .subscribe(onSuccess: { (topHeadlinesResponse) in
        print(topHeadlinesResponse)
        self.stories.append(contentsOf: topHeadlinesResponse.articles)
        self.presenter.storiesTableView.reloadData()
      }) { (error) in
        print(error)
      }.disposeOnDeactivate(interactor: self)
  }
  
  func getSavedStories() {
    //        ServiceApis.getSavedStories(ref: ref)
    //            .observeOn(MainScheduler.instance)
    //            .subscribe(onSuccess: { [weak self] result in
    //                self?.storyIds.removeAll()
    //                self?.stories.removeAll()
    //                self?.storyIds.append(contentsOf: result.0)
    //                self?.stories.append(contentsOf: result.1)
    //                self?.presenter.storiesTableView.reloadData()
    //            }) { err in
    //                print(err)
    //            }.disposed(by: disposeBag)
  }
  
  func getStoryDetails(startIndex: Int) {
    guard startIndex < storyIds.count else { return }
    let pageSize = 10
    let endIndex = (startIndex + pageSize < storyIds.count) ? startIndex + (pageSize - 1) : storyIds.count - 1;
    
    let subArray = storyIds[startIndex...endIndex]
    Observable.from(subArray)
      .flatMap { (storyId) -> Single<Story> in
        HackerNewsRequest.make(API.getStory(forId: String(storyId)))
      }
      .toArray()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] stories in
        self?.stories.append(contentsOf: stories)
        self?.presenter.storiesTableView.reloadData()
      })
      .disposeOnDeactivate(interactor: self)
  }
  
  func selectedStory(atIndexPath: IndexPath) {
    let story = stories[atIndexPath.row]
    if story.url != nil {
      //      pushStoryWebController(story: story)
      presenter.presentStoryWebController(story: story)
    } else {
      router?.routeToDetails(story: story)
      //      pushCommentsController(story: story)
    }
  }
  
  func showCommentsForStory(atIndexPath: IndexPath) {
    let story = stories[atIndexPath.row]
    router?.routeToDetails(story: story)
  }
}

