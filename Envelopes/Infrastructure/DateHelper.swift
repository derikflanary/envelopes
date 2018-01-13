//
//  DateHelper.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation


private struct DateHelper {

    static let secondsAgoFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.includesApproximationPhrase = false
        formatter.allowsFractionalUnits = false
        formatter.allowedUnits = [.second]
        return formatter
    }()

    static let minutesAgoFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.includesApproximationPhrase = false
        formatter.allowsFractionalUnits = false
        formatter.allowedUnits = [.minute]
        return formatter
    }()

    static let hoursAgoFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.includesApproximationPhrase = false
        formatter.allowsFractionalUnits = false
        formatter.allowedUnits = [.hour]
        return formatter
    }()

    static let daysAgoFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.includesApproximationPhrase = false
        formatter.allowsFractionalUnits = false
        formatter.allowedUnits = [.day]
        return formatter
    }()

    static let weeksAgoFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.includesApproximationPhrase = false
        formatter.allowsFractionalUnits = false
        formatter.allowedUnits = [.weekOfYear]
        return formatter
    }()

    static let monthsAgoFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.maximumUnitCount = 1
        formatter.includesApproximationPhrase = false
        formatter.allowsFractionalUnits = false
        formatter.allowedUnits = [.month]
        return formatter
    }()

    static let dateThisYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMMd")
        return formatter
    }()

    static let dateLastYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

}


extension Date {

    static fileprivate let ISO8601SecondFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let tz = TimeZone(abbreviation: "GMT")
        formatter.timeZone = tz
        return formatter
    }()

    static fileprivate let dayMonthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    /**
     Social Date Format

     40 seconds ago      Begin timing the date with seconds
     17 minutes ago      After 59 seconds, switch to minutes
     2 hours ago         After 59 minutes, switch to hours
     4 days ago          After 24 hours, switch to days
     July 24             After 7 days, but within the same calendar year, show date without year
     July 24, 2016       After 7 days, and not within the same calendar year show long format
     */
    func timeAgoInWords() -> String {
        let timeRemainingInterval = abs(self.timeIntervalSinceNow)
        let durationString: String

        if timeRemainingInterval < 1.minute {
            durationString = DateHelper.secondsAgoFormatter.string(from: timeRemainingInterval)!
        } else if timeRemainingInterval < 1.hour {
            durationString = DateHelper.minutesAgoFormatter.string(from: timeRemainingInterval)!
        } else if timeRemainingInterval < 1.day {
            durationString = DateHelper.hoursAgoFormatter.string(from: timeRemainingInterval)!
        } else if timeRemainingInterval < 7.days {
            durationString = DateHelper.daysAgoFormatter.string(from: timeRemainingInterval)!
        } else if Calendar.current.isDateInThisYear(self) {
            // Return date without adding "ago"
            return DateHelper.dateThisYearFormatter.string(from: self)
        } else {
            // Return date without adding "ago"
            return DateHelper.dateLastYearFormatter.string(from: self)
        }

        return durationString
    }

    func timeAgo(periodicity: Periodicity) -> String {
        let timeRemainingInterval = abs(self.timeIntervalSinceNow)
        let durationString: String
        switch periodicity {
        case .daily:
            durationString = DateHelper.daysAgoFormatter.string(from: timeRemainingInterval)!
        case .weekly(_):
            durationString = DateHelper.weeksAgoFormatter.string(from: timeRemainingInterval)!
        case .monthly:
            durationString = DateHelper.monthsAgoFormatter.string(from: timeRemainingInterval)!
        }
        return durationString
    }

    var iso8601String: String {
        return Date.ISO8601SecondFormatter.string(from: self)
    }

    var dayMonthYearString: String {
        return Date.dayMonthYearFormatter.string(from: self)
    }
}


private var hoursPerDay = 24
private var minutesPerHour = 60
private var secondsPerMinute = 60

extension BinaryInteger {

    var month: DateComponents {
        return months
    }

    var months: DateComponents {
        var components = DateComponents()
        components.month = Int(self.description)
        return components
    }

    var week: DateComponents {
        return weeks
    }

    var weeks: DateComponents {
        var components = DateComponents()
        components.weekOfYear = Int(self.description)
        return components
    }

    var day: DateComponents {
        return days
    }

    var days: DateComponents {
        var components = DateComponents()
        components.day = Int(self.description)!
        return components
    }

    var hour: DateComponents {
        return hours
    }

    var hours: DateComponents {
        var components = DateComponents()
        components.hour = Int(self.description)!
        return components
    }

    var minute: DateComponents {
        return minutes
    }

    var minutes: DateComponents {
        var components = DateComponents()
        components.minute = Int(self.description)!
        return components
    }

    var second: DateComponents {
        return seconds
    }

    var seconds: DateComponents {
        var components = DateComponents()
        components.second = Int(self.description)!
        return components
    }

}


extension DateComponents {

    var ago: Date {
        return before(Date())
    }

    var fromNow: Date {
        return after(Date())
    }

    func before(_ date: Date) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: self.inverted(), to: date, options: [])!
    }

    func after(_ date: Date) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: self, to: date, options: [])!
    }

    var inSeconds: TimeInterval {
        let hours = (day ?? 0) * hoursPerDay + (hour ?? 0)
        let minutes = hours * minutesPerHour + (minute ?? 0)
        let seconds = minutes * secondsPerMinute + (second ?? 0)
        return TimeInterval(seconds)
    }

    func inverted() -> DateComponents {
        var components = (self as NSDateComponents).copy() as! DateComponents

        if components.year != nil && components.year != NSDateComponentUndefined {
            components.year = -1 * components.year!
        }
        if components.month != nil && components.month != NSDateComponentUndefined {
            components.month = -1 * components.month!
        }
        if components.day != nil && components.day != NSDateComponentUndefined {
            components.day = -1 * components.day!
        }
        if components.hour != nil && components.hour != NSDateComponentUndefined {
            components.hour = -1 * components.hour!
        }
        if components.minute != nil && components.minute != NSDateComponentUndefined {
            components.minute = -1 * components.minute!
        }
        if components.second != nil && components.second != NSDateComponentUndefined {
            components.second = -1 * components.second!
        }

        return components
    }

}


extension Calendar {

    func isDateInThisYear(_ date: Date) -> Bool {
        return self.isDate(date, equalTo: Date(), toGranularity: .year)
    }

}


func <(left: TimeInterval, right: DateComponents) -> Bool {
    return left < right.inSeconds
}
