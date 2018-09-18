//
//  Rate.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/18/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import Foundation

class Rate {
    
    var date: String
    var base: String
    var rates: [String: NSNumber]
    
    init(date: String, base: String, rates: [String: NSNumber]) {
        self.date = date
        self.base = base
        self.rates = rates
        self.rates[base] = 1.0
    }
    
    func minRate() -> NSNumber {
        return rates.values.sorted(by: { (n1, n2) -> Bool in
            return n1.compare(n2) == .orderedAscending
        }).first!
    }
    
    func maxRate() -> NSNumber {
        return rates.values.sorted(by: { (n1, n2) -> Bool in
            return n1.compare(n2) == .orderedAscending
        }).last!
    }
    
}

// MARK: - CustomStringConvertible

extension Rate: CustomStringConvertible {
    
    var description: String {
        return "Rate: date=\(date), base = \(base), rates = \(rates)"
    }
    
}

