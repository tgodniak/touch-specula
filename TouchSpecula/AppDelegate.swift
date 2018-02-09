//
//  AppDelegate.swift
//  TouchSpecula
//
//  Created by GoToo on 07/02/2018.
//  Copyright © 2018 GoToo. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTouchBarDelegate {

    static let dolarIdentifier = NSTouchBarItem.Identifier("GoToo.icon.dolar")
    static let rateIdentifier = NSTouchBarItem.Identifier("rate")
    
    let touchBar = NSTouchBar.init()
    
    @objc func update() -> Void {
//        touchBar.defaultItemIdentifiers = [AppDelegate.dolarIdentifier]
//        touchBar.delegate = self
//
//        let rate = NSCustomTouchBarItem.init(identifier: AppDelegate.rateIdentifier)
//        let view = NSButton.init(title: "0.00", target: self, action: #selector(update))
//        view.bezelColor = NSColor.systemRed
//
//        touchBar.presentAsSystemModal(for: rate)
        //NSTouchBar.presentSystemModalFunctionBar(touchBar, systemTrayItemIdentifier: rate.identifier.rawValue)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        
//        let dolar = NSCustomTouchBarItem.init(identifier: AppDelegate.dolarIdentifier)
//        let view = NSButton.init(title: "$", target: self, action: #selector(update))
//        view.bezelColor = NSColor.systemPink
//        
//        controlStrippify(view, dolar.identifier.rawValue)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
