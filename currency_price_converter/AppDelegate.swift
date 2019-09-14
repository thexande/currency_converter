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
            case number(Int)
            case symbol(Symbol)
        }
        
        enum Symbol {
            
            case delete
            
            var icon: UIImage? {
                switch self {
                case .delete:
                    return nil
                }
            }
        }
    
        private let centerGuide = UILayoutGuide()
        private var cachedItemView: UIView?
        
        func render(_ properties: Properties) {
            
            cachedItemView?.removeFromSuperview()
            
            switch properties {
            case .number(let number):
                let label = UILabel()
                label.text = "\(number)"
                addSubview(label)
                label.edgeAnchors == centerGuide.edgeAnchors
                cachedItemView = label
                
            case .symbol(let symbol):
                print(symbol)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addLayoutGuide(centerGuide)
            centerGuide.centerAnchors == centerAnchors
            centerGuide.edgeAnchors >= edgeAnchors
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
    
        let rows: [UIStackView] = [.init(), .init(), .init()]
        
        for row in rows {
            row.axis = .horizontal
            row.distribution = .fillEqually
        }
        
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
