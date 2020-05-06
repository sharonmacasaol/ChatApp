//
//  ChatAppTableViewCell.swift
//  MessageApp
//
//  Created by Sharon  Macasaol on 05/05/2020.
//  Copyright © 2020 Sharon  Macasaol. All rights reserved.
//

import UIKit

class ChatAppTableViewCell: UITableViewCell {
    
   
    
    var msg: Message? {
        didSet {
            setData()
        }
    }
    
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var chatTailView: ChatMessageTailView!
    @IBOutlet weak var chatTrailingTail: ChatMessageTailView!
    @IBOutlet weak var username: UILabel!
    
    //chat cell constraints
    @IBOutlet var chatTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var chatLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var usernameTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var usernameLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatBubbleWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutIfNeeded() {
        self.chatBubbleWidthConstraint.constant = self.frame.width * 0.8
        // chat bubble tail layout
        chatTailView.rotateTail(angle: 390)
        chatTrailingTail.rotateTail(angle: 210)
    }
    
    func checkMsgType() {
        guard let trailing = chatTrailingConstraint,
            let leading = chatLeadingConstraint,
            let userTrailing = usernameTrailingConstraint,
            let userLeading = usernameLeadingConstraint,
            let type = msg?.msgType
            else {
                return
        }
        
        //modify messageview constraints
        leading.isActive = type == 1
        trailing.constant = 15
        leading.constant = 15
        trailing.isActive = type == 0
        //modify username label constraints
        userLeading.isActive = type == 1
        userTrailing.isActive = type == 0

    }
    
    func setData() {
        messageLbl.text = msg?.userMessage
        username.text = msg?.userName
        
        
        chatTailView.isHidden = msg?.msgType == 0
        chatTrailingTail.isHidden = msg?.msgType != 0
        
        checkMsgType()
        
    }

}

