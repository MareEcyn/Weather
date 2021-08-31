import UIKit

class CityCell: UITableViewCell {
    static let id = "cityCell"
    private let city: String = ""
    private let temperature: String = ""
    private let weather: String = ""
    
    required init?(coder: NSCoder) { return nil }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func configure(city: String, temperature: String, weather: String) {
        let cityName = UILabel()
        cityName.text = city
        let cityTemperature = UILabel(frame: .zero)
        cityTemperature.text = temperature
        let cityWeather = UILabel(frame: .zero)
        cityWeather.text = weather
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.spacing = 16
        stack.addArrangedSubview(cityName)
        stack.addArrangedSubview(cityTemperature)
        stack.addArrangedSubview(cityWeather)
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        let stackLeading = stack.leadingAnchor.constraint(equalTo: leadingAnchor)
        let stackTrailing = stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        let stackTop = stack.topAnchor.constraint(equalTo: topAnchor)
        let stackBottom = stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([stackLeading, stackTrailing, stackTop, stackBottom])
    }
}
