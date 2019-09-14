import UIKit
import Anchorage

final class RootCoordinator: Coordinating {
    let root: UINavigationController = UINavigationController()
    
    init() {
        let view = CurrencyConverterViewController()
        root.setViewControllers([view], animated: true)
    }
}

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let rootCoordinator = RootCoordinator()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        rootCoordinator.launch(in: window)
        return true
    }
}

final class CurrencyConverterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bitcoin
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let grid = NumericGridInputView()
        view.addSubview(grid)
        grid.horizontalAnchors == view.horizontalAnchors + 24
        grid.centerYAnchor == view.centerYAnchor
    }
}


public protocol ViewRendering {
    associatedtype Properties
    func render(_ properties: Properties)
}

final class NumericGridInputView: UIView {
    
    final class ItemView: UIView, ViewRendering {
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
    
        private let centerGuide = UILayoutGuide()
        private var cachedButton: UIButton?
        var onAction: ((Action) -> Void)?
        var properties: Properties = .default
        
        func render(_ properties: Properties) {
            
            cachedButton?.removeFromSuperview()
            
            switch properties {
            case .number(let number):
                let button = UIButton()
                button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .medium)
                button.setTitle("\(number)", for: .normal)
                addSubview(button)
                button.edgeAnchors == centerGuide.edgeAnchors
                cachedButton = button
                
            case .symbol(let symbol):
                print(symbol)
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
            cachedButton?.titleLabel?.animate(fontSize: 48, duration: 0.1)
        }
        
        @objc private func didTouchUpButton() {
            cachedButton?.titleLabel?.animate(fontSize: 28, duration: 0.2)
            onAction?(properties.action)
        }
        
        @objc private func didTouchUpOutside() {
            cachedButton?.titleLabel?.animate(fontSize: 28, duration: 0.2)
            onAction?(properties.action)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addLayoutGuide(centerGuide)
            centerGuide.centerAnchors == centerAnchors
            centerGuide.edgeAnchors == edgeAnchors
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private func makeItemView(for item: ItemView.Properties) -> UIView {
        return UIView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        var rows: [UIStackView] = [.init(), .init(), .init()]
        
        for index in 1...9 {
            
            let item = ItemView()
            item.render(.number(index))
            
            if index <= 3 {
                rows[0].addArrangedSubview(item)
            } else if index <= 6 {
                rows[1].addArrangedSubview(item)
            } else if index <= 9 {
                rows[2].addArrangedSubview(item)
            }
        }
        
        let fourthRowProperties: [ItemView.Properties] = [.symbol(.decimal), .number(0), .symbol(.delete)]
        
        rows.append(.init(arrangedSubviews: fourthRowProperties.map {
            let view = ItemView()
            view.render($0)
            return view
        }))
        
        for row in rows {
            row.axis = .horizontal
            row.distribution = .fillEqually
        }
        
        let stack = UIStackView(arrangedSubviews: rows)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.edgeAnchors == edgeAnchors
        stack.heightAnchor == stack.widthAnchor * 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UILabel {
    func animate(fontSize: CGFloat, duration: TimeInterval) {
        let startTransform = transform
        let oldFrame = frame
        var newFrame = oldFrame
        let scaleRatio = fontSize / font.pointSize
        
        newFrame.size.width *= scaleRatio
        newFrame.size.height *= scaleRatio
        newFrame.origin.x = oldFrame.origin.x - (newFrame.size.width - oldFrame.size.width) * 0.5
        newFrame.origin.y = oldFrame.origin.y - (newFrame.size.height - oldFrame.size.height) * 0.5
        frame = newFrame
        
        font = font.withSize(fontSize)
        
        transform = CGAffineTransform.init(scaleX: 1 / scaleRatio, y: 1 / scaleRatio);
        layoutIfNeeded()
        
        UIView.animate(withDuration: duration, animations: {
            self.transform = startTransform
            newFrame = self.frame
        }) { (Bool) in
            self.frame = newFrame
        }
    }
}
