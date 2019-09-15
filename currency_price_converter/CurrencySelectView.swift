import UIKit
import Anchorage

final class CurrencySelectView: UIView, ViewRendering {
    
    let symbol = UIImageView()
    let currency = UILabel()
    
    struct Properties {
        let symbol: UIImage?
        let currency: String
        
        static let `default` = Properties(symbol: nil, currency: "")
    }
    
    func render(_ properties: Properties) {
        symbol.image = properties.symbol
        currency.text = properties.currency
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(symbol)
        addSubview(currency)
        
        symbol.sizeAnchors == .init(width: 42, height: 42)
        symbol.leadingAnchor == leadingAnchor
        symbol.verticalAnchors >= verticalAnchors
        symbol.centerYAnchor == centerYAnchor
        
        currency.leadingAnchor == symbol.trailingAnchor
        currency.verticalAnchors >= verticalAnchors
        currency.trailingAnchor == trailingAnchor
        currency.centerYAnchor == centerYAnchor
        currency.font = .systemFont(ofSize: 18, weight: .bold)
        currency.textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
