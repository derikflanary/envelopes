//
//  Deposit.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/21/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Marshal

struct Deposit: Unmarshaling {

    var id: String = Date().iso8601String
    var createdAt = Date()
    var amount: Double
    var envelopeId: String


    init(object: MarshaledObject) throws {
        let createdAtInt: Int = try object.value(for: Keys.createdAt)
        let createdAt: Date = Date(timeIntervalSince1970: Double(createdAtInt) / 1000)
        self.createdAt = createdAt

        amount = try object.value(for: Keys.amount)
        id = try object.value(for: Keys.id)
        envelopeId = try object.value(for: Keys.envelopeId)
    }

    init(_ newDeposit: NewDeposit, envelopeId: String) {
        amount = newDeposit.amount!
        self.envelopeId = envelopeId
    }

}

extension Deposit: JSONMarshaling {

    func jsonObject() -> JSONObject {
        return [Keys.createdAt: createdAt.millisecondsSince1970,
                Keys.amount: amount,
                Keys.envelopeId: envelopeId]
    }

}

struct NewDeposit {

    var amount: Double?

    var isReady: Bool {
        return amount != nil
    }

}
