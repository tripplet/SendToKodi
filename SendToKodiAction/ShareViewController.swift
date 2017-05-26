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

    override var nibName: String? { return "ShareViewController" }

    override func loadView() {
        super.loadView()
        
        progress.startAnimation(nil)
        
        let item = self.extensionContext!.inputItems[0] as! NSExtensionItem
        
        if let attachments = item.attachments {
            (attachments.first as! NSItemProvider).loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { (item, error) -> Void in
                self.sendRequestToKodi(item as! URL)
            })
        }
        else {
            let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
            self.extensionContext!.cancelRequest(withError: cancelError)
        }
    }
    
    @IBAction func Settings(_ sender: NSButton) {
        
    }
    
    @IBAction func cancel(_ sender: NSButton) {
        progress.stopAnimation(nil)
        
        self.extensionContext!.cancelRequest(withError: NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil))
    }
    
    func generateRequestDataFromUrl(_ url: URL) -> Data! {
        var vid : String?
        
        // If url is link to youtube video, extract video-id
        if url.description.contains("youtube.com/watch") {
            let queryItems = URLComponents(string: url.description)?.queryItems
            vid = queryItems?.filter({$0.name == "v"}).first?.value
        }
        else if url.description.contains("youtu.be/") {
            vid = url.path.substring(from: url.path.characters.index(url.path.startIndex, offsetBy: 1))
        }
        
        if let vid = vid {
            return ("{\"jsonrpc\": \"2.0\", \"method\": \"Player.Open\", \"params\": " +
                    "{\"item\": {\"file\" : \"plugin://plugin.video.youtube/?action=play_video&videoid=\(vid)\" }}, \"id\" : \"1\"}")
                   .data(using: String.Encoding.utf8)
        }
        else {
            return ("{\"jsonrpc\": \"2.0\", \"method\": \"Player.open\", \"params\": " +
                    "{\"item\": {\"file\": \"\(url.description)\"}}, \"id\": 1}")
                    .data(using: String.Encoding.utf8)
        }
    }
    
    func sendRequestToKodi(_ url: URL) {
        let session = URLSession.shared
        let hostname = UserDefaults(suiteName: USER_DEFAULTS_SUITE)!.string(forKey: "kodi_hostname")!
        
        let requestData = self.generateRequestDataFromUrl(url)
        
        let request = NSMutableURLRequest(url: URL(string: "http://\(hostname):80/jsonrpc")!)
        request.httpMethod = "POST"
        request.setValue("application/json",         forHTTPHeaderField: "Accept")
        request.setValue("application/json",         forHTTPHeaderField: "Content-Type")
        request.setValue(String(describing: requestData?.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = requestData
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            
            if error == nil {
                self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
            }
            else {
                self.extensionContext!.cancelRequest(withError: NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil))
            }
        }) 
        task.resume()
    }
}
