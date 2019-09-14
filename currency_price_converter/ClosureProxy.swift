import UIKit

final class ClosureProxy {
    let closure: (() -> Void)
    private static var key: UInt8 = 0
    
    init(attachTo: AnyObject, closure: @escaping (() -> Void)) {
        self.closure = closure
        objc_setAssociatedObject(attachTo,
                                 &ClosureProxy.key,
                                 self,
                                 .OBJC_ASSOCIATION_RETAIN)
    }
    
    @objc func invoke() {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .primaryActionTriggered, action: @escaping () -> Void) {
        removeTarget(nil, action: nil, for: controlEvents)
        let proxy = ClosureProxy(attachTo: self, closure: action)
        addTarget(proxy, action: #selector(ClosureProxy.invoke), for: controlEvents)
    }
}
