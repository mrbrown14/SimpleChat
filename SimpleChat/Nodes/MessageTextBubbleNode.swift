//
//  MessageTextBubbleNode.swift
//  SimpleChat
//
//  Created by Jeremy Zhou on 3/11/18.
//  Copyright © 2018 Jeremy Zhou. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class MessageTextBubbleNode : ASDisplayNode {
    
    let isOutgoing: Bool
    let bubbleImageNode: ASImageNode
    let textNode: ASTextNode
    
    init(text: NSAttributedString, isOutgoing: Bool, bubbleImage: UIImage) {
        self.isOutgoing = isOutgoing
        
        bubbleImageNode = ASImageNode()
        bubbleImageNode.image = bubbleImage

        textNode = MessageTextNode()
        
        let attr = NSMutableAttributedString(attributedString: text)

        textNode.attributedText = attr
        
        super.init()
        
        addSubnode(bubbleImageNode)
        addSubnode(textNode)
        
    }

    override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let textNodeVerticalOffset = CGFloat(6)
        
        return ASBackgroundLayoutSpec(
            child: ASInsetLayoutSpec(
                insets: UIEdgeInsetsMake(
                    8,
                    12 + (isOutgoing ? 0 : textNodeVerticalOffset),
                    8,
                    12 + (isOutgoing ? textNodeVerticalOffset : 0)),
                child: textNode),
            background: bubbleImageNode)
    }
}










