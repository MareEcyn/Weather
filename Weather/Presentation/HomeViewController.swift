// swiftlint:disable line_length

import UIKit

// MARK: - UIViewController life-cycle
class HomeViewController: UIViewController {
    private weak var coordinator: AppCoordinator?
    private let model: HomeViewModel
    private lazy var searchField: UITextField = { configureSearchField() }()
    private var tableView: UITableView!
    
    required init?(coder: NSCoder) { return nil }
    
    init(coordinator: AppCoordinator, model: HomeViewModel) {
        self.coordinator = coordinator
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        enableHidingKeyboard()
        searchField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UI methods
extension HomeViewController {
    private func setupUI() {
        view.backgroundColor = .white
        title = "Weather"
        navigationItem.backButtonTitle = ""
        let button = SearchButton(frame: .zero)
        button.setTitle("Поиск", for: .normal)
        button.backgroundColor = .interactivGreen
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.addTarget(self, action: #selector(searchCity), for: .touchUpInside)
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 16
        stack.autoresizesSubviews = false
        stack.addArrangedSubview(searchField)
        stack.addArrangedSubview(button)
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        let stackLeading = stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: +16)
        let stackTrailing = stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        let stackTop = stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: +16)
        NSLayoutConstraint.activate([stackLeading, stackTrailing, stackTop])
        
        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.id)
        view.addSubview(tableView)
        
        let colLeading = tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: +16)
        let colTrailing = tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        let colTop = tableView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: +16)
        let colBottom = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([colLeading, colTrailing, colTop, colBottom])
    }
    
    private func configureSearchField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Город..."
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .never
        textField.keyboardType = .webSearch
        textField.autocorrectionType = .no
        return textField
    }
}

// MARK: - Searching methods
extension HomeViewController {
    
    @objc private func searchCity() {
    }
}

// MARK: - UITextFieldDelegate conforming
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

// MARK: - UITableViewDataSource conforming
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.id, for: indexPath) as! CityCell
        cell.configure(city: "new york", temperature: "-300", weather: "well done")
        return cell
    }
}

// MARK: - UITableViewDelegate conforming
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.showDetail(forCity: "City name")
    }
}
