//
//  ChatHistoryDelegate.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 8/31/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import Foundation
protocol ChatHistoryDelegate {
    func chatHistoryUpdateRecieved(data: Message?)
}

