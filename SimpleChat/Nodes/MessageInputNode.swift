//
//  MessageInputNode.swift
//  SimpleChat
//
//  Created by Jeremy Zhou on 3/11/18.
//  Copyright © 2018 Jeremy Zhou. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MessageInputNode : ASDisplayNode {
    let attachNode = ASButtonNode()
    let sendNode = ASButtonNode()
    let textInputNode = ASEditableTextNode()
    let divider = ASDisplayNode()

    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        textInputNode.attributedPlaceholderText = "Type your message".attrString(UIColor.coolGrey(), font: .systemFont(ofSize: 13))
        textInputNode.autocorrectionType = .no
        textInputNode.spellCheckingType = .no
        textInputNode.style.flexGrow = 1.0
        textInputNode.style.flexShrink = 1.0
        textInputNode.style.minHeight = ASDimensionMake(22.0)

        textInputNode.typingAttributes = [NSAttributedStringKey.font.rawValue : UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]

        attachNode.setBackgroundImage(UIImage.as_imageNamed("attachbox"), for: .normal)
        attachNode.style.preferredSize = CGSize(width: 22.0, height: 22.0)
        
        sendNode.setAttributedTitle("Send".attrString(UIColor.azure(), font: .systemFont(ofSize: 13, weight: .bold)), for: .normal)
        sendNode.style.preferredSize = CGSize(width: 34.0, height: 16.0)


        divider.style.height = ASDimensionMake(1.0)
        divider.backgroundColor = UIColor.paleGray()

    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let hspacing : CGFloat = 12.0
        
        let hstack = ASStackLayoutSpec.horizontal()
        hstack.children = [attachNode, textInputNode, sendNode]
        divider.style.width = ASDimensionMake(constrainedSize.max.width)

        hstack.spacing = hspacing
        hstack.verticalAlignment = .bottom
        
        let vstack = ASStackLayoutSpec.vertical()
        vstack.children = [divider, hstack]
        vstack.spacing = 6.0
        vstack.verticalAlignment = .center
        
        return vstack
    }
}
