//
//  MessageController.swift
//  SimpleChat
//
//  Created by Jeremy Zhou on 3/11/18.
//  Copyright © 2018 Jeremy Zhou. All rights reserved.
//

import Foundation

enum MessageTransportError : Error {
    case errorParsingResponse
    case any(Any?)
}

protocol MessageTransportDelegate {
    func sendMessage(message: Message)
}

class MessageController {

    let batchSize : Int = 20
    var pageIndex : Int = 0
    var totalPages : Int = 0
    
    func fetchMessages(page: Int = 0, _ resultHandler: @escaping (([Message], MessageTransportError?) -> Void)) {
        let req = NSMutableURLRequest(url: URL(string:"https://icanhazdadjoke.com/")!)
        req.addValue("text/plain", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: req as URLRequest) { (data, resp, error) in
            if let error = error {
                
            } else if let data = data {
                if let text = String(data: data, encoding: String.Encoding.utf8) {
                    let message = Message(text: text)

                    resultHandler([message], nil)
                } else {
                    resultHandler([], .errorParsingResponse)
                }
            }
        }.resume()

    }
    
    func sendMessage(message: Message, _ resultHandler : @escaping ((Message, MessageTransportError?) -> Void)) {
        let uuid = UUID().uuidString
        message.localStatus = .sending(uuid)
        
        //perform send message
        message.localStatus = .sent(uuid)
        resultHandler(message, nil)
        
    }
    
    func hasMoreMessages() -> Bool {
        return self.pageIndex + 1 < self.totalPages
    }
    
    func resetPageIndex() {
        self.pageIndex = 0
    }
    
}
