import UIKit

class DetailViewController: UIViewController {
    private weak var coordinator: AppCoordinator?
    private let model: HomeViewModel
    
    required init?(coder: NSCoder) { return nil }
    
    init(coordinator: AppCoordinator, model: HomeViewModel) {
        self.coordinator = coordinator
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(close))
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}
