import UIKit
import Anchorage

final class RootCoordinator: Coordinating {
    let root: UIViewController
    
    init() {
        let view = CurrencyConverterViewController()
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
