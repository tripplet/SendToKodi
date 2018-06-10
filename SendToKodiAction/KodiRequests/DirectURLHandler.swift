//
//  YoutubeRequest.swift
//  SendToKodiAction
//
//  Created by Tobias Tangemann on 10.06.18.
//  Copyright © 2018 Tobias Tangemann. All rights reserved.
//

import Foundation

internal class DirectURLHandler : BaseURLHandler, URLHandler {    
    static func isResponsibleForUrl(_ url: URL) -> Bool {
        return true;
    }
    
    required init(fromURL url: URL) {
        super.init(fromURL: url)
    }
    
    func send(onError: @escaping () -> Void, onSucess: @escaping () -> Void) {
        let data = ("{\"jsonrpc\": \"2.0\", \"method\": \"Player.open\", \"params\": " +
            "{\"item\": {\"file\": \"\(self.Url.description)\"}}, \"id\": 1}")
            .data(using: String.Encoding.utf8)
        
        self.send(withRequestData: data!, onError: onError, onSucess: onSucess)
    }
}
