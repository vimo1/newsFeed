import RxSwift

public protocol StorySourcesStream {
  var storySources: Observable<String?> { get }
}

public protocol MutableStorySourcesStream: StorySourcesStream {
  func update(storySources: String?)
}

class MutableStorySourcesStreamImpl: MutableStorySourcesStream {
  
  private let storySourcesSubject = ReplaySubject<String?>.create(bufferSize: 1)
  
  var storySources: Observable<String?> {
    return storySourcesSubject.asObservable()
  }
  
  func update(storySources: String?) {
    storySourcesSubject.onNext(storySources)
  }
}
