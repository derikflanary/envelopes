//
//  Envelope.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Marshal

enum Periodicity: JSONMarshaling {
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
            return "monthly."
        }
    }

    func jsonObject() -> JSONObject {

        switch self {
        case .daily:
            return [key: true]
        case .weekly(let weekday):
            return [key: weekday.jsonObject]
        case .monthly(let startDate):
            return [key: startDate.millisecondsSince1970]
        }
    }

}

struct Envelope: Unmarshaling {

    var id: String = Date().iso8601String
    var createdAt = Date()
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

    init(object: MarshaledObject) throws {
        id = try object.value(for: Keys.id)
        let createdAtInt: Int = try object.value(for: Keys.createdAt)
        let createdAt: Date = Date(timeIntervalSince1970: Double(createdAtInt))
        self.createdAt = createdAt

        let modifiedAtInt: Int = try object.value(for: Keys.modifiedAt)
        let modifiedAt: Date = Date(timeIntervalSince1970: Double(modifiedAtInt))
        self.modifiedAt = modifiedAt

        name = try object.value(for: Keys.name)
        recurringAmount = try object.value(for: Keys.recurringAmount)
        startingAmount = try object.value(for: Keys.startingAmount)
        ownerId = try object.value(for: Keys.ownerId)
        goal = try object.value(for: Keys.goal)
        isActive = try object.value(for: Keys.isActive)
        expenses = try object.value(for: Keys.expenses)
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
        var envelopeJsonObject: JSONObject = [Keys.createdAt: createdAt.millisecondsSince1970,
                          Keys.modifiedAt: modifiedAt.millisecondsSince1970,
                          Keys.ownerId: ownerId,
                          Keys.name: name,
                          Keys.periodicity: periodicity.jsonObject(),
                          Keys.recurringAmount: recurringAmount,
                          Keys.startingAmount: startingAmount,
                          Keys.goal: goal,
                          Keys.isActive: isActive]
        let expensesJson = expenses.map { $0.jsonObject() }
        envelopeJsonObject[Keys.expenses] = expensesJson
        return [id: envelopeJsonObject]
    }

}

extension Envelope: Equatable {

    static func ==(lhs: Envelope, rhs: Envelope) -> Bool {
        return lhs.id == rhs.id &&
            lhs.totalAmount == rhs.totalAmount &&
            lhs.name == rhs.name &&
            lhs.goal == rhs.goal &&
            lhs.totalAmount == rhs.totalAmount
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


