//
//  DataStore.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/18/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import Alamofire
import SwiftDate

class DataStore {
    
    static var sharedStore = DataStore()
    
    let APIBaseURL = "http://api.fixer.io"
    let APIDateFormat = DateFormat.custom("yyyy-MM-dd")
    
    func getRates(fromDateString: String, toDateString: String, base: String, symbols: [String], success: @escaping (_ rates: [Rate]) -> Void, failure: (_ error: NSError?) -> Void) {
        guard let fromDate = try? fromDateString.date(format: APIDateFormat),
            let toDate = try? toDateString.date(format: APIDateFormat) else {
                failure(nil)
                return
        }
        print("Fetching \(base)/\(symbols.joined(separator: "/")) rates \(fromDateString) to \(toDateString)")
        let queue = TaskQueue()
        var rates = [Rate]()
        var currentDate = fromDate
        while (currentDate! <= toDate!) {
            let date = currentDate?.string(format: self.APIDateFormat)
            queue.tasks += { result, next in
                self.getRate(date: date!, base: base, symbols: symbols, success: { (rate) in
                    rates.append(rate)
                    next(nil)
                }, failure: { (error) in
                    next(nil)
                })
            }
            currentDate = currentDate! + 1.days
        }
        queue.run() {
            print("Done")
            success(rates)
        }
    }
    
    func getRate(date: String, base: String, symbols: [String], success: @escaping (_ rate: Rate) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        Alamofire.request("\(APIBaseURL)/\(date)", method: .get, parameters: [
            "base": base,
            "symbols": symbols.joined(separator: ",")
            ]).responseJSON { (response) in
                if let error = response.result.error {
                    failure(error)
                    return
                }
                guard let json = response.result.value as? [String: AnyObject],
                    let date = json["date"] as? String,
                    let base = json["base"] as? String,
                    let rates = json["rates"] as? [String: NSNumber] else {
                        failure(nil)
                        return
                }
                let rate = Rate(date: date, base: base, rates: rates)
                success(rate)
        }
    }
    
}
