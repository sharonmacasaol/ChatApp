//
//  SignUPViewController+Firebase.swift
//  MessageApp
//
//  Created by Sharon Mac on 06/05/2020.
//  Copyright © 2020 Sharon  Macasaol. All rights reserved.
//

import UIKit
import Firebase

extension SignUpViewController {
    
    
    func setAction() {
        
        guard
            let nameField = self.usernameText,
            let passwordField = self.passwordText else {
            return
        }
        
        if actionType == homeAction.login.rawValue {
            
            db.collection("users").whereField("username", isEqualTo: nameField.text ?? " ").whereField("password", isEqualTo: passwordField.text ?? " ").limit(to: 1)
                .addSnapshotListener(includeMetadataChanges: true) { queryUser, error in
                    guard let userArr = queryUser else {
                        print("Error retreiving snapshot: \(error!)")
                        return
                    }
                    
                    //execute if invalid username or password
                    if userArr.documentChanges.count == 0 {
                        self.usernameWarningLabel.isHidden = false
                        self.passwordWarningLabel.isHidden = false
                        self.passwordWarningHeightConstraint.constant = 40
                        self.usernameWarningConstraint.constant = 40
                        self.loader.stopAnimating()
                        return
                    }
                    
                    for diff in userArr.documentChanges {
                        if diff.type == .added {
                            let userInfo = diff.document.data()
                            UserMessage.shared.loggedInUser = User(id: userInfo["id"] as? String ?? "", username: userInfo["username"] as? String ?? "")
                            self.loader.stopAnimating()
                            self.presentChatView()
                        }
                    }
                    
                    let source = userArr.metadata.isFromCache ? "local cache" : "server"
                    print("Metadata: Data fetched from \(source)")
            }
            
        } else {
            var ref: DocumentReference? = nil
            let generateUserRandId = self.randomString(length: 10)
            ref = db.collection("users").addDocument(data: [
                "username": nameField.text ?? "",
                "password": passwordField.text ?? "",
                "id": generateUserRandId
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        UserMessage.shared.loggedInUser = User(id: generateUserRandId, username: nameField.text ?? "")
                        self.loader.stopAnimating()
                        self.presentChatView()
                    }
            }
        }
    }
    
    
}
