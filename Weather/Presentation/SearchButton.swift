import UIKit

class SearchButton: UIButton {
    required init?(coder: NSCoder) { return nil }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc private func buttonTouchDown() {
        backgroundColor = .interactivGreen.withAlphaComponent(0.8)
    }
    
    @objc private func buttonTouchUp() {
        backgroundColor = .interactivGreen
    }
}
