//
//  Currency.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/18/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit

class Currency {
    
    static var currencies: [Currency] = {
        var currencies = [Currency]()
        let path = Bundle.main.path(forResource: "Currencies", ofType: "plist")!
        for entry in NSArray(contentsOfFile: path)! {
            if let entry = entry as? [String: AnyObject],
                let name = entry["name"] as? String,
                let image = entry["image"] as? String {
                let currency = Currency(name: name, image: UIImage(named: "icons8-ecg-40")!)
                currencies.append(currency)
            }
        }
        return currencies
    }()
    
    static func currency(named name: String) -> Currency? {
        return currencies.filter({ (currency) -> Bool in
            currency.name == name
        }).first
    }
    
    var name: String
    var image: UIImage
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
}

// MARK: - Equatable

extension Currency: Equatable {
    
}

func ==(lhs: Currency, rhs: Currency) -> Bool {
    return lhs.name == rhs.name
}
