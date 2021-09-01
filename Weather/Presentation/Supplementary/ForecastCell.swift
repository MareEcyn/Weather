import UIKit

class ForecastCell: UITableViewCell {
    static let id = "forecastCell"
    private let weekDay: String = ""
    private let dayTemp: String = ""
    private let nightTemp: String = ""
    
    required init?(coder: NSCoder) { return nil }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func configure(weekDay: String, dayTemp: String, nightTemp: String) {
        let weekDayView = UILabel()
        weekDayView.text = weekDay.prefix(1).capitalized + weekDay.dropFirst()
        weekDayView.font = .preferredFont(forTextStyle: .headline, weight: .light)
        weekDayView.adjustsFontForContentSizeCategory = true
        let dayTempView = UILabel()
        dayTempView.text = dayTemp
        dayTempView.font = .preferredFont(forTextStyle: .title1, weight: .light)
        dayTempView.adjustsFontForContentSizeCategory = true
        let nightTempView = UILabel()
        nightTempView.text = nightTemp
        nightTempView.font = .preferredFont(forTextStyle: .title1, weight: .light)
        nightTempView.adjustsFontForContentSizeCategory = true
        nightTempView.textColor = .gray
        let stack = UIStackView(arrangedSubviews: [weekDayView, dayTempView, nightTempView])
        stack.axis = .horizontal
        stack.spacing = 8
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        let stackLeading = stack.leadingAnchor.constraint(equalTo: leadingAnchor)
        let stackTrailing = stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        let stackTop = stack.topAnchor.constraint(equalTo: topAnchor)
        let stackBottom = stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([stackLeading, stackTrailing, stackTop, stackBottom])
    }
}
