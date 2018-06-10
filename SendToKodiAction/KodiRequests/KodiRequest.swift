//
//  Request.swift
//  SendToKodiAction
//
//  Created by Tobias Tangemann on 08.06.18.
//  Copyright © 2018 Tobias Tangemann. All rights reserved.
//

import Foundation

public class KodiRequest {
    private var url: URL!
    private var handler: URLHandler?
    
    /// Known url handlers
    private let urlHandler: [(BaseURLHandler & URLHandler).Type] = [
        YoutubeURLHandler.self,
        DirectURLHandler.self]

    init(_ url: URL) {
        self.url = url
        initHandler()
    }
    
    private func initHandler() {
        for handler in self.urlHandler {
            if (handler.isResponsibleForUrl(url))
            {
                self.handler = handler.init(fromURL: url)
                return
            }
        }
    }
    
    func send(onError: @escaping () -> Void, onSucess: @escaping () -> Void) {
        if let h = self.handler {
            h.send(onError: onError, onSucess: onSucess)
        }
        else {
            onError()
        }
    }
}
