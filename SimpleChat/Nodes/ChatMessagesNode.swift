//
//  ChatMessagesNode.swift
//  SimpleChat
//
//  Created by Jeremy Zhou on 3/11/18.
//  Copyright © 2018 Jeremy Zhou. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ChatMessagesNode : ASDisplayNode {

    let inputNode = MessageInputNode()
    let tableNode = ASTableNode()
    let spacer = ASDisplayNode()
    var keyboardAnimationDuration : TimeInterval = 0
    var keyboardHeight : CGFloat = 0.0

    var previousTextInputNodeHeight : CGFloat = CGFloat.nan
    var currentTextInputNodeHeight : CGFloat = 46.0
    let minTextInputNodeHeight : CGFloat = 46.0

    var delegate : MessageTransportDelegate?
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.tableNode.inverted = true
        self.tableNode.contentInset = UIEdgeInsets.zero        

        self.inputNode.textInputNode.delegate = self
        self.inputNode.attachNode.addTarget(self, action: #selector(handleAttachAction(sender:)), forControlEvents: .touchUpInside)
        self.inputNode.sendNode.addTarget(self, action: #selector(handleSendAction(sender:)), forControlEvents: .touchUpInside)
        
        self.spacer.style.height = ASDimensionMake(0)
    }
        
    override func didLoad() {
        super.didLoad()
        self.tableNode.view.separatorStyle = .none
    }
    
    override func layoutDidFinish() {
        super.layoutDidFinish()
        
        if self.previousTextInputNodeHeight == CGFloat.nan {
            self.previousTextInputNodeHeight = self.inputNode.textInputNode.frame.height
        }
        
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = constrainedSize.min.width
        
        let inputInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(2, 6, 2, 12), child: self.inputNode)

        let inputHeight = max(minTextInputNodeHeight, currentTextInputNodeHeight)
        self.inputNode.style.height = ASDimensionMake(inputHeight)
        self.inputNode.style.width = ASDimensionMake(width)
        self.inputNode.style.maxHeight = ASDimensionMake("80%")
        
        self.tableNode.style.flexShrink = 1.0
        self.tableNode.style.flexGrow = 1.0
        self.tableNode.style.width = ASDimensionMake(width)
        self.tableNode.style.spacingBefore = 20.0
        
        let vstack = ASStackLayoutSpec.vertical()
        spacer.style.height = ASDimensionMake(self.keyboardHeight)
        
        vstack.children = [self.tableNode, inputInsetSpec, spacer]
        return vstack
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        let finalSpacerFrame = context.finalFrame(for: self.spacer)
        
        var size = finalSpacerFrame.size

        size.height = keyboardHeight > 0 ? 0 : keyboardHeight

        DispatchQueue.main.async {
            
            self.spacer.frame.size = size
            UIView.animate(withDuration: self.keyboardAnimationDuration, animations: {
                self.spacer.frame = finalSpacerFrame
            }) { (finish) in
                context.completeTransition(finish)
            }
        }
    }
}

extension ChatMessagesNode : ASEditableTextNodeDelegate {
    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode) {
        
        //should we relayout?
        let width = editableTextNode.frame.width
        let newHeight = editableTextNode.calculateSizeThatFits(CGSize(width: width, height: CGFloat.infinity)).height
        if newHeight != self.previousTextInputNodeHeight {
            self.previousTextInputNodeHeight = self.currentTextInputNodeHeight
            self.currentTextInputNodeHeight = newHeight
            
            self.inputNode.setNeedsLayout()
        }
    }
    
    @objc func handleAttachAction(sender : Any?) {
        
    }
    
    @objc func handleSendAction(sender : Any?) {
        guard let attrString = self.inputNode.textInputNode.attributedText else { return }
        
        let message = Message(text: attrString.string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        self.delegate?.sendMessage(message: message)

        self.inputNode.textInputNode.attributedText = nil
        self.editableTextNodeDidUpdateText(self.inputNode.textInputNode)

    }
}
