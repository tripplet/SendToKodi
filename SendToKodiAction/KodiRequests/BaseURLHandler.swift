//
//  BaseURLHandler.swift
//  SendToKodiAction
//
//  Created by Tobias Tangemann on 10.06.18.
//  Copyright © 2018 Tobias Tangemann. All rights reserved.
//

import Foundation

class BaseURLHandler {
    public private(set) var Url: URL

    required init(fromURL url: URL) {
        self.Url = url
    }

    func send(withRequestData data: Data, onError: @escaping () -> Void, onSucess: @escaping () -> Void) {
        let session = URLSession.shared
        let hostname = UserDefaults(suiteName: USER_DEFAULTS_SUITE)!.string(forKey: "kodi_hostname")!
        var request = URLRequest(url: URL(string: "http://\(hostname)/jsonrpc")!)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(describing: data.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = data


        let task = session.dataTask(with: request, completionHandler: {
            data, response, error in

            if error == nil {
                onSucess()
            }
            else {
                onError()
            }
        })
        task.resume()
    }
}
