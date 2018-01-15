//
//  Weekday.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation

enum Weekday: Int {
    case sunday
    case monday

    var displayName: String {
        return Weekday.dateFormatter.weekdaySymbols[rawValue]
    }

    static let allWeekdays: [Weekday] = [.sunday, .monday]


    // MARK: - Private properties

    fileprivate static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}
