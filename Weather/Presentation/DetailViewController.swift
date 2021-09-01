import UIKit

// MARK: - UIViewController life-cycle
class DetailViewController: UIViewController {
    private weak var coordinator: AppCoordinator?
    let model: CityWeather
    private var tableView: UITableView!
    
    required init?(coder: NSCoder) { return nil }
    
    init(coordinator: AppCoordinator, model: CityWeather) {
        self.coordinator = coordinator
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Methods for configure UI
extension DetailViewController {
    private func setupUI() {
        let winDirDecoded = [
            "nw": "северо-западный",
            "n": "северный",
            "ne": "северо-восточный",
            "e": "восточный",
            "se": "юго-восточный",
            "s": "южный",
            "sw": "юго-западный",
            "w": "западный",
            "c": "штильный"
        ]
        view.backgroundColor = .white
        title = "Прогноз"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Закрыть",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(close))
        
        let nameView = UILabel()
        nameView.font = .preferredFont(forTextStyle: .title1)
        nameView.text = model.name
        let temperatureView = UILabel()
        temperatureView.font = UIFont.systemFont(ofSize: 80, weight: .light)
        temperatureView.text = model.temp + "°"
        let windView = UILabel()
        windView.textColor = .gray
        windView.text = "Ветер " + (winDirDecoded[model.windDir] ?? "") + ", " + model.windSpeed + " м/с"
        
        let stack = UIStackView(arrangedSubviews: [nameView, temperatureView, windView])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        let stackX = stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let stackTop = stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: +32)
        NSLayoutConstraint.activate([stackX, stackTop])
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ForecastCell.self, forCellReuseIdentifier: ForecastCell.id)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        view.addSubview(tableView)
        let tableViewLeading = tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: +32)
        let tableViewTrailing = tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32)
        let tableViewTop = tableView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: +16)
        let tableViewBottom = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([tableViewLeading, tableViewTrailing, tableViewTop, tableViewBottom])
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ForecastCell(style: .default, reuseIdentifier: ForecastCell.id)
        let index = indexPath.row
        cell.configure(weekDay: model.forecasts[index].weekday,
                       dayTemp: model.forecasts[index].temp.first!,
                       nightTemp: model.forecasts[index].temp.last!)
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
