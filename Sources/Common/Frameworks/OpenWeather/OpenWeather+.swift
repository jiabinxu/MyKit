/*
 * OpenWeather+.swift
 * MyKit
 *
 * Copyright (c) 2015–2016 Hai Nguyen
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

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public extension OpenWeather {

    // d - day; n - night
    enum Icon: String {

        case D200 = "D200"
        case D201 = "D201"
        case D202 = "D202"
        case D210 = "D210"
        case D211 = "D211"
        case D212 = "D212"
        case D221 = "D221"
        case D230 = "D230"
        case D231 = "D231"
        case D232 = "D232"
        case D300 = "D300"
        case D301 = "D301"
        case D302 = "D302"
        case D310 = "D310"
        case D311 = "D311"
        case D312 = "D312"
        case D313 = "D313"
        case D314 = "D314"
        case D321 = "D321"
        case D500 = "D500"
        case D501 = "D501"
        case D502 = "D502"
        case D503 = "D503"
        case D504 = "D504"
        case D511 = "D511"
        case D520 = "D520"
        case D521 = "D521"
        case D522 = "D522"
        case D531 = "D531"
        case D600 = "D600"
        case D601 = "D601"
        case D602 = "D602"
        case D611 = "D611"
        case D612 = "D612"
        case D615 = "D615"
        case D616 = "D616"
        case D620 = "D620"
        case D621 = "D621"
        case D622 = "D622"
        case D701 = "D701"
        case D711 = "D711"
        case D721 = "D721"
        case D731 = "D731"
        case D741 = "D741"
        case D761 = "D761"
        case D762 = "D762"
        case D781 = "D781"
        case D800 = "D800"
        case D801 = "D801"
        case D802 = "D802"
        case D803 = "D803"
        case D804 = "D804"
        case D900 = "D900"
        case D902 = "D902"
        case D903 = "D903"
        case D904 = "D904"
        case D906 = "D906"
        case D957 = "D957"
        case N200 = "N200"
        case N201 = "N201"
        case N202 = "N202"
        case N210 = "N210"
        case N211 = "N211"
        case N212 = "N212"
        case N221 = "N221"
        case N230 = "N230"
        case N231 = "N231"
        case N232 = "N232"
        case N300 = "N300"
        case N301 = "N301"
        case N302 = "N302"
        case N310 = "N310"
        case N311 = "N311"
        case N312 = "N312"
        case N313 = "N313"
        case N314 = "N314"
        case N321 = "N321"
        case N500 = "N500"
        case N501 = "N501"
        case N502 = "N502"
        case N503 = "N503"
        case N504 = "N504"
        case N511 = "N511"
        case N520 = "N520"
        case N521 = "N521"
        case N522 = "N522"
        case N531 = "N531"
        case N600 = "N600"
        case N601 = "N601"
        case N602 = "N602"
        case N611 = "N611"
        case N612 = "N612"
        case N615 = "N615"
        case N616 = "N616"
        case N620 = "N620"
        case N621 = "N621"
        case N622 = "N622"
        case N701 = "N701"
        case N711 = "N711"
        case N721 = "N721"
        case N731 = "N731"
        case N741 = "N741"
        case N761 = "N761"
        case N762 = "N762"
        case N781 = "N781"
        case N800 = "N800"
        case N801 = "N801"
        case N802 = "N802"
        case N803 = "N803"
        case N804 = "N804"
        case N900 = "N900"
        case N902 = "N902"
        case N903 = "N903"
        case N904 = "N904"
        case N906 = "N906"
        case N957 = "N957"
    }
}

public extension OpenWeather.Icon {

    public init?(condition: Int, icon: String) {
        guard 100...999 ~= condition else { return nil}

        let initial = icon[icon.startIndex] == "n" ? "N" : "D"
        self.init(rawValue: initial + "\(condition)")
    }
}

extension OpenWeather.Icon: CustomStringConvertible {

    public var description: String {
        switch self {

        case .D200: return "\u{f010}"
        case .D201: return "\u{f010}"
        case .D202: return "\u{f010}"
        case .D210: return "\u{f005}"
        case .D211: return "\u{f005}"
        case .D212: return "\u{f005}"
        case .D221: return "\u{f005}"
        case .D230: return "\u{f010}"
        case .D231: return "\u{f010}"
        case .D232: return "\u{f010}"
        case .D300: return "\u{f00b}"
        case .D301: return "\u{f00b}"
        case .D302: return "\u{f008}"
        case .D310: return "\u{f008}"
        case .D311: return "\u{f008}"
        case .D312: return "\u{f008}"
        case .D313: return "\u{f008}"
        case .D314: return "\u{f008}"
        case .D321: return "\u{f00b}"
        case .D500: return "\u{f00b}"
        case .D501: return "\u{f008}"
        case .D502: return "\u{f008}"
        case .D503: return "\u{f008}"
        case .D504: return "\u{f008}"
        case .D511: return "\u{f006}"
        case .D520: return "\u{f009}"
        case .D521: return "\u{f009}"
        case .D522: return "\u{f009}"
        case .D531: return "\u{f00e}"
        case .D600: return "\u{f00a}"
        case .D601: return "\u{f0b2}"
        case .D602: return "\u{f00a}"
        case .D611: return "\u{f006}"
        case .D612: return "\u{f006}"
        case .D615: return "\u{f006}"
        case .D616: return "\u{f006}"
        case .D620: return "\u{f006}"
        case .D621: return "\u{f00a}"
        case .D622: return "\u{f00a}"
        case .D701: return "\u{f009}"
        case .D711: return "\u{f062}"
        case .D721: return "\u{f0b6}"
        case .D731: return "\u{f063}"
        case .D741: return "\u{f003}"
        case .D761: return "\u{f063}"
        case .D762: return "\u{f063}"
        case .D781: return "\u{f056}"
        case .D800: return "\u{f00d}"
        case .D801: return "\u{f000}"
        case .D802: return "\u{f000}"
        case .D803: return "\u{f000}"
        case .D804: return "\u{f00c}"
        case .D900: return "\u{f056}"
        case .D902: return "\u{f073}"
        case .D903: return "\u{f076}"
        case .D904: return "\u{f072}"
        case .D906: return "\u{f004}"
        case .D957: return "\u{f050}"
        case .N200: return "\u{f02d}"
        case .N201: return "\u{f02d}"
        case .N202: return "\u{f02d}"
        case .N210: return "\u{f025}"
        case .N211: return "\u{f025}"
        case .N212: return "\u{f025}"
        case .N221: return "\u{f025}"
        case .N230: return "\u{f02d}"
        case .N231: return "\u{f02d}"
        case .N232: return "\u{f02d}"
        case .N300: return "\u{f02b}"
        case .N301: return "\u{f02b}"
        case .N302: return "\u{f028}"
        case .N310: return "\u{f028}"
        case .N311: return "\u{f028}"
        case .N312: return "\u{f028}"
        case .N313: return "\u{f028}"
        case .N314: return "\u{f028}"
        case .N321: return "\u{f02b}"
        case .N500: return "\u{f02b}"
        case .N501: return "\u{f028}"
        case .N502: return "\u{f028}"
        case .N503: return "\u{f028}"
        case .N504: return "\u{f028}"
        case .N511: return "\u{f026}"
        case .N520: return "\u{f029}"
        case .N521: return "\u{f029}"
        case .N522: return "\u{f029}"
        case .N531: return "\u{f02c}"
        case .N600: return "\u{f02a}"
        case .N601: return "\u{f0b4}"
        case .N602: return "\u{f02a}"
        case .N611: return "\u{f026}"
        case .N612: return "\u{f026}"
        case .N615: return "\u{f026}"
        case .N616: return "\u{f026}"
        case .N620: return "\u{f026}"
        case .N621: return "\u{f02a}"
        case .N622: return "\u{f02a}"
        case .N701: return "\u{f029}"
        case .N711: return "\u{f062}"
        case .N721: return "\u{f0b6}"
        case .N731: return "\u{f063}"
        case .N741: return "\u{f04a}"
        case .N761: return "\u{f063}"
        case .N762: return "\u{f063}"
        case .N781: return "\u{f056}"
        case .N800: return "\u{f02e}"
        case .N801: return "\u{f022}"
        case .N802: return "\u{f022}"
        case .N803: return "\u{f022}"
        case .N804: return "\u{f086}"
        case .N900: return "\u{f056}"
        case .N902: return "\u{f073}"
        case .N903: return "\u{f076}"
        case .N904: return "\u{f072}"
        case .N906: return "\u{f024}"
        case .N957: return "\u{f050}"
        }
    }
}


public extension OpenWeather.Icon {

    func attributedStringOf(size: CGFloat) -> NSMutableAttributedString {
        let name = "Weather Icons", file = "OpenWeather"
        return NSMutableAttributedString(string: self.description)
            .then { $0.addFont(.fontWith(name: name, size: size, fromFile: file)) }
    }
}