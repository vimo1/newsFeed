import RIBs
import RxSwift
import FirebaseDatabase

protocol SourceRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SourcePresentable: Presentable {
  var listener: SourcePresentableListener? { get set }
  
  func reloadData()
}

protocol SourceListener: class {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SourceInteractor: PresentableInteractor<SourcePresentable>, SourceInteractable, SourcePresentableListener {
  
  weak var router: SourceRouting?
  weak var listener: SourceListener?
  
  var exploreViewModel: ExploreViewModel?
  var selectedSources = Set<String>()
  
  private var allSources: [Source] = []
  private var filteredSources: [Source] = []
  private let mutableStorySourcesStream: MutableStorySourcesStream
  private let updateStorySourcesSubject = PublishSubject<String>.init()
  private let searchQuerySubject = PublishSubject<String>.init()
  
  init(presenter: SourcePresentable, mutableStorySourcesStream: MutableStorySourcesStream) {
    self.mutableStorySourcesStream = mutableStorySourcesStream
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    getSources()
    
    updateStorySourcesSubject.asObservable()
    .debounce(5, scheduler: MainScheduler.instance)
    .distinctUntilChanged()
      .subscribe(onNext: { (selectedSources:String) in
        self.mutableStorySourcesStream.update(storySources: selectedSources)
        ServiceApis.saveSources(sources: selectedSources)
      }).disposeOnDeactivate(interactor: self)
    
    searchQuerySubject.asObservable()
      .debounce(3, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(onNext: { (query: String) in
        self.getSearchResults(query: query)
      }).disposeOnDeactivate(interactor: self)
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  func getSources() {
    NewsApiRequest.make(API.getSources()).asObservable()
      .observeOn(MainScheduler.instance)
      .withLatestFrom(mutableStorySourcesStream.storySources) { ($0, $1) }
      .subscribe(onNext: { (arg0) in
        let (sourcesResponse, storySources) = arg0
        if let storySources = storySources {
          let sources = storySources.components(separatedBy: ",")
          sources.forEach({ (source:String) in
            self.selectedSources.insert(source)
          })
        }
        self.allSources = sourcesResponse.sources
        self.filteredSources = self.allSources
        self.exploreViewModel = ExploreViewModel(sources: sourcesResponse.sources)
        self.presenter.reloadData()
      }).disposeOnDeactivate(interactor: self)
  }
  
  private func getSearchResults(query: String) {
    guard !query.isEmpty else { return }
    NewsApiRequest.make(API.search(query: query))
      .asObservable()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { (response: TopHeadlinesResponse) in
        self.exploreViewModel = ExploreViewModel(sources: self.filteredSources, stories: response.articles)
        self.presenter.reloadData()
      }).disposeOnDeactivate(interactor: self)
  }
  
  func source(selected: Bool, atIndexPath: IndexPath) {
    if let sourceViewModelItem = exploreViewModel?.items[atIndexPath.section] as? SourceExploreViewModelItem,
      sourceViewModelItem.sources.count > atIndexPath.row {
      let sourceValue = sourceViewModelItem.sources[atIndexPath.row]
      if selected {
        selectedSources.insert(sourceValue.id)
      } else {
        selectedSources.remove(sourceValue.id)
      }
    }

    updateStorySourcesSubject.onNext(selectedSources.joined(separator: ","))
  }
  
  func saveSources() {
    ServiceApis.saveSources(sources: selectedSources.joined(separator: ","))
  }
  
  func search(for query: String) {
    filteredSources = allSources.filter { $0.name.starts(with: query) }
    self.exploreViewModel = ExploreViewModel(sources: filteredSources)
    self.presenter.reloadData()
    
    searchQuerySubject.onNext(query)
  }
}
