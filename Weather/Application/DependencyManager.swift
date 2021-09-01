import Foundation

protocol DependencyManager: AnyObject {
    func makeRootCoordinator() -> AppCoordinator
    func makeHomeViewController(coordinator: AppCoordinator) -> HomeViewController
    func makeDetailViewController(coordinator: AppCoordinator, model: CityWeather) -> DetailViewController
}

class DependencyFactory: DependencyManager {
    private let sharedViewModel = HomeViewModel()
    func makeRootCoordinator() -> AppCoordinator { MainCoordinator(dependencyContainer: self) }
    
    func makeHomeViewController(coordinator: AppCoordinator) -> HomeViewController {
        HomeViewController(coordinator: coordinator, model: HomeViewModel())
    }
    
    func makeDetailViewController(coordinator: AppCoordinator, model: CityWeather) -> DetailViewController {
        DetailViewController(coordinator: coordinator, model: model)
    }
}
