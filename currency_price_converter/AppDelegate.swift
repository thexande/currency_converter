import UIKit

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
        
        func render(_ properties: Properties) {
            switch properties {
            case .number(let number):
                let label = UILabel()
                label.text = "\(number)"
                addSubview(label)
                
            case .symbol(let symbol):
                print(symbol)
            }
        }
    }
    
    private func makeItemView(for item: ItemView.Properties) -> UIView {
        return UIView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        for _ in 0..<3 {
            // rows
             let item = UIView()
            
            
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
