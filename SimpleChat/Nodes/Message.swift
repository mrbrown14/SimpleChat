//
//  Message.swift
//  SimpleChat
//
//  Created by Jeremy Zhou on 3/11/18.
//  Copyright © 2018 Jeremy Zhou. All rights reserved.
//

import UIKit

enum LocalMessageStatus {
    case sending(String), sent(String), failed(String)
}

class Message {
    
    var id: String?
    var fromId: String?
    var text: String?
    var timestamp: String?
    var toId: String?
    var imageUrl: String?
    var title : String?
    var sectionTitle : String?
    var userImgURLString : String?
    var localStatus : LocalMessageStatus?
    
    init(text : String) {
        self.text = text
    }
    
    init(image : String) {
        self.imageUrl = image
    }
}
