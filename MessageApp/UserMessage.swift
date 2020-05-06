//
//  UserMessage.swift
//  MessageApp
//
//  Created by Sharon  Macasaol on 04/05/2020.
//  Copyright © 2020 Sharon  Macasaol. All rights reserved.
//

import Foundation
import UIKit


struct Message{
    var userId: String?
    var userName: String?
    var userMessage: String?
    var msgType: Int?
    var msgDate: Date?
}

struct User{
    var id: String?
    var username: String?
}

class UserMessage {
    static let shared = UserMessage()
    var loggedInUser: User?
    var homeView: SignUpViewController?
}
