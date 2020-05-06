//
//  ViewController+Firebase.swift
//  MessageApp
//
//  Created by Sharon Mac on 05/05/2020.
//  Copyright © 2020 Sharon  Macasaol. All rights reserved.
//

import UIKit
import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("messages")
        static let databaseUsers = databaseRoot.child("users")
    }
}

extension ChatViewController {
    
    func sendMessageDB() {
        
        guard let message = self.messageTextField.text,
            let username =  UserMessage.shared.loggedInUser?.username,
            let userId = UserMessage.shared.loggedInUser?.id else {
                return
        }
        //required message fields
        let chat = [
                      "message": message,
                      "username": username,
                      "user_id": userId,
                      "date": ServerValue.timestamp() as! [String : Any]
        ] as [String : Any]

        let ref = Constants.refs.databaseChats.childByAutoId()
        ref.setValue(chat)
        
        self.messageTextField.text = ""
        
    }
    
    
    func getData() {
        
        //get all messages
        let query = Constants.refs.databaseChats.queryOrdered(byChild: "date")
               _ = query.observe( .childAdded, with: { [weak self] snapshot in
                   
                let val = snapshot.value as? [String: Any] ?? [:]
                
                var username = "You"
                var msgType = 0
                if val["user_id"] as? String ?? "" != UserMessage.shared.loggedInUser?.id {
                    msgType = 1
                    username = val["username"] as? String ?? ""
                }
                
                self?.messageArr.append(Message(
                    userId: val["user_id"] as? String ?? "",
                    userName: username,
                    userMessage: val["message"] as? String ?? "",
                    msgType: msgType,
                    msgDate: nil))
                
                
                self?.chatTable.reloadData()
                self?.scrollToBottom()
                   
        })
        
        
    }
    
    
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.chatFieldBottomConstraint.constant = keyboardSize.height + 10
        }
    }
    
    @objc func logoutApp() {
        //dismiss chat view
        dismiss(animated: false, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.chatFieldBottomConstraint.constant = 20
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messageArr.count-1, section: 0)
            self.chatTable.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
}
