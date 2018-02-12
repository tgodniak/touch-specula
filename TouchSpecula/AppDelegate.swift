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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        NSApplication.shared.windows.last?.close()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
