/*
 * UIBezierPath+.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
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

public extension UIBezierPath {

    convenience init(points: [CGPoint]) {
        self.init()
        drawLines(points)
    }

    convenience init(points: CGPoint...) {
        self.init(points: points)
    }

    func drawLines(points: [CGPoint]) {
        precondition(points.count > 1, "Invalid number of points!")

        self.moveToPoint(points.first!)
        points.dropFirst().forEach(self.addLineToPoint)
    }

    func drawLines(points: CGPoint...) {
        drawLines(points)
    }
}

public extension UIBezierPath {

    final func outlineStroke() -> UIBezierPath {
        let path = CGPathCreateCopyByStrokingPath(self.CGPath,
                                                  nil,
                                                  self.lineWidth,
                                                  self.lineCapStyle,
                                                  self.lineJoinStyle,
                                                  self.miterLimit)
        return UIBezierPath(CGPath: path!)
    }
}