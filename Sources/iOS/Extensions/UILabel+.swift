/*
 * UILabel+.swift
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

/// :nodoc:
public extension UILabel {

    // FIXME: unable to make it work in an app

    func boundingRectForCharacters(`in` range: NSRange) -> CGRect {
        guard let attributedText = self.attributedText else { return CGRectNull }
        let layoutManager = NSLayoutManager()

        // unable to use `then` because of text storage reference
        NSTextStorage(attributedString: attributedText).addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: bounds.size)
            .then { $0.lineFragmentPadding = 0 }
            .then(layoutManager.addTextContainer)

        var glyphRange = NSRange()

        // Convert the range for glyphs.
        layoutManager.characterRangeForGlyphRange(range, actualGlyphRange: &glyphRange)
        return layoutManager.boundingRectForGlyphRange(glyphRange, inTextContainer: textContainer)
    }
}
