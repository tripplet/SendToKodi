//
//  AppDelegate.swift
//  SendToKodi
//
//  Created by Tobias Tangemann on 15.01.16.
//  Copyright © 2016 Tobias Tangemann. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let mirroredDefaults = NSUserDefaults(suiteName: "group.com.tangemann.sendtokodi")!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleUserDefaultsChanged:", name: NSUserDefaultsDidChangeNotification, object: NSUserDefaults.standardUserDefaults())
    }

    func handleUserDefaultsChanged(aNotification: NSNotification) {
        mirroredDefaults.setValue(NSUserDefaults.standardUserDefaults().stringForKey("kodi_hostname")!, forKey: "kodi_hostname")
        mirroredDefaults.synchronize()
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

