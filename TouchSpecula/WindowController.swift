//
//  WindowController.swift
//  TouchSpecula
//
//  Created by GoToo on 07/02/2018.
//  Copyright © 2018 GoToo. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    @IBOutlet weak var GoTooButton: NSButton!

    var KantorApi: KantorAliorAPI!
    var CurentExchangeRate = CurrencyExchangeRate(
        sellRate: 0.0,
        buyRate: 0.0,
        sourceCurrencyCode: "USD",
        destinationCurrencyCode: "PLN")
    
    override func windowDidLoad() {
        super.windowDidLoad()
        createControl()
        KantorApi = KantorAliorAPI()
        
//        GoTooButton.title = "..."
//        GoTooButton.bezelColor = NSColor.systemBlue
//
//
//        updateRate()
//        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateRate), userInfo: nil, repeats: true)
    }
    
    @objc func updateRate() -> Void {
        print("XXXX")
        KantorApi.fetchRates() { rate in
            self.updateColor(exchangeRate: rate);
            self.update(exchangeRate: rate)
        }
    }
    
    @objc func showRate() -> Void {
        print("RATE")

        let rate = NSCustomTouchBarItem.init(identifier: AppDelegate.rateIdentifier)
        let view = NSButton.init(title: "3.33", target: self, action: #selector(updateRate))
        view.bezelColor = NSColor.systemPink
        rate.view = view

        touchBar?.presentAsSystemModal(for: rate)
    }
    
    func createControl() -> Void {
        DFRSystemModalShowsCloseBoxWhenFrontMost(true)
        
        let dolar = NSCustomTouchBarItem.init(identifier: AppDelegate.dolarIdentifier)
        let view = NSButton.init(title: "$", target: self, action: #selector(showRate))
        view.bezelColor = NSColor.systemGreen
        dolar.view = view
        
        NSTouchBarItem.addSystemTrayItem(dolar)
        
        DFRElementSetControlStripPresenceForIdentifier(dolar.identifier.rawValue, true);
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
        }
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        GoTooButton.bezelColor = NSColor.systemOrange
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(WindowController.updateRate), userInfo: nil, repeats: false)
    }
}
