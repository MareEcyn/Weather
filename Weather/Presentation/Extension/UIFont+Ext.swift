import UIKit

extension UIFont {
    
    /// Returns an instance of the system font for the specified text style with scaling for the user's selected content size category. Also allows choose font weight,
    /// - Parameters:
    ///   - style: text style
    ///   - weight: font weight
    /// - Returns: The system font of selected weight  associated with the specified text style.
    static func preferredFont(forTextStyle style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}
