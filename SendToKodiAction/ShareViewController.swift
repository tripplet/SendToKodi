//
//  ShareViewController.swift
//  SendToKodiAction
//
//  Created by Tobias Tangemann on 15.01.16.
//  Copyright © 2016 Tobias Tangemann. All rights reserved.
//

import Cocoa

class ShareViewController: NSViewController {
    @IBOutlet weak var progress: NSProgressIndicator!
    
    override func loadView() {
        super.loadView()
        
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        
        progress.startAnimation(nil)
        
        let item = self.extensionContext!.inputItems[0] as! NSExtensionItem
        
        if let attachments = item.attachments {
            (attachments.first as! NSItemProvider).loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { (item, error) -> Void in
                
                let req = KodiRequest.init(item as! URL)
                req.send(
                    onError: {
                        self.extensionContext!.cancelRequest(withError: cancelError)
                    }, onSucess: {
                        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
                    })
            })
        }
        else {
            self.extensionContext!.cancelRequest(withError: cancelError)
        }
    }
    
    @IBAction func cancel(_ sender: NSButton) {
        progress.stopAnimation(nil)
        self.extensionContext!.cancelRequest(withError: NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil))
    }
}
