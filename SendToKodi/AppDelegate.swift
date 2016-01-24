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
    
    let mirroredDefaults = NSUserDefaults(suiteName: USER_DEFAULTS_SUITE)!

    // Save all user default into app group user defaults, so they can be accessed from the extension
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleUserDefaultsChanged:", name: NSUserDefaultsDidChangeNotification, object: NSUserDefaults.standardUserDefaults())
    }

    func handleUserDefaultsChanged(aNotification: NSNotification) {
        mirroredDefaults.setValue(NSUserDefaults.standardUserDefaults().stringForKey("kodi_hostname")!, forKey: "kodi_hostname")
        mirroredDefaults.synchronize()
    }
}