/*
 * Diff.swift
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

public struct Diff<T: Equatable> {

    public typealias Step = (Int, T)
    public typealias Indexes = Set<Int>

    public let deletes: [Step]
    public let inserts: [Step]

    public var isEmpty: Bool {
        return inserts.isEmpty && deletes.isEmpty
    }

    internal init(deletes: [Step] = [], inserts: [Step] = []) {
        self.deletes = deletes
        self.inserts = inserts
    }
}

public extension Diff {

    typealias Updates = (reload: Indexes, delete: Indexes, insert: Indexes)

    var updates: Updates {
        let deleteIndexesSet = Set(self.deletes.map { $0.0 })
        let insertIndexesSet = Set(self.inserts.map { $0.0 })

        let reloads = deleteIndexesSet.intersect(insertIndexesSet)
        let deletes = deleteIndexesSet.subtract(insertIndexesSet)
        let inserts = insertIndexesSet.subtract(deleteIndexesSet)

        return (reloads, deletes, inserts)
    }
}

extension Diff: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "Deletes: \(deletes.debugDescription)\nInserts: \(inserts.debugDescription)"
    }
}