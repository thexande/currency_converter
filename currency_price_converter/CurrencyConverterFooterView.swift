import UIKit
import Anchorage

final class CurrencyConverterFooterView: UIView, ViewRendering {
    
    typealias Properties = (CurrencySelectView.Properties, CurrencySelectView.Properties)
    
    let background = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let divider = UIView() // UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: .init(style: .dark)))
    
    var cachedStack: UIView?
    
    func render(_ properties: (CurrencySelectView.Properties, CurrencySelectView.Properties)) {
        
        cachedStack?.removeFromSuperview()
        
        let left = CurrencySelectView()
        left.render(properties.0)
        
        let right = CurrencySelectView()
        right.render(properties.1)
        
        let wrapperOne = UIView()
        wrapperOne.addSubview(left)
        left.edgeAnchors >= wrapperOne.edgeAnchors
        left.centerAnchors == wrapperOne.centerAnchors
        
        let wrapperTwo = UIView()
        wrapperTwo.addSubview(right)
        right.edgeAnchors >= wrapperTwo.edgeAnchors
        right.centerAnchors == wrapperTwo.centerAnchors
        
        let stack = UIStackView(arrangedSubviews: [wrapperOne, wrapperTwo])
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.edgeAnchors == edgeAnchors
        cachedStack = stack
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        divider.backgroundColor = .lightGray
        
        addSubview(background)
        background.edgeAnchors == edgeAnchors
        layer.cornerRadius = 10
        layer.masksToBounds = true
        heightAnchor == 64
        
        addSubview(divider)
        divider.widthAnchor == 0.5
        divider.centerXAnchor == centerXAnchor
        divider.verticalAnchors == verticalAnchors
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

