//
//  Periodicity.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/17/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Marshal

enum Periodicity: JSONMarshaling, Unmarshaling {
    case daily
    case weekly(Weekday)
    case monthly(Date)

    var displayName: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly(_):
            return "Weekly"
        case .monthly(_):
            return "First of Each Month"
        }
    }

    var description: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly(let weekday):
            return "Each week on \(weekday.displayName)"
        case .monthly(_):
            return "First day of each month."
        }
    }

    var key: String {
        switch self {
        case .daily:
            return "daily"
        case .weekly(_):
            return "weekly"
        case .monthly(_):
            return "monthly"
        }
    }


    init(object: MarshaledObject) throws {
        if let _: Bool = try? object.value(for: Periodicity.daily.key) {
            self = .daily
        }
        if let weekdayInt: Int = try? object.value(for: Periodicity.weekly(.sunday).key), let weekday = Weekday(rawValue: weekdayInt) {
            self = .weekly(weekday)
            return
        }
        if let monthlyStartInt: Double = try? object.value(for: Periodicity.monthly(Date()).key) {
            let date = Date(timeIntervalSince1970: monthlyStartInt)
            self = .monthly(date)
            return
        }
        self = .daily
    }

    func jsonObject() -> JSONObject {

        switch self {
        case .daily:
            return [key: true]
        case .weekly(let weekday):
            return [key: weekday.rawValue]
        case .monthly(let startDate):
            return [key: startDate.millisecondsSince1970]
        }
    }

}
