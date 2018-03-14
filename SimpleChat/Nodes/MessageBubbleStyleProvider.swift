//
//  MessageBubbleImageProvider.swift
//  SimpleChat
//
//  Created by Jeremy Zhou on 3/11/18.
//  Copyright © 2018 Jeremy Zhou. All rights reserved.
//

import Foundation
import AsyncDisplayKit

struct MessageProperties: Hashable {
    let isOutgoing: Bool
    let hasTail: Bool
    let color: UIColor
    
    var hashValue: Int {
        return (20 &* isOutgoing.hashValue) &+ hasTail.hashValue &+ (17 &* color.hashValue)
    }
}

extension MessageProperties : Equatable {
    static func ==(lhs: MessageProperties, rhs: MessageProperties) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

let kDefaultIncomingColor = UIColor(red: 239 / 255, green: 237 / 255, blue: 237 / 255, alpha: 1)
let kDefaultOutgoingColor = UIColor(red: 17 / 255, green: 107 / 255, blue: 254 / 255, alpha: 1)
let kMessageCellNodeAvatarImageSize : CGFloat = 30.0

enum MessageTextStyle {
    case regular(UIColor), title, sectionTitle
    
    func style() -> [NSAttributedStringKey:Any] {
        switch self {
        case .regular(let color):
            
            let pstyle = NSMutableParagraphStyle()
            pstyle.minimumLineHeight = 20.0
            pstyle.maximumLineHeight = 20.0

            let attr : [NSAttributedStringKey: Any]  = [
                .foregroundColor: color,
                .font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body),
                .kern: -0.4,
                .paragraphStyle: pstyle
            ]
            
            return attr
            
        case .title, .sectionTitle:
            let attr : [NSAttributedStringKey: Any]  = [
                .foregroundColor: UIColor.coolGrey(),
                .font: UIFont.systemFont(ofSize: 12)
            ]
            
            return attr
            
        }
    }
}


class MessageBubbleStyleProvider {
    
    fileprivate let outgoingColor: UIColor
    fileprivate let incomingColor: UIColor
    fileprivate var imageCache = [MessageProperties: UIImage]()
    
    init(incomingColor: UIColor = kDefaultIncomingColor, outgoingColor: UIColor = kDefaultOutgoingColor) {
        self.incomingColor = incomingColor
        self.outgoingColor = outgoingColor
    }
    
    func bubbleImage(_ isOutgoing: Bool, hasTail: Bool, color: UIColor? = nil) -> UIImage {
        
        var chosenColor =  isOutgoing ? outgoingColor : incomingColor
        
        if let color = color {
            chosenColor = color
        }
        
        let properties = MessageProperties(isOutgoing: isOutgoing, hasTail: hasTail, color: chosenColor)
        return bubbleImage(properties)
    }
    
    fileprivate func bubbleImage(_ properties: MessageProperties) -> UIImage {
        if let image = imageCache[properties] {
            return image
        }
        
        let image = buildBubbleImage(properties)
        imageCache[properties] = image
        return image
    }
    
    fileprivate func buildBubbleImage(_ properties: MessageProperties) -> UIImage {
        let imageName = "bubble" + (properties.isOutgoing ? "_outgoing" : "_incoming")

        guard let bubble = UIImage(named : imageName) else {
            return UIImage()
        }
        
        var normalBubble = bubble.imageMaskedWith(properties.color)
        
        // make image stretchable from center point
        let center = CGPoint(x: bubble.size.width / 2.0, y: bubble.size.height / 2.0)
        let capInsets = UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
        
        normalBubble = MessageBubbleStyleProvider.stretchableImage(normalBubble, capInsets: capInsets)
        return normalBubble
    }
    
    fileprivate class func stretchableImage(_ source: UIImage, capInsets: UIEdgeInsets) -> UIImage {
        return source.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }
    
}


