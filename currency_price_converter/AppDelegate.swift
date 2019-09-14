import UIKit

final class RootCoordinator: Coordinating {
    let root: UINavigationController = UINavigationController()
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

