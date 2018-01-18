//
//  Keys.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/6/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation

struct Keys {

    static let amount = "amount"
    static let users = "authUsers"
    static let createdAt = "createdAt"
    static let goal = "goal"
    static let expenses = "expenses"
    static let envelopeId = "envelopeId"
    static let id = "id"
    static let isActive = "isActive"
    static let modifiedAt = "modifiedAt"
    static let name = "name"
    static let ownerId = "ownerId"
    static let periodicity = "periodicity"
    static let recurringAmount = "recurringAmount"
    static let startingAmount = "startingAmount"
    static let totalAmount = "totalAmount"
    static let weekday = "weekday"
    
    enum Endpoint {
        static let users = "authUsers"
        static let envelopes = "envelopes"
    }
}
