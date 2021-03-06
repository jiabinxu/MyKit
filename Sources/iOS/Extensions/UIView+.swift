/*
 * UIView+.swift
 * MyKit
 *
 * Copyright (c) 2016 Hai Nguyen.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

public extension UIView {

    typealias AnimatingCompletion = (Bool) -> Void
}


public extension UIView {

    static func animate(duration duration: NSTimeInterval, animations: () -> Void) -> Promise<Bool> {
        return Promise { callback in
            self.animateWithDuration(duration, animations: animations) { callback(.Fullfill($0)) }
        }
    }
}

public extension UIView {

    enum Axis { case Horizontal, Vertical }

    func fillSubviewsEqually(`in` axis: Axis) {
        var axisFormat: String = "\(axis.initial):|"
        var subviews: [String: UIView] = [:]
        var otherFormat: [String] = []

        for (index, subview) in self.subviews.enumerate() {
            let key = "subview\(index)"
            subviews[key] = subview

            otherFormat += ["\(axis.reversed.initial):|[\(key)]|"]
            axisFormat += "[" + key + (index == 0 ? "" : "(==subview0)") + "]"
        }

        axisFormat += "|"

        (otherFormat + [axisFormat])
            .reduce([]) { $0 + NSLayoutConstraint.constraints(withFormat: $1, views: subviews) }
            .activate()
    }
}

private extension UIView.Axis {

    var initial: Character {
        switch self {
        case .Horizontal: return "H"
        case .Vertical: return "V"
        }
    }

    var reversed: UIView.Axis {
        switch self {
        case .Horizontal: return .Vertical
        case .Vertical: return .Horizontal
        }
    }
}