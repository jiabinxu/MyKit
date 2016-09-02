/*
 * TableHoldGesture.swift
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

public protocol TableHoldeGestureActionSubscribable: class {

    func userDidFinishMovingCell(fromIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath)
}

public class TableHoldGesture: UILongPressGestureRecognizer {

    internal private(set) var cellSnapshot: UIView?
    internal private(set) var sourceIndexPath: NSIndexPath?
    internal private(set) var originalIndexPath: NSIndexPath?

    internal var tableView: UITableView? {
        return self.view as? UITableView
    }

    public weak var actionSubscriber: TableHoldeGestureActionSubscribable?
    public var allowedSecionRange: Range<Int>?

    public func handleGesture() {
        guard case let point = self.locationInView(tableView),
            let trackingIndexPath = tableView?.indexPathForRowAtPoint(point)
            where allowedSecionRange?.contains(trackingIndexPath.section) ?? true
            else { return }

        switch self.state {
        case .Began:
            let cell = tableView?.cellForRowAtIndexPath(trackingIndexPath)?.then {
                $0.alpha = 1
                $0.hidden = false
            }

            sourceIndexPath = trackingIndexPath
            originalIndexPath = trackingIndexPath

            cellSnapshot = cell?.snapshotViewAfterScreenUpdates(true).then {
                $0.alpha = 0
                $0.center = cell?.center ?? .zero
                $0.clipsToBounds = false
                $0.layer.shadowOffset = CGSizeMake(-5, 0)
                $0.layer.shadowRadius = 5
                $0.layer.shadowOpacity = 0.4
            }.then {
                tableView?.addSubview($0)
            }

            UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseOut, animations: {
                cell?.alpha = 0

                self.cellSnapshot?.then {
                    $0.alpha = 0.98
                    $0.center.y = point.y
                    $0.transform = CGAffineTransformMakeScale(1.05, 1.05)
                }
                }, completion: { [weak cell] _ in
                    cell?.hidden = true
                })
        case .Changed:
            cellSnapshot?.center.y = point.y

            guard let sourceIndexPath = self.sourceIndexPath
                where cellSnapshot != trackingIndexPath
                else { return }

            self.tableView?.then { $0.dataSource?.tableView?($0, moveRowAtIndexPath: sourceIndexPath, toIndexPath: trackingIndexPath) }
            self.sourceIndexPath = trackingIndexPath
        default:
            guard let sourceIndexPath = self.sourceIndexPath else { return }

            let cell = tableView?.cellForRowAtIndexPath(sourceIndexPath)?.then {
                $0.alpha = 0
                $0.hidden = false
            }

            UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseOut, animations: {
                cell?.alpha = 1

                self.cellSnapshot?.then {
                    $0.alpha = 0
                    $0.center.y = cell?.center.y ?? 0
                    $0.transform = CGAffineTransformIdentity
                }
                }, completion: { [weak self] _ in
                    self?.cellSnapshot?.removeFromSuperview()

                    if let fromIndexPath = self?.originalIndexPath,
                           toIndexPath = self?.sourceIndexPath {
                        self?.actionSubscriber?.userDidFinishMovingCell(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath)
                    }

                    self?.sourceIndexPath = nil
                })
        }
    }
}