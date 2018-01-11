//
//  GenericEvents.swift
//  foos
//
//  Created by Derik Flanary on 1/12/17.
//  Copyright © 2017 Derik Flanary. All rights reserved.
//

import Foundation
import Reactor

struct Created<T>: Event {
    let item: T
}

struct Selected<T>: Event {
    var item: T?
}

struct Updated<T>: Event {
    var item: T
}

struct Loaded<T>: Event {
    var items: [T]
}

struct Added<T>: Event {
    var item: T
}

struct Deleted<T>: Event {
    var item: T
}

struct Reset<T>: Reactor.Event {
    var customReset: ((T) -> T)?
}

struct ErrorDisplayed: Event { }
