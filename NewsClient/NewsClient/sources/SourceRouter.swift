import RIBs

protocol SourceInteractable: Interactable {
    var router: SourceRouting? { get set }
    var listener: SourceListener? { get set }
}

protocol SourceViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SourceRouter: ViewableRouter<SourceInteractable, SourceViewControllable>, SourceRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SourceInteractable, viewController: SourceViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
