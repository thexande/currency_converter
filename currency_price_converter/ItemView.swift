import UIKit
import Anchorage
import Haptica

final class ItemView: UIView, ViewRendering {
    
    private let centerGuide = UILayoutGuide()
    private var cachedButton: UIButton?
    var onAction: ((Action) -> Void)?
    var properties: Properties = .default
    
    enum Properties {
        enum Symbol {
            
            case delete
            case decimal
            
            var icon: UIImage? {
                switch self {
                case .delete:
                    return UIImage(named: "delete")
                case .decimal:
                    return UIImage(named: "decimal")
                }
            }
            
            var action: Action {
                switch self {
                case .delete:
                    return .delete
                case .decimal:
                    return .addDecimalPlace
                }
            }
        }
        
        case number(Int)
        case symbol(Symbol)
        
        var action: Action {
            switch self {
            case let .number(number):
                return .selectedNumber(number)
            case .symbol(let symbol):
                return symbol.action
            }
        }
        
        static let `default`: Properties = .number(-1)
    }
    
    enum Action {
        case selectedNumber(Int)
        case delete
        case addDecimalPlace
    }
    
    func render(_ properties: Properties) {
        
        self.properties = properties
        
        cachedButton?.removeFromSuperview()
        
        switch properties {
        case .number(let number):
            let button = UIButton()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            button.setTitle("\(number)", for: .normal)
            addSubview(button)
            button.edgeAnchors == centerGuide.edgeAnchors
            cachedButton = button
            
        case .symbol(let symbol):
            let button = UIButton()            
            let image = UIImageView(image: symbol.icon)
            button.addSubview(image)
            image.centerAnchors == button.centerAnchors
            image.contentMode = .scaleAspectFill
            image.edgeAnchors >= button.edgeAnchors
            
            addSubview(button)
            button.edgeAnchors == centerGuide.edgeAnchors
            cachedButton = button
            
        }
        
        cachedButton?.addTarget(self, action: #selector(didTouchDownButton), for: .touchDown)
        cachedButton?.addTarget(self, action: #selector(didTouchUpButton), for: .touchUpInside)
        cachedButton?.addTarget(self, action: #selector(didTouchUpOutside), for: .touchUpOutside)
    }
    
    @objc private func didTouchDownButton() {
        
        guard let icon = cachedButton?.subviews.first(where: { $0 is UIImageView }) else {
            cachedButton?.titleLabel?.animate(fontSize: 48, duration: 0.1)
            return
        }
        
        let ratio: CGFloat = 48 / 28
        UIView.animate(withDuration: 0.1) {
            icon.transform = CGAffineTransform(scaleX: ratio, y: ratio)
        }
    }
    
    @objc private func didTouchUpButton() {
        if let icon = cachedButton?.subviews.first(where: { $0 is UIImageView }) {
            UIView.animate(withDuration: 0.1) {
                icon.transform = .identity
            }
        } else {
            cachedButton?.titleLabel?.animate(fontSize: 28, duration: 0.2)
        }
        
        onAction?(properties.action)
        Haptic.impact(.light).generate()
    }
    
    @objc private func didTouchUpOutside() {
        if let icon = cachedButton?.subviews.first(where: { $0 is UIImageView }) {

            UIView.animate(withDuration: 0.1) {
                icon.transform = .identity
            }
        } else {
            cachedButton?.titleLabel?.animate(fontSize: 28, duration: 0.2)
        }
        
        onAction?(properties.action)
        Haptic.impact(.light).generate()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLayoutGuide(centerGuide)
        centerGuide.centerAnchors == centerAnchors
        centerGuide.widthAnchor == widthAnchor * 0.75
        centerGuide.heightAnchor == heightAnchor * 0.75
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
