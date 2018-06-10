//
//  YoutubeRequest.swift
//  SendToKodiAction
//
//  Created by Tobias Tangemann on 10.06.18.
//  Copyright © 2018 Tobias Tangemann. All rights reserved.
//

import Foundation

internal class YoutubeURLHandler : BaseURLHandler, URLHandler {
    static func isResponsibleForUrl(_ url: URL) -> Bool {
        return url.description.contains("youtube.com/watch") ||
               url.description.contains("youtu.be/");
    }
    
    required init(fromURL url: URL) {
        super.init(fromURL: url)
    }
    
    func generateRequestData() -> Data? {
        var vid : String?
        
        // If url is link to youtube video, extract video-id
        if self.Url.description.contains("youtube.com/watch") {
            let queryItems = URLComponents(string: self.Url.description)?.queryItems
            vid = queryItems?.filter({$0.name == "v"}).first?.value
        }
        else if self.Url.description.contains("youtu.be/") {
            vid = String(self.Url.path[self.Url.path.index(self.Url.path.startIndex, offsetBy: 1)...])
        }
        
        if let vid = vid {
            return ("{\"jsonrpc\": \"2.0\", \"method\": \"Player.Open\", \"params\": " +
                "{\"item\": {\"file\" : \"plugin://plugin.video.youtube/?action=play_video&videoid=\(vid)\" }}, \"id\" : \"1\"}")
                .data(using: String.Encoding.utf8)
        }
        else {
            return nil
        }
    }
    
    func send(onError: @escaping () -> Void, onSucess: @escaping () -> Void) {
        if let data = generateRequestData() {
            self.send(withRequestData: data, onError: onError, onSucess: onSucess)
        }
        else {
            onError()
        }
    }
}
