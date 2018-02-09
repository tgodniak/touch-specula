//
//  KantorAliorAPI.swift/Users/tgodniak/Apps/TouchSpecula/KantorAliorAPI.swift
//  TouchSpecula
//
//  Created by GoToo on 07/02/2018.
//  Copyright © 2018 GoToo. All rights reserved.
//

import Cocoa

class KantorAliorAPI: NSObject {
    let BASE_URL = "https://kantor.aliorbank.pl/chart/USD/json"
    
    func fetchRates(success: @escaping (CurrencyExchangeRate) -> Void) {
        let urlString = URL(string: BASE_URL)
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    if let exchangedata = self.ratesFromJSONData(data: data) {
                        success(exchangedata)
                    }
                }
            }
            task.resume()
        }
    }
    
    func formatRate(rate: String) -> Float {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.number(from: rate) as! Float
    }
    
    func ratesFromJSONData(data: Data?) -> CurrencyExchangeRate? {
        if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
            var x = json as! [String: Any]
            return CurrencyExchangeRate(
                sellRate: formatRate(rate: x["actualSellRate"] as! String),
                buyRate: formatRate(rate: x["actualBuyRate"] as! String),
                sourceCurrencyCode: "USD",
                destinationCurrencyCode: "PLN"
            )
        } else {
            return nil
        }
    }
}
