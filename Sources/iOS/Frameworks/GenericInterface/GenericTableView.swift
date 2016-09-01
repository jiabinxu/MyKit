/*
 * GenericTableView.swift
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

public class GenericTableView<Model: Equatable, Row: UITableViewCell>: UITableView, UITableViewDataSource {

    // MARK: Property

    public private(set) var rowModels: [Model] = []

    public var rowRenderer: ((Row, Model) -> Void)? {
        didSet { self.reloadData() }
    }

    // MARK: Initialization

    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        super.showsHorizontalScrollIndicator = false
        super.register(Row.self, forReuseIdentifier: String(Row.self))
        super.dataSource = self
    }

    // MARK: Table View Data Source

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowModels.count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(String(Row.self), forIndexPath: indexPath).then {
            $0.tag = tableView.serialize(indexPath)
            rowRenderer?($0 as! Row, rowModels[indexPath.row])
        }
    }
}

public extension GenericTableView {

    /**
     Apply changes to the state data set.
     */
    func apply(changes changes: [Change<Array<Model>.Step>], animation: UITableViewRowAnimation) {
        let (deletes, inserts) = rowModels.apply(changes, inSection: 0)

        self.beginUpdates()
        self.deleteRowsAtIndexPaths(deletes, withRowAnimation: animation)
        self.insertRowsAtIndexPaths(inserts, withRowAnimation: animation)
        self.endUpdates()
    }
}

public extension GenericTableView {

    /**
     Render table view rows with animation. If changes are not specified,
     table view will compute the differences between 2 set and animate
     the changes accordingly.
     */
    func render(rowModels models: [Model], animation: UITableViewRowAnimation = .Automatic) {
        guard rowModels != models else { return }

        if animation == .None {
            rowModels = models
            self.reloadData()
            return
        }

        let indexes = self.indexPathsForVisibleRows?.flatMap {
            $0.section == 0 ? nil : $0.row
            } ?? []

        let range: Range<Int>?
        if !indexes.isEmpty {
            let startIndex = indexes.minElement() ?? 0
            let endIndex = indexes.maxElement() ?? 0
            range = startIndex...endIndex
        } else {
            range = nil
        }

        let (deletes, inserts) = self.rowModels.compare(models, range: range, inSection: 0)
        rowModels = models

        self.beginUpdates()
        self.deleteRowsAtIndexPaths(deletes, withRowAnimation: animation)
        self.insertRowsAtIndexPaths(inserts, withRowAnimation: animation)
        self.endUpdates()
    }
}