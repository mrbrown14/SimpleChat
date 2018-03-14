//
//  MessageCellNode.swift
//  SimpleChat
//
//  Created by Jeremy Zhou on 3/11/18.
//  Copyright © 2018 Jeremy Zhou. All rights reserved.
//

import Foundation
import AsyncDisplayKit

public enum MessageCaption {
    case none
    case error(String?, UIImage?)
}


protocol MessageCellActionDelegate : class {
    func didTapUserAvatar(partyId: String)
    func didTapMessageStatusCaption(message: Message, status: MessageCaption)
}


class MessageCellNode : ASCellNode {
    
    fileprivate let bubbleNode: ASDisplayNode
    fileprivate let message : Message?
    fileprivate let isOutgoing: Bool
    fileprivate let avatarImageNode = ASNetworkImageNode()
    fileprivate var title : ASTextNode?
    fileprivate var sectionTitle : ASTextNode?
    
    var centered : Bool = false
    
    let styleProvider = MessageBubbleStyleProvider()
    
    init(message : Message?, isOutGoing : Bool, forceCentered : Bool = false) {
        self.message = message
        self.isOutgoing = isOutGoing
        self.centered = forceCentered
        
        let bubbleImg = styleProvider.bubbleImage(isOutgoing, hasTail: true)
        
        //text
        let text = message?.text ?? ""
        let textAttributes = MessageTextStyle.regular(isOutGoing ? UIColor.white : UIColor.black).style()
        let attributedText = NSAttributedString(string: text, attributes: textAttributes)
        
        bubbleNode = MessageTextBubbleNode(text: attributedText, isOutgoing: isOutgoing, bubbleImage: bubbleImg)
        
        //avatar
        if let avatarUrlString = message?.userImgURLString {
            avatarImageNode.url = URL(string: avatarUrlString)
        } else {
            //TODO:initials
            avatarImageNode.image = UIImage.as_imageNamed("dan")
            
        }
        
        if (isOutgoing) {
            avatarImageNode.style.preferredSize = CGSize.zero
        } else {
            let avatarDim = kMessageCellNodeAvatarImageSize
            avatarImageNode.style.preferredSize = CGSize(width: avatarDim, height: avatarDim)
            avatarImageNode.cornerRadius = avatarDim / 2.0
            avatarImageNode.clipsToBounds = true
        }
        
        if let title = message?.title {
            self.title = ASTextNode()
            self.title?.attributedText = NSAttributedString(string: title, attributes: MessageTextStyle.title.style())
        }
        
        if let sectionTitle = message?.sectionTitle {
            self.sectionTitle = ASTextNode()
            self.sectionTitle?.attributedText = NSAttributedString(string: sectionTitle, attributes: MessageTextStyle.title.style())
            self.sectionTitle?.style.alignSelf = .center
            self.sectionTitle?.textContainerInset = UIEdgeInsetsMake(10, 0, 10, 0)
            
        }
        
        bubbleNode.style.flexShrink = 1.0
        
        super.init()
        
        self.addSubnode(bubbleNode)
        self.addSubnode(avatarImageNode)
        
        if let titleNode = self.title {
            self.addSubnode(titleNode)
        }
        
        if let sectionTitleNode = self.sectionTitle {
            self.addSubnode(sectionTitleNode)
        }
        
        selectionStyle = .none
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        var titleSpec : ASLayoutSpec? = nil
        if let title = self.title {
            titleSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 20 + 24, 6, 0), child: title)
        }
        
        let horizontalSpec = ASStackLayoutSpec.horizontal()
        horizontalSpec.style.width = ASDimensionMakeWithPoints(constrainedSize.max.width)
        horizontalSpec.spacing = 2
        horizontalSpec.justifyContent = .start
        horizontalSpec.verticalAlignment = .bottom
        
        horizontalSpec.style.alignSelf = .end
        
        if isOutgoing {
            horizontalSpec.horizontalAlignment = .right
            horizontalSpec.children = [bubbleNode]
            
        } else {
            horizontalSpec.horizontalAlignment = .left
            horizontalSpec.children = [avatarImageNode, bubbleNode]
        }
        
        horizontalSpec.style.flexShrink = 1.0
        horizontalSpec.style.flexGrow = 1.0
        
        let verticalSpec = ASStackLayoutSpec()
        verticalSpec.direction = .vertical
        verticalSpec.spacing = 0
        verticalSpec.justifyContent = .start
        verticalSpec.alignItems = isOutgoing == true ? .end : .start
        
        if let titleSpec = titleSpec {
            verticalSpec.setChild(titleSpec, at: 0)
            verticalSpec.setChild(horizontalSpec, at: 1)
        } else {
            verticalSpec.setChild(horizontalSpec, at: 0)
        }
        
        
        
        let inset : UIEdgeInsets
        if centered {
            inset = UIEdgeInsetsMake(1, 48, 5, 66)
        } else if isOutgoing {
            inset = UIEdgeInsetsMake(1, 32, 6, 4)
        } else {
            inset = UIEdgeInsetsMake(1, 4, 6, 32)
        }
        
        let insetSpec = ASInsetLayoutSpec(insets: inset, child: verticalSpec)
        
        if let sectionTitle = self.sectionTitle {
            let outerVStack = ASStackLayoutSpec.vertical()
            outerVStack.spacing = 0
            outerVStack.justifyContent = .start
            outerVStack.alignItems = .start
            outerVStack.children = [sectionTitle, insetSpec]
            
            return outerVStack
        } else {
            return insetSpec
        }
    }
}
