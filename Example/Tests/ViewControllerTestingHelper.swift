import Foundation
import UIKit

public class ViewControllerTestingHelper {
    class func wait() {
        NSRunLoop.mainRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 0.01))
    }

    class func emptyViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view = UIView()
        return viewController
    }

    class func prepareWindowWithRootViewController(viewController: UIViewController) -> UIWindow {
        let window: UIWindow = UIWindow(frame: CGRect())
        window.makeKeyAndVisible()
        window.rootViewController = viewController
        wait()
        return window
    }

    class func presentViewController(viewController: UIViewController) {
        let window: UIWindow = prepareWindowWithRootViewController(emptyViewController())
        window.rootViewController?.presentViewController(viewController, animated: false, completion: nil)
        wait()
    }

    class func dismissViewController(viewController: UIViewController) {
        viewController.dismissViewControllerAnimated(false, completion: nil)
        wait()
    }

    class func presentAndDismissViewController(viewController: UIViewController) {
        presentViewController(viewController)
        dismissViewController(viewController)
    }

    class func pushViewController(viewController: UIViewController) -> UINavigationController {
        let navigationController: UINavigationController = UINavigationController(rootViewController: emptyViewController())
        let window = prepareWindowWithRootViewController(navigationController)
        navigationController.pushViewController(viewController, animated: false)
        wait()
        return navigationController
    }
}