//
//  Envelope.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Marshal

enum Periodicity {
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

}

struct Envelope {

    var id: String = Date().iso8601String
    var createdAt: Date {
        return Calendar.current.date(byAdding: .day, value: -16, to: Date())!
    }

    var modifiedAt = Date()
    var isActive: Bool = true
    var ownerId: String
    var name: String
    var periodicity: Periodicity = .monthly(Date().startOfMonth())
    var recurringAmount: Double
    var startingAmount: Double
    var goal: Double = 0
    var expenses = [Expense]()

    var totalExpenses: Double {
        return expenses.reduce(0, { $0 + $1.amount } )
    }

    var accumulatedAmount: Double {
        var date = createdAt
        if case .monthly(_) = periodicity {
            date = createdAt.startOfMonth()
        }
        let timePassedString = date.timeAgo(periodicity: periodicity)
        var numberOnlyString: String = ""
        for (_, character) in timePassedString.enumerated() {
            if Double(String(character)) != nil {
                numberOnlyString.append(character)
            }
        }
        if let timePassed = Double(String(numberOnlyString)) {
            switch periodicity {
            case .monthly(_), .daily:
                return timePassed * recurringAmount
            case .weekly(let weekday):
                let createdAtWeekday = createdAt.dayNumberOfWeek()
                let daysToDeposit = 7 - (createdAtWeekday - weekday.rawValue)
                let weeksPassed = 1 + ((timePassed - Double(daysToDeposit)) / 7)
                return Double(weeksPassed) * recurringAmount
            }
        }
        return 0
    }

    var totalAmount: Double {
        return startingAmount - totalExpenses + accumulatedAmount
    }

    var hasGoal: Bool {
        return goal > 0
    }

    init(newEnvelope: NewEnvelope) {
        ownerId = "user"
        name = newEnvelope.name!
        periodicity = newEnvelope.periodicity
        recurringAmount = newEnvelope.recurringAmount
        goal = newEnvelope.goal
        startingAmount = newEnvelope.startingAmount
    }
    
}

extension Envelope: JSONMarshaling {

    func jsonObject() -> JSONObject {
        return [:]
    }

}

extension Envelope: Equatable {

    static func ==(lhs: Envelope, rhs: Envelope) -> Bool {
        return lhs.id == rhs.id
    }

}

extension Double {

    func currency() -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self))
    }
    
}

extension String {

    func currency() -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        guard let double = Double(self) else { return nil }
        return formatter.string(from: NSNumber(value: double))
    }

}


