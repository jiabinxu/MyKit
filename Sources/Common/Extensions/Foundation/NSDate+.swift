/*
 * NSDate+.swift
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

import Foundation

// MARK: Support Method

public extension NSDate {

    public typealias Period = (passed: Int, left: Int)

    public static var Today: NSDate {
        return NSDate().startOfDay()
    }

    public static var Calendar: NSCalendar {
        return .autoupdatingCurrentCalendar()
    }

    public func startOfDay() -> NSDate {
        return NSDate.Calendar.startOfDayForDate(self)
    }

    public func component(unit: NSCalendarUnit) -> Int {
        return NSDate.Calendar.component(unit, fromDate: self)
    }

    public func components(unit: NSCalendarUnit) -> NSDateComponents {
        return NSDate.Calendar.components(unit, fromDate: self)
    }

    public func dateByAdding(unit: NSCalendarUnit, value: Int) -> NSDate {
        return NSDate.Calendar.dateByAddingUnit(unit, value: value, toDate: self, options: [])!
    }

    public func rangeOfUnit(smallerUnit: NSCalendarUnit, inUnit largerUnit: NSCalendarUnit) -> NSRange {
        return NSDate.Calendar.rangeOfUnit(smallerUnit, inUnit: largerUnit, forDate: self)
    }

    public func isMatchedWith(components: NSDateComponents) -> Bool {
        return NSDate.Calendar.date(self, matchesComponents: components)
    }
}

// MARK: First Date

public extension NSDate {

    public func firstDateOfTheMonth() -> NSDate {
        return NSDate.Calendar.dateFromComponents(components([.Year, .Month]))!
    }

    public func firstDateOfTheWeek() -> NSDate {
        return NSDate.Calendar.dateFromComponents(components([.Year, .WeekOfYear]))!
    }
}

// MARK: Number of Days

public extension NSDate {

    public func numberOfDaysInTheMonth() -> Int {
        return rangeOfUnit(.Day, inUnit: .Month).length
    }

    public func numberOfDaysInTheYear() -> Int {
        return rangeOfUnit(.Day, inUnit: .Year).length
    }

    public func numberOfWeeksInTheMonth() -> Int {
        return rangeOfUnit(.WeekOfMonth, inUnit: .Month).length
    }

    public func numberOfWeeksInTheYear() -> Int {
        return rangeOfUnit(.WeekOfYear, inUnit: .Year).length
    }

    public static func numberOfDaysInThisWeek() -> Period {
        var days = Calendar.firstWeekday - Today.components(.Weekday).weekday
        days += 7 * Int(days <= 0)
        return (7 - days, days - 1)
    }

    public static func numberOfDaysInThisMonth() -> Period {
        let days = Calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: .Today).length
        let day = Today.components(.Day).day
        return (day - 1, days - day)
    }

    public static func numberOfWeeksInThisMonth() -> Period {
        let weeks = Calendar.rangeOfUnit(.WeekOfMonth, inUnit: .Month, forDate: .Today).length
        let week = Today.components(.WeekOfMonth).weekOfMonth
        return (week - 1, weeks - week)
    }

    public static func numebrOfDaysInThisMonth() -> Period {
        let days = Calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: .Today).length
        let day = Today.components(.Day).day
        return (day - 1, days - day)
    }
}

// MARK: Date Calculation

public extension NSDate {

    public func dateByAdding(days value: Int) -> NSDate {
        return dateByAdding(.Day, value: value)
    }

    public func dateByAdding(weeks value: Int) -> NSDate {
        return dateByAdding(.Day, value: 7 * value)
    }

    public func dateByAdding(months value: Int) -> NSDate {
        return dateByAdding(.Month, value: value)
    }

    public func dateByAdding(years value: Int) -> NSDate {
        return dateByAdding(.Year, value: value)
    }
}

// MARK: Date Comparison

public extension NSDate {

    public func isSameDayAs(date: NSDate) -> Bool {
        return date
            .components([.Year, .Month, .Day])
            .andThen(isMatchedWith)
    }

    public func isSameWeekAs(date: NSDate) -> Bool {
        return date
            .components([.Year, .WeekOfYear])
            .andThen(isMatchedWith)
    }

    public func isSameMonthAs(date: NSDate) -> Bool {
        return date
            .components([.Year, .Month])
            .andThen(isMatchedWith)
    }

    public func isSameYearAs(date: NSDate) -> Bool {
        return date
            .components(.Year)
            .andThen(isMatchedWith)
    }
}

// MARK: Today Comparison

public extension NSDate {

    public func isInFuture() -> Bool {
        return NSDate.Today.andThen {
            !isSameDayAs($0) && self.compare($0) == .OrderedDescending
        }
    }

    public func isInPast() -> Bool {
        return NSDate.Today.andThen {
            !isSameDayAs($0) && self.compare($0) == .OrderedAscending
        }
    }
}

// MARK: Today Comparison within a Week

public extension NSDate {

    public func isToday() ->Bool {
        return isSameDayAs(.Today)
    }

    public func isTomorrow() -> Bool {
        return NSDate.Today
            .dateByAdding(days: 1)
            .andThen(isSameDayAs)
    }

    public func isYesterday() -> Bool {
        return NSDate.Today
            .dateByAdding(days: -1)
            .andThen(isSameDayAs)
    }
}

// MARK: Today Comparison within a Month

public extension NSDate {

    public func isThisWeek() -> Bool {
        return isSameWeekAs(.Today)
    }

    public func isNextWeek() -> Bool {
        return NSDate.Today
            .dateByAdding(weeks: 1)
            .andThen(isSameWeekAs)
    }

    public func isLastWeek() -> Bool {
        return NSDate.Today
            .dateByAdding(weeks: -1)
            .andThen(isSameWeekAs)
    }
}

// MARK: Today Comparison within a Year

public extension NSDate {

    public func isThisMonth() -> Bool {
        return isSameMonthAs(.Today)
    }

    public func isNextMonth() -> Bool {
        return NSDate.Today
            .dateByAdding(months: 1)
            .andThen(isSameMonthAs)
    }

    public func isLastMonth() -> Bool {
        return NSDate.Today
            .dateByAdding(months: -1)
            .andThen(isSameMonthAs)
    }

    public func isThisYear() -> Bool {
        return isSameYearAs(.Today)
    }

    public func isLastYear() -> Bool {
        return NSDate.Today
            .dateByAdding(years: -1)
            .andThen(isSameYearAs)
    }

    public func isNextYear() -> Bool {
        return NSDate.Today
            .dateByAdding(years: 1)
            .andThen(isSameYearAs)
    }
}

// MARK: String with Style

public extension NSDate {

    public func stringWith(date date: NSDateFormatterStyle, time: NSDateFormatterStyle) -> String {
        return NSDateFormatter.sharedInstance.then {
                $0.timeStyle = time
                $0.dateStyle = date
            }.andThen {
                $0.stringFromDate(self)
            }
    }

    public func stringWith(style: NSDateFormatterStyle) -> String {
        return stringWith(date: style, time: style)
    }

    public func timeStringWith(style: NSDateFormatterStyle) -> String {
        return stringWith(date: .NoStyle, time: style)
    }

    public func dateStringWith(style: NSDateFormatterStyle) -> String {
        return stringWith(date: style, time: .NoStyle)
    }
}