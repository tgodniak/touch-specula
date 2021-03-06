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
        if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any] {
            var history: [Int] = []
            for result in json["history"] as! [[String:Any]] {
                history.append(result["r"] as! Int)
            }
            return CurrencyExchangeRate(
                sellRate: formatRate(rate: json["actualSellRate"] as! String),
                buyRate: formatRate(rate: json["actualBuyRate"] as! String),
                sourceCurrencyCode: "USD",
                destinationCurrencyCode: "PLN",
                history: history
            )
        } else {
            return nil
        }
    }
}
