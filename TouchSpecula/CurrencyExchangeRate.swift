//
//  CurrencyExchangeRate.swift
//  TouchSpecula
//
//  Created by GoToo on 07/02/2018.
//  Copyright © 2018 GoToo. All rights reserved.
//

import Cocoa

struct CurrencyExchangeRate {
    var sellRate: Float
    var buyRate: Float
    var sourceCurrencyCode: String
    var destinationCurrencyCode: String
    var history: [Int]
}
