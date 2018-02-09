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

    static let dolarIdentifier = NSTouchBarItem.Identifier("GoToo.icon.dolar")
    static let rateIdentifier = NSTouchBarItem.Identifier("GoToo.icon.rate")
    
    var ControlButton: NSButton!
    var KantorApi: KantorAliorAPI!
    
    var CurrentColor = NSColor.systemBlue
    var CurentExchangeRate = CurrencyExchangeRate(
        sellRate: 0.0,
        buyRate: 0.0,
        sourceCurrencyCode: "USD",
        destinationCurrencyCode: "PLN")
    
    override func windowDidLoad() {
        super.windowDidLoad()
        createControl()
        KantorApi = KantorAliorAPI()
        
        GoTooButton.title = "..."
        GoTooButton.bezelColor = NSColor.systemBlue
        
        updateRate()
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateRate), userInfo: nil, repeats: true)
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

        let rate = NSCustomTouchBarItem.init(identifier: WindowController.rateIdentifier)
        rate.view = GoTooButton

        NSTouchBar.presentSystemModalFunctionBar(touchBar, systemTrayItemIdentifier: rate.identifier.rawValue)
    }
    
    func createControl() -> Void {
        DFRSystemModalShowsCloseBoxWhenFrontMost(true)
        
        let dolar = NSCustomTouchBarItem.init(identifier: WindowController.dolarIdentifier)
        ControlButton = NSButton.init(title: "$", target: self, action: #selector(showRate))

        ControlButton.bezelColor = NSColor.systemBlue
        dolar.view = ControlButton
        
        NSTouchBarItem.addSystemTrayItem(dolar)
        
        DFRElementSetControlStripPresenceForIdentifier(dolar.identifier.rawValue, true);
    }
    
    func updateColor(exchangeRate: CurrencyExchangeRate) -> Void {
        DispatchQueue.main.async {
            if self.CurentExchangeRate.buyRate > exchangeRate.buyRate {
                self.CurrentColor = NSColor.systemRed
            } else if self.CurentExchangeRate.buyRate < exchangeRate.buyRate {
                self.CurrentColor = NSColor.systemGreen
            } else {
                print("-")
            }
            self.GoTooButton.bezelColor = self.CurrentColor
            self.ControlButton.bezelColor = self.CurrentColor
            self.CurentExchangeRate = exchangeRate;
        }
    }
    
    func update(exchangeRate: CurrencyExchangeRate) -> Void {
        DispatchQueue.main.async {
            self.GoTooButton.title = exchangeRate.buyRate.description + " zł"
        }
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        GoTooButton.bezelColor = NSColor.systemOrange
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(WindowController.updateRate), userInfo: nil, repeats: false)
    }
}
