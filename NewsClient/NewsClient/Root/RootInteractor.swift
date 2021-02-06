import RIBs
import RxSwift
import FirebaseAuth
import FirebaseDatabase

protocol RootRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RootPresentable: Presentable {
  var listener: RootPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RootListener: class {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {
  
  weak var router: RootRouting?
  weak var listener: RootListener?
  
  private let mutableUserStream: MutableUserStream
  private let mutableStorySourcesStream: MutableStorySourcesStream
  private let databaseReference: DatabaseReference
  private var userId: String?
  
  init(presenter: RootPresentable,
       mutableUserStream: MutableUserStream,
       mutableStorySourcesStream: MutableStorySourcesStream,
       databaseReference: DatabaseReference) {
    self.mutableUserStream = mutableUserStream
    self.mutableStorySourcesStream = mutableStorySourcesStream
    self.databaseReference = databaseReference
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    userId = UserDefaults.standard.string(forKey: "userId")
    if userId == nil {
      Auth.auth().signInAnonymously() { [weak self] (result, error) in
        self?.userId = result?.user.uid
        if let userId = self?.userId {
          UserDefaults.standard.set(userId, forKey: "userId")
        }
        self?.getSavedSources()
      }
    } else {
      getSavedSources()
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  private func getSavedSources() {
    guard let userId = self.userId else { return }
    ServiceApis.configure(userID: userId, databaseReference: databaseReference)
    let user = User(userId: userId)
    self.mutableUserStream.update(user: user)
    
    ServiceApis.getSavedSources()
      .observeOn(MainScheduler.instance)
      .subscribe(onSuccess: { (sources:String) in
        self.mutableStorySourcesStream.update(storySources: sources)
      }, onError: { (error) in
        print(error)
    }).disposeOnDeactivate(interactor: self)
  }
}
