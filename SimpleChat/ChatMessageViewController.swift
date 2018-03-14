//
//  ChatMessageViewController.swift
//  SimpleChat
//
//  Created by Jeremy Zhou on 3/11/18.
//  Copyright © 2018 Jeremy Zhou. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ChatMessageViewController : ASViewController<ASDisplayNode> {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    let chatMessagesNode : ChatMessagesNode

    fileprivate let topRow = IndexPath(row: 0, section: 0)
    var keyboardShowing = false
    var messages : [Message] = []
    var chatTableNode : ASTableNode?
    
    var lastMessageTimeStamp : String?
    var userId : String = "Flying Toaster"
    
    let messageController = MessageController()
    
    init() {

        self.chatMessagesNode = ChatMessagesNode()
        
        super.init(node: self.chatMessagesNode)
        
        self.chatMessagesNode.tableNode.delegate = self
        self.chatMessagesNode.tableNode.dataSource = self
        self.chatMessagesNode.delegate = self
        self.chatTableNode = self.chatMessagesNode.tableNode
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.chatTableNode?.view.contentInsetAdjustmentBehavior = .never
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
     
        self.fetchMessages()
    }
    
    func fetchMessages() {
        self.messageController.fetchMessages { (messages, error) in
            if let error = error {
                
            } else {
                
                self.messages.insert(contentsOf: messages, at: 0)

                DispatchQueue.main.async {
                    let inserts = (0..<messages.count).map({ IndexPath(row: $0, section: 0) })
                    self.chatTableNode?.insertRows(at: inserts, with: .automatic)
                }
                
            }
            
        }
    }
}

extension ChatMessageViewController : MessageTransportDelegate {
    func sendMessage(message: Message) {

        message.fromId = self.userId
        
        self.messageController.sendMessage(message: message) { (sent, error) in
            if let error = error {
                
            } else {
                
            }
        }

        self.messages.insert(message, at: 0)
        self.chatTableNode?.insertRows(at: [topRow], with: .bottom)
        
        //generate a reply
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.fetchMessages()
        }
    }
}


extension ChatMessageViewController : ASTableDelegate {
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return self.messageController.hasMoreMessages()
    }

    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        let screenSize = UIScreen.main.bounds.size
        return ASSizeRangeMake(CGSize(width: screenSize.width, height: 0), CGSize(width: screenSize.width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        self.fetchNewBatchWithContext(context: context)
    }
    
    func fetchNewBatchWithContext(context : ASBatchContext) {
        context.completeBatchFetching(true)
    }
}

extension ChatMessageViewController : ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let msg = self.messages[indexPath.item]
        let isOutGoing = msg.fromId == self.userId
        
        return {
            let node = MessageCellNode(message: msg, isOutGoing: isOutGoing)
            return node
        }
    }
}

extension ChatMessageViewController {
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        self.chatMessagesNode.keyboardHeight = 0.0
        self.chatMessagesNode.keyboardAnimationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        self.chatMessagesNode.spacer.setNeedsLayout()
        self.chatMessagesNode.transitionLayout(withAnimation: true, shouldMeasureAsync: true, measurementCompletion: nil)
        self.keyboardShowing = false
        
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        self.chatMessagesNode.keyboardAnimationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        self.chatMessagesNode.keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        self.chatMessagesNode.spacer.setNeedsLayout()
        self.chatMessagesNode.transitionLayout(withAnimation: true, shouldMeasureAsync: true, measurementCompletion: nil)
        self.keyboardShowing = true
    }
}
