//
//  Action.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/15/16.
//  
//

private var Action = "Action"

final private class ActionWrapper<T>: NSObject {

    let f: T -> Void

    init(f: T -> Void) {
        self.f = f
    }

    override func copy() -> AnyObject {
        return self
    }
}

public protocol ActionBlock: class {}

public extension ActionBlock {

    final private func setAction(block: Self -> Void) {
        let obj: AnyObject = unsafeBitCast(ActionWrapper(f: block), AnyObject.self)
        objc_setAssociatedObject(self, &Action, obj, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
}

internal extension NSObject {

    func handleBlock() {
        unsafeBitCast(objc_getAssociatedObject(self, &Action), ActionWrapper.self).f(self)
    }
}

#if os(iOS)
    // MARK: - Control

    extension UIControl: ActionBlock {}

    public extension ActionBlock where Self: UIControl {

        public final func addAction(block: Self -> Void, forControlEvents events: UIControlEvents) {
            self.setAction(block)
            self.addTarget(self, action: "handleBlock", forControlEvents: events)
        }
    }
#endif

#if os(iOS)
    // MARK: - Gesture Recognizer

    extension UIGestureRecognizer: ActionBlock {}

    public extension ActionBlock where Self: UIGestureRecognizer {

        public final func addAction(block: Self -> Void) {
            self.setAction(block)
            self.addTarget(self, action: "handleBlock")
        }
    }
#endif