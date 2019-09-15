import UIKit
import Anchorage

final class CurrencyDisplayView: UIView, ViewRendering {
    
    struct Properties {
        enum Position {
            case numeral(Int)
            case decimal
            case comma
        }
        
        var positions: [Position]
        var symbol: UIImage?
        
        static let `default` = Properties(positions: [], symbol: nil)
    }
    
    func render(_ properties: CurrencyDisplayView.Properties) {
        
        var views = [UIView]()
        
        let fontSize: CGFloat = {
            switch properties.positions.count {
            case 1: return 120
            case 2: return 94
            case 3: return 72
            default: return 0
            }
        }()
        
        for position in properties.positions {
            switch position {
            case .comma:
                continue
            case .decimal:
                continue
            case .numeral(let digit):
                let label = UILabel()
                label.font = .systemFont(ofSize: fontSize, weight: .regular)
                label.text = "\(digit)"
                label.textColor = .white
                views.append(label)
            }
        }
        
        let stack = UIStackView(arrangedSubviews: views)
        addSubview(stack)
        stack.edgeAnchors == edgeAnchors
        
        let icon = UIImageView(image: properties.symbol?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = .white
        addSubview(icon)
        icon.trailingAnchor == stack.leadingAnchor
        icon.topAnchor == stack.topAnchor + 32
        icon.sizeAnchors == .init(width: 24, height: 24)
    }
}
