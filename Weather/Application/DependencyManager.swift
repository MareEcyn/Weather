import Foundation

protocol DependencyManager: class {
    func makeRootCoordinator() -> AppCoordinator
    func makeHomeViewController(coordinator: AppCoordinator) -> HomeViewController
    func makeDetailViewController(coordinator: AppCoordinator) -> DetailViewController
}

class DependencyFactory: DependencyManager {
    private let sharedViewModel = HomeViewModel()
    func makeRootCoordinator() -> AppCoordinator { MainCoordinator(dependencyContainer: self) }
    
    func makeHomeViewController(coordinator: AppCoordinator) -> HomeViewController {
        HomeViewController(coordinator: coordinator, model: sharedViewModel)
    }
    
    func makeDetailViewController(coordinator: AppCoordinator) -> DetailViewController {
        DetailViewController(coordinator: coordinator, model: sharedViewModel)
    }
}
