import UIKit

class CityCell: UITableViewCell {
    static let id = "cityCell"
    private let city: String = ""
    private let temperature: String = ""
    let weatherImageView = UIImageView()
    
    required init?(coder: NSCoder) { return nil }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func configure(city: String, temperature: String) {
        let cityName = UILabel()
        cityName.text = city
        cityName.font = .preferredFont(forTextStyle: .title1, weight: .light)
        cityName.adjustsFontForContentSizeCategory = true
        cityName.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let cityTemperature = UILabel()
        cityTemperature.font = .preferredFont(forTextStyle: .title1)
        cityTemperature.adjustsFontForContentSizeCategory = true
        cityTemperature.textColor = .gray
        cityTemperature.text = temperature + " °C"
        weatherImageView.contentMode = .scaleAspectFit
        weatherImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let stack = UIStackView(arrangedSubviews: [cityName, cityTemperature, weatherImageView])
        stack.axis = .horizontal
        stack.spacing = 4
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        let stackLeading = stack.leadingAnchor.constraint(equalTo: leadingAnchor)
        let stackTrailing = stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        let stackTop = stack.topAnchor.constraint(equalTo: topAnchor)
        let stackBottom = stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([stackLeading, stackTrailing, stackTop, stackBottom])
    }
}
