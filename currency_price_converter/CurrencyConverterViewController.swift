import UIKit
import Anchorage

final class CurrencySelectView: UIView, ViewRendering {
    
    let symbol = UIImageView()
    let currency = UILabel()
    
    struct Properties {
        let symbol: UIImage?
        let currency: String
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


final class CircleWipeView: UIView, ViewRendering {
    
    typealias Properties = UIColor
    
    var cachedCircle: UIView?
    var duration = 0.3
    
    func render(_ properties: UIColor) {
        animateCircle(with: properties)
    }
    
    func frameForCircle (withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offestVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offestVector, height: offestVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
    
    private func animateCircle(with color: UIColor) {
        let viewCenter = center
        let viewSize = frame.size
        
        let circle = UIView()
        
        circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: .init(x: frame.width / 2, y: frame.height / 2))
        
        circle.layer.cornerRadius = circle.frame.size.height / 2
        circle.center = .init(x: frame.width / 2, y: frame.height / 2)
        circle.backgroundColor = color
        circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        addSubview(circle)
        
        cachedCircle = circle
        
        UIView.animate(withDuration: duration, animations: {
            
            circle.transform = CGAffineTransform.identity
            
        })
    }
}


final class CurrencyConverterViewController: UIViewController {
    let footer = CurrencyConverterFooterView()
    let backgroundImage = UIImageView(image: UIImage(named: "btc")?.withRenderingMode(.alwaysTemplate))
    let originCurrencyDisplayView = CurrencyDisplayView()
    let destinationCurrencyDisplayView = CurrencyDisplayView()
    let circleWipe = CircleWipeView()
   
    @objc func test() {
        circleWipe.render(.blue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        footer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(test)))
        view.addSubview(circleWipe)
        circleWipe.edgeAnchors == view.edgeAnchors
        circleWipe.backgroundColor = .bitcoin
        
        let leftAction = UIButton()
        leftAction.setImage(UIImage(named: "person")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftAction.tintColor = .white
        leftAction.sizeAnchors == .init(width: 38, height: 38)
        
        view.addSubview(leftAction)
        leftAction.leadingAnchor == view.leadingAnchor + 18
        leftAction.topAnchor == view.safeAreaLayoutGuide.topAnchor + 12
        
        let rightAction = UIButton()
        rightAction.setImage(UIImage(named: "clock")?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightAction.tintColor = .white
        rightAction.sizeAnchors == .init(width: 38, height: 38)
        
        view.addSubview(rightAction)
        rightAction.trailingAnchor == view.trailingAnchor - 18
        rightAction.topAnchor == view.safeAreaLayoutGuide.topAnchor + 12
        
        view.addSubview(backgroundImage)
        backgroundImage.tintColor = .white
        backgroundImage.layer.opacity = 0.1
        
        backgroundImage.heightAnchor == view.heightAnchor * 0.8
        backgroundImage.widthAnchor == view.heightAnchor * 0.8
        backgroundImage.centerAnchors == view.centerAnchors
        
//        view.backgroundColor = .bitcoin
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        view.addSubview(originCurrencyDisplayView)
        view.addSubview(destinationCurrencyDisplayView)
        
        originCurrencyDisplayView.render(.init(positions: [.numeral(0)], symbol: UIImage(named:"btc_currency")))
        destinationCurrencyDisplayView.render(.init(positions: [.numeral(1), .numeral(1), .numeral(1)], symbol: UIImage(named:"btc_currency")))
        
        originCurrencyDisplayView.topAnchor == view.safeAreaLayoutGuide.topAnchor + 36
        originCurrencyDisplayView.centerXAnchor == view.centerXAnchor
        
        destinationCurrencyDisplayView.topAnchor == originCurrencyDisplayView.bottomAnchor + 18
        destinationCurrencyDisplayView.centerXAnchor == view.centerXAnchor
        
        
        let grid = NumericGridInputView()
        view.addSubview(grid)
        view.addSubview(footer)
        
        grid.horizontalAnchors == view.horizontalAnchors + 24
        grid.bottomAnchor == footer.topAnchor - 36
        footer.horizontalAnchors == view.horizontalAnchors + 24
        footer.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor - 12
        
        footer.render((.init(symbol: UIImage(named:"btc_currency"), currency: "BTC"),
                       .init(symbol: UIImage(named:"btc_currency"), currency: "BTC")))
    }
}
