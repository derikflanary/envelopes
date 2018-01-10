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

}

extension Expense: JSONMarshaling {

    func jsonObject() -> JSONObject {
        return [:]
    }

}

// MARK: - Endpoint naming

extension Envelope: EndpointNaming {

    static let endpointName = Keys.Endpoint.envelopes

}
