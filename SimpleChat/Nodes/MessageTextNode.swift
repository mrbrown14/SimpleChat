//
//  MessageTextNode.swift
//  SimpleChat
//
//  Created by Jeremy Zhou on 3/11/18.
//  Copyright © 2018 Jeremy Zhou. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class MessageTextNode : ASTextNode {
    
    override init() {
        super.init()
        
        placeholderColor = UIColor.clear
    }
    
    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        let size = super.calculateSizeThatFits(constrainedSize)
        return CGSize(width: max(size.width, 15), height: size.height)
    }
    
}

