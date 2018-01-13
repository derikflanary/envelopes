//
//  Expense.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Marshal

struct Expense {

    var createdAt = Date()
    var modifiedAt = Date()
    var amount: Double
    var name: String

    init(_ newExpense: NewExpense) {
        amount = newExpense.amount!
        name = newExpense.name!
    }
}

extension Expense: JSONMarshaling {

    func jsonObject() -> JSONObject {
        return [:]
    }

}

struct NewExpense {

    var amount: Double?
    var name: String?

    var isReady: Bool {
        return amount != nil && name != nil
    }
    
}

// MARK: - Endpoint naming

extension Envelope: EndpointNaming {

    static let endpointName = Keys.Endpoint.envelopes

}
