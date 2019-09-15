import UIKit
import Anchorage

final class CurrencyConverterPresenter {
    
    var render: ((CurrencyConverterViewController.Properties) -> Void)?
    
    var properties: CurrencyConverterViewController.Properties = .default {
        didSet {
            render?(properties)
        }
    }
    
    
    
}

extension CurrencyConverterPresenter: CurrencyConverterViewDelegate {
    func didSelectNumeral(_ numberal: Int) {
        print("added number\(numberal)")
    }
    
    func didSelectDecimal() {
        print("added decimal")
    }
    
    func didSelectDelete() {
        print("selected delete")
    }
}


protocol CurrencyConverterViewDelegate: NumericInputGridViewDelegate {
    
}

final class CurrencyConverterViewController: UIViewController, ViewRendering {
    
    private let footer = CurrencyConverterFooterView()
    private let originCurrencyDisplayView = CurrencyDisplayView()
    private let destinationCurrencyDisplayView = CurrencyDisplayView()
    private let background = BackgroundCollectionView()
    private let grid = NumericGridInputView()
    
    weak var delegate: CurrencyConverterViewDelegate? {
        didSet {
            grid.delegate = delegate
        }
    }
    
    private var properties: Properties = .default
    
    struct Properties {
        var footerProperties: CurrencyConverterFooterView.Properties
        var originProperties: CurrencyDisplayView.Properties
        var destinationProperties: CurrencyDisplayView.Properties
        var backgroundProperties: BackgroundCollectionView.Properties
        var circleProperties: CircleWipeView.Properties
        
        static let `default` = Properties(footerProperties: (.default, .default),
                                          originProperties: .default,
                                          destinationProperties: .default,
                                          backgroundProperties: .default,
                                          circleProperties: .default)
    }
   
    
    func render(_ properties: CurrencyConverterViewController.Properties) {
//        circleWipe.render(properties.circleProperties)
    }
    
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

        view.addSubview(background)
        background.edgeAnchors == view.edgeAnchors
        
        background.render(.init(pages: [
            .init(image: UIImage(named: "btc")?.withRenderingMode(.alwaysTemplate), backgroundColor: .bitcoin),
            .init(image: UIImage(named: "eth")?.withRenderingMode(.alwaysTemplate), backgroundColor: .black),
            .init(image: UIImage(named: "ltc")?.withRenderingMode(.alwaysTemplate), backgroundColor: .litecoin)
        ]))
        
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
