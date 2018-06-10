//
//  RequestProtocol.swift
//  SendToKodiAction
//
//  Created by Tobias Tangemann on 10.06.18.
//  Copyright © 2018 Tobias Tangemann. All rights reserved.
//

import Foundation

protocol URLHandler {
    static func isResponsibleForUrl(_ url : URL) -> Bool
    
    func send(onError: @escaping () -> Void, onSucess: @escaping () -> Void)
}
