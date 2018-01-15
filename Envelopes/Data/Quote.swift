//
//  Quote.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/14/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation

struct Quote {

    var text: String
    var author: String
}

var quotes: [Quote] = [Quote(text: "It is not the man who has too little, but the man who craves more, that is poor.", author: "Seneca"),
                        Quote(text: "The art is not in making money, but in keeping it", author: "Proverb"),
                        Quote(text: "Beware of little expenses; a small leak will sink a great ship.", author: "Benjamin Franklin"),
                        Quote(text: "You must gain control over your money or the lack of it will forever control you.", author: "Dave Ramsey"),
                        Quote(text: "Many people take no care of their money till they come nearly to the end of it, and others do just the same with their time.", author: "Johann Wolfgang von Goethe"),
                        Quote(text: "“A penny saved is a penny earned.”", author: "Benjamin Franklin"),
                        Quote(text: "If saving money is wrong, I don’t want to be right.", author: "William Shatner"),
                        Quote(text: "The way to build your savings is by spending less each month.", author: "Suze Orman"),
                        Quote(text: "Too many people spend money they haven't earned, to buy things they don't want, to impress people that they don't like.", author: "Will Rogers"),
                        Quote(text: "Money may not buy happiness, but I'd rather cry in a Jaguar than on a bus.", author: "Francoise Sagan"),
                        Quote(text: "Money cannot buy health, but I'd settle for a diamond-studded-wheelchair.", author: "Dorthy Parker"),
                        Quote(text: "Money isn't everything...but it ranks right up there with oxygen.", author: "Rita Davenport"),
                        Quote(text: "It’s clearly a budget. It’s got lots of numbers in it.", author: "George W. Bush"),
                        Quote(text: "That money talks, I'll not deny, I heard it once: it said, 'goodbye.'", author: "Richard Armour"),
                        Quote(text: "It’s easier to feel a little more spiritual with a couple of bucks in your pocket.", author: "Craig Ferguson"),
                        Quote(text: "A nickel ain't worth a dime anymore.", author: "Yogi Berra"),
                        Quote(text: "Money frees you from doing things you dislike. Since I dislike doing nearly everything, money is handy.", author: "Groucho Marx"),
                        Quote(text: "If you think nobody cares if you're alive, try missing a couple of car payments.", author: "Earl Wilson")]

extension Collection where Index == Int {

    /**
     Picks a random element of the collection.

     - returns: A random element of the collection.
     */
    func randomElement() -> Iterator.Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(endIndex)))]
    }

}
