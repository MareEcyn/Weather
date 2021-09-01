import UIKit

// MARK: - Protocols
protocol Coordinator: AnyObject {
    func start(with navigationController: UINavigationController)
}

protocol AppCoordinator: Coordinator {
    init(dependencyContainer container: DependencyManager)
    func showDetail(forCity city: CityWeather)
}

// MARK: - Implementation
class MainCoordinator: AppCoordinator {
    var navigationController: UINavigationController?
    private unowned var container: DependencyManager
    
    required init(dependencyContainer container: DependencyManager) {
        self.container = container
    }
    
    func start(with navigationController: UINavigationController) {
        let vc = container.makeHomeViewController(coordinator: self)
        self.navigationController = navigationController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showDetail(forCity city: CityWeather) {
        let vc = container.makeDetailViewController(coordinator: self, model: city)
        let navigationController = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
}
