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
        model.loadWeatherList(onSuccess: { [unowned self] in
            self.tableView.reloadData()
        }, onError: { [unowned self] in
            let alert = UIAlertController(title: "Ошибка",
                                          message: "Для некоторых городов не удалось загрузить данные о погоде",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            self.present(alert, animated: true, completion: nil)
        })
    }
}

// MARK: - Methods for configure UI
extension HomeViewController {
    private func setupUI() {
        view.backgroundColor = .white
        title = "Погода"
        navigationItem.backButtonTitle = ""
        let button = SearchButton(frame: .zero)
        button.setTitle("Поиск", for: .normal)
        button.backgroundColor = .interactivGreen
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(searchCity), for: .touchUpInside)
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
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
        
        tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.id)
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        let tableViewLeading = tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: +16)
        let tableViewTrailing = tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        let tableViewTop = tableView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: +16)
        let tableViewBottom = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([tableViewLeading, tableViewTrailing, tableViewTop, tableViewBottom])
    }
    
    private func configureSearchField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Город..."
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .never
        textField.keyboardType = .webSearch
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }
}

// MARK: - Searching methods
extension HomeViewController {
    @objc private func searchCity() {
        guard let cityName = searchField.text, cityName != "" else { return }
        model.loadWeather(for: cityName, onSuccess: { [unowned self] cityWeather in
            self.coordinator?.showDetail(forCity: cityWeather)
        }, onError: { [unowned self] (cityName) in
            let alert = UIAlertController(title: "Ошибка",
                                          message: "Не удалось загрузить данные о погоде в г. \(cityName)",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            self.present(alert, animated: true, completion: nil)
        })
    }
}

// MARK: - UITextFieldDelegate conforming
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchCity()
        return true
    }
}

// MARK: - UITableViewDataSource conforming
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.citiesWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CityCell(style: .default, reuseIdentifier: CityCell.id)
        guard !model.citiesWeather.isEmpty else { return cell }
        let index = indexPath.row
        cell.configure(city: model[index].name, temperature: model[index].temp)
        model.setWeatherImage(forIndex: indexPath.row, for: cell.weatherImageView)
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
        coordinator?.showDetail(forCity: model[indexPath.row])
    }
}
