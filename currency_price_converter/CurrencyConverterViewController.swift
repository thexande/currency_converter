import UIKit
import Anchorage

final class CurrencyConverterViewController: UIViewController {
    
    let footer = UIView()
    let backgroundImage = UIImageView(image: UIImage(named: "btc")?.withRenderingMode(.alwaysTemplate))
    let originCurrencyDisplayView = CurrencyDisplayView()
    let destinationCurrencyDisplayView = CurrencyDisplayView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        currencyDisplay.topAnchor == view.safeAreaLayoutGuide.topAnchor
        currencyDisplay.centerXAnchor == view.centerXAnchor
        
        
        let grid = NumericGridInputView()
        view.addSubview(grid)
        view.addSubview(footer)
        
        grid.horizontalAnchors == view.horizontalAnchors + 24
        grid.bottomAnchor == footer.topAnchor - 36
        footer.horizontalAnchors == view.horizontalAnchors + 18
        footer.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor
        
        footer.heightAnchor == 64
        footer.layer.cornerRadius = 10
        footer.backgroundColor = .white
    }
}
