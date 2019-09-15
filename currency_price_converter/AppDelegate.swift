import UIKit
import Anchorage

final class RootCoordinator: Coordinating {
    
    let root: UIViewController
    private let presenter = CurrencyConverterPresenter()

    
    init() {
        let view = CurrencyConverterViewController()
        
        presenter.render = { [weak view] properties in
            view?.render(properties)
        }
        
        view.delegate = presenter
        
        root = view
    }
}

final class LightNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

public protocol ViewRendering {
    associatedtype Properties
    func render(_ properties: Properties)
}
