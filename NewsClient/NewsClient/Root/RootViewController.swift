import RIBs
import UIKit

protocol RootPresentableListener: class {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class RootViewController: UITabBarController, RootPresentable, RootViewControllable {
  
  var tabBarList = [UIViewController]()
  weak var listener: RootPresentableListener?
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Method is not supported")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - RootViewControllable
  
  func present() {
    viewControllers = tabBarList
  }
  
  func addTab(viewController: ViewControllable,
              withNavigation: Bool,
              tabBarItem: UITabBarItem) {
    var tabVC: UIViewController
    
    if withNavigation {
      tabVC = UINavigationController(rootViewController: viewController.uiviewController)
    } else {
      tabVC = viewController.uiviewController
    }
    tabVC.tabBarItem = tabBarItem
    tabBarList.append(tabVC)
  }
}
