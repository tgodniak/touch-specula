//
//  WindowController.swift
//  TouchSpecula
//
//  Created by GoToo on 07/02/2018.
//  Copyright © 2018 GoToo. All rights reserved.
//

import Cocoa

@available(OSX 10.12.2, *)
class WindowController: NSWindowController, NSTouchBarDelegate, CAAnimationDelegate {

    @IBOutlet weak var rateButton: NSButton!
    @IBOutlet weak var graphView: NSTouchBarItem!
    @IBOutlet weak var rateView: NSView!
    @IBOutlet weak var moreButton: NSButton!
    
    static let dolarIdentifier = NSTouchBarItem.Identifier("GoToo.icon.dolar")
    static let rateIdentifier = NSTouchBarItem.Identifier("GoToo.icon.rate")
    
    var controlButton: NSButton!
    var KantorApi: KantorAliorAPI!
    
    var currentColor = NSColor.systemBlue
    var curentExchangeRate = CurrencyExchangeRate(
        sellRate: 0.0,
        buyRate: 0.0,
        sourceCurrencyCode: "USD",
        destinationCurrencyCode: "PLN",
        history: [])
    
    override func windowDidLoad() {
        super.windowDidLoad()
        createControl()
        KantorApi = KantorAliorAPI()
        
        rateButton.title = "..."
        rateButton.bezelColor = NSColor.systemBlue
    
        graphView.view?.isHidden = false;
        moreButton.title = "Close"
        
        rateView.wantsLayer = true
//        rateView.layer?.borderWidth = 1
//        rateView.layer?.borderColor = NSColor.blue.cgColor
        
        updateRate()
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateRate), userInfo: nil, repeats: true)
    }
    
    func createGraph(history: [Int]) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = NSBezierPath()

        if history.count > 0 {
            let min = history.min()
            let max = history.max()
            let ratio = Double(28) / Double(max! - min!)
            
            path.move(to: NSMakePoint(2, CGFloat(Double(history.first! - min!) * ratio)))
            var i = 1
            for entry in history {
                path.line(to: NSMakePoint(CGFloat(2 + i * 2), CGFloat(Double(entry - min!) * ratio)))
                i = i + 1
            }
            
            layer.path = path.cgPath
            layer.lineWidth = 2
            layer.strokeColor = currentColor.cgColor
        }
        return layer
    }

    @objc func updateRate() -> Void {
        KantorApi.fetchRates() { rate in
            self.updateColor(exchangeRate: rate)
            self.update(exchangeRate: rate)
            
            DispatchQueue.main.async {
                let layer = self.createGraph(history: rate.history)
                let label = CATextLayer()
                label.string = "buy: " + rate.buyRate.description + "\nsell: " + rate.sellRate.description
                label.foregroundColor = NSColor.yellow.cgColor
                label.backgroundColor = NSColor.clear.cgColor
                label.fontSize = 10
                label.contentsScale = 2
                label.font = NSFont.systemFont(ofSize: 10, weight: NSFont.Weight.semibold)
                label.frame = NSRect.init(x: 210, y: 4, width: 100, height: 22)
                
                self.rateView.layer?.sublayers?.removeAll()
                self.rateView.layer?.addSublayer(layer)
                self.rateView.layer?.addSublayer(label)
            }
        }
    }
    
    @objc func showRate() -> Void {
        print("RATE")

        let rate = NSCustomTouchBarItem.init(identifier: WindowController.rateIdentifier)
        rate.view = rateButton

        NSTouchBar.presentSystemModalFunctionBar(touchBar, systemTrayItemIdentifier: rate.identifier.rawValue)
    }
    
    func createControl() -> Void {
        DFRSystemModalShowsCloseBoxWhenFrontMost(true)
        
        let dolar = NSCustomTouchBarItem.init(identifier: WindowController.dolarIdentifier)
        controlButton = NSButton.init(title: "$", target: self, action: #selector(showRate))

        controlButton.bezelColor = NSColor.systemBlue
        dolar.view = controlButton
        
        NSTouchBarItem.addSystemTrayItem(dolar)
        
        DFRElementSetControlStripPresenceForIdentifier(dolar.identifier.rawValue, true);
    }
    
    func updateColor(exchangeRate: CurrencyExchangeRate) -> Void {
        DispatchQueue.main.async {
            if self.curentExchangeRate.buyRate > exchangeRate.buyRate {
                self.currentColor = NSColor.systemRed
            } else if self.curentExchangeRate.buyRate < exchangeRate.buyRate {
                self.currentColor = NSColor.systemGreen
            }
            self.rateButton.bezelColor = self.currentColor
            self.controlButton.bezelColor = self.currentColor
            self.curentExchangeRate = exchangeRate;
        }
    }
    
    func update(exchangeRate: CurrencyExchangeRate) -> Void {
        DispatchQueue.main.async {
            self.rateButton.title = exchangeRate.buyRate.description + " zł"
        }
    }
    
    @IBAction func moreClick(_ sender: Any) {
        if moreButton.title == "More ..." {
            moreButton.title = "Close"
            graphView.view?.isHidden = false
        } else {
            moreButton.title = "More ..."
            graphView.view?.isHidden = true
        }
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        rateButton.bezelColor = NSColor.systemOrange
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(WindowController.updateRate), userInfo: nil, repeats: false)
    }
}

extension NSBezierPath {
    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveToBezierPathElement:
                path.move(to: points[0])
            case .lineToBezierPathElement:
                path.addLine(to: points[0])
            case .curveToBezierPathElement:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePathBezierPathElement:
                path.closeSubpath()
            }
        }
        return path
    }
}
