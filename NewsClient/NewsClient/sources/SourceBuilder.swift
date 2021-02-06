import RIBs

protocol SourceDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
  var mutableStorySourcesStream: MutableStorySourcesStream { get }
}

final class SourceComponent: Component<SourceDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SourceBuildable: Buildable {
    func build(withListener listener: SourceListener) -> SourceRouting
}

final class SourceBuilder: Builder<SourceDependency>, SourceBuildable {

    override init(dependency: SourceDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SourceListener) -> SourceRouting {
        let component = SourceComponent(dependency: dependency)
        let viewController = SourceViewController()
      let interactor = SourceInteractor(presenter: viewController, mutableStorySourcesStream: component.dependency.mutableStorySourcesStream)
        interactor.listener = listener
        return SourceRouter(interactor: interactor, viewController: viewController)
    }
}
