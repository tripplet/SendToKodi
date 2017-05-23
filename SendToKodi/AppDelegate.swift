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
    
    let mirroredDefaults = UserDefaults(suiteName: USER_DEFAULTS_SUITE)!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApplication.shared().servicesProvider = self
        
        // Save all user default into app group user defaults, so they can be accessed from the extension
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.handleUserDefaultsChanged(_:)),
                                                                   name: UserDefaults.didChangeNotification,
                                                                 object: UserDefaults.standard)
    }

    func handleUserDefaultsChanged(_ aNotification: Notification) {
        mirroredDefaults.setValue(UserDefaults.standard.string(forKey: "kodi_hostname")!, forKey: "kodi_hostname")
        mirroredDefaults.synchronize()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
