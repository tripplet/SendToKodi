//
//  ShareViewController.swift
//  SendToKodiAction
//
//  Created by Tobias Tangemann on 15.01.16.
//  Copyright © 2016 Tobias Tangemann. All rights reserved.
//

import Cocoa

class ShareViewController: NSViewController
{
    @IBOutlet weak var progress: NSProgressIndicator!

    override var nibName: String?
        {
        return "ShareViewController"
    }

    override func loadView()
    {
        super.loadView()
        
        progress.startAnimation(nil)
        
        let item = self.extensionContext!.inputItems[0] as! NSExtensionItem
        if let attachments = item.attachments {
            (attachments.first as! NSItemProvider).loadItemForTypeIdentifier(kUTTypeURL as String, options: nil, completionHandler: { (item, error) -> Void in
                self.sendRequestToKodi(item as! NSURL)
            })
        }
        else {
            let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
            self.extensionContext!.cancelRequestWithError(cancelError)
        }
    }
    
    func generateRequestDataFromUrl(url: NSURL) -> NSData!
    {
        let requestJsonYoutube = "{\"jsonrpc\": \"2.0\", \"method\": \"Player.Open\", \"params\":{\"item\": {\"file\" : \"plugin://plugin.video.youtube/?action=play_video&videoid=%%VID%%\" }}, \"id\" : \"1\"}"
        
        let requestJsonGeneric = "{\"jsonrpc\": \"2.0\", \"method\": \"Player.open\", \"params\": {\"item\": {\"file\": \"%%URL%%\"}}, \"id\": 1}"
        
        var vid : String? = ""
        
        if url.description.containsString("youtube.com/watch") {
            let queryItems = NSURLComponents(string: url.description)?.queryItems
            vid = queryItems?.filter({$0.name == "v"}).first?.value
        }
        else if url.description.containsString("youtu.be/") {
            vid = url.path?.substringFromIndex(url.path!.startIndex.advancedBy(1))
        }
        
        if let vid = vid {
            return requestJsonYoutube.stringByReplacingOccurrencesOfString("%%VID%%", withString: vid)
                                      .dataUsingEncoding(NSUTF8StringEncoding)
        }
        else {
            return requestJsonGeneric.stringByReplacingOccurrencesOfString("%%URL%%", withString: url.description)
                                     .dataUsingEncoding(NSUTF8StringEncoding)
        }
    }
    
    func sendRequestToKodi(url: NSURL)
    {
        let session = NSURLSession.sharedSession()
        let hostname = NSUserDefaults(suiteName: "group.com.tangemann.sendtokodi")!.stringForKey("kodi_hostname")!
        
        let requestData = self.generateRequestDataFromUrl(url)!
        
        let request = NSMutableURLRequest(URL: NSURL(string: String(format: "http://%@:80/jsonrpc", hostname))!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(format: "%d", requestData.length), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = requestData
        
        let task = session.dataTaskWithRequest(request){
            data, response, error in
            
            NSLog(String(data: data!, encoding: NSUTF8StringEncoding)!)
            
            if error == nil {
                self.extensionContext!.completeRequestReturningItems(nil, completionHandler: nil)
            } else {
                self.extensionContext!.cancelRequestWithError(NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil))
            }
        }
        task.resume()
    }
}