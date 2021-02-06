import RxSwift

public protocol UserStream {
  var user: Observable<User> { get }
}

public protocol MutableUserStream: UserStream {
  func update(user: User)
}

class MutableUserStreamImpl: MutableUserStream {
  private let userSubject = ReplaySubject<User>.create(bufferSize: 1)
  
  var user: Observable<User> {
    return userSubject.asObservable()
  }
  
  func update(user: User) {
    userSubject.onNext(user)
  }
}
