//
//  WindowController.swift
//  TouchSpecula
//
//  Created by GoToo on 07/02/2018.
//  Copyright © 2018 GoToo. All rights reserved.
//

import Cocoa
import Foundation
import AppKit

class WindowController: NSWindowController {
    
    @IBOutlet weak var GoTooButton: NSButton!
    @IBOutlet weak var GoTooLabel: NSTextField!

    var KantorApi: KantorAliorAPI!
    var CurentExchangeRate = CurrencyExchangeRate(
        sellRate: 0.0,
        buyRate: 0.0,
        sourceCurrencyCode: "USD",
        destinationCurrencyCode: "PLN")
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        GoTooButton.title = "..."
        GoTooButton.bezelColor = NSColor.systemBlue
        KantorApi = KantorAliorAPI()
        
        updateRate()
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(WindowController.updateRate), userInfo: nil, repeats: true)
    }
    
    @objc func updateRate() -> Void {
        KantorApi.fetchRates() { rate in
            self.updateColor(exchangeRate: rate);
            self.update(exchangeRate: rate)
        }
    }
    
    func updateColor(exchangeRate: CurrencyExchangeRate) -> Void {
        DispatchQueue.main.async {
            if self.CurentExchangeRate.buyRate > exchangeRate.buyRate {
                self.GoTooButton.bezelColor = NSColor.systemRed
            } else {
                self.GoTooButton.bezelColor = NSColor.systemGreen
            }
            self.CurentExchangeRate = exchangeRate;
        }
    }
    
    func update(exchangeRate: CurrencyExchangeRate) -> Void {
        DispatchQueue.main.async {
            self.GoTooButton.title = "USD: " + exchangeRate.buyRate.description
            self.GoTooLabel.cell?.title = exchangeRate.buyRate.description
        }
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        GoTooButton.bezelColor = NSColor.systemOrange
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(WindowController.updateRate), userInfo: nil, repeats: false)
    }
}
