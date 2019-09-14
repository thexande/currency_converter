import UIKit
import Anchorage

final class CurrencyConverterFooterView: UIView {
    
    let background = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let divider = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: .init(style: .dark)))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(background)
        background.edgeAnchors == edgeAnchors
        layer.cornerRadius = 10
        layer.masksToBounds = true
        heightAnchor == 64
        
        addSubview(divider)
        divider.widthAnchor == 3
        divider.centerXAnchor == centerXAnchor
        divider.verticalAnchors == verticalAnchors

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class CurrencyConverterViewController: UIViewController {
    let footer = CurrencyConverterFooterView()
    let backgroundImage = UIImageView(image: UIImage(named: "btc")?.withRenderingMode(.alwaysTemplate))
    let originCurrencyDisplayView = CurrencyDisplayView()
    let destinationCurrencyDisplayView = CurrencyDisplayView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        view.backgroundColor = .bitcoin
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        originCurrencyDisplayView.render(.init(positions: [.numeral(0)], symbol: UIImage(named: "btc")))
        destinationCurrencyDisplayView.render(.init(positions: [.numeral(1), .numeral(1), .numeral(1)], symbol: UIImage(named: "btc")))
        
        let currencyDisplay = UIStackView(arrangedSubviews: [originCurrencyDisplayView, destinationCurrencyDisplayView])
        currencyDisplay.axis = .vertical
        view.addSubview(currencyDisplay)
        
        currencyDisplay.topAnchor == view.safeAreaLayoutGuide.topAnchor + 36
        currencyDisplay.centerXAnchor == view.centerXAnchor
        
        
        let grid = NumericGridInputView()
        view.addSubview(grid)
        view.addSubview(footer)
        
        grid.horizontalAnchors == view.horizontalAnchors + 24
        grid.bottomAnchor == footer.topAnchor - 36
        footer.horizontalAnchors == view.horizontalAnchors + 24
        footer.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor - 12
    }
}
