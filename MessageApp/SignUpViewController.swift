//
//  SignUpViewController.swift
//  MessageApp
//
//  Created by Sharon  Macasaol on 04/05/2020.
//  Copyright © 2020 Sharon  Macasaol. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    var actionType: Int?
    var db: Firestore!
    var isError: Bool?
    //store opposite view int value
    var oppositeActionType : Int?
    
    let yourAttributes : [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.foregroundColor : UIColor(red: 0.2588, green: 0.2588, blue: 0.2588, alpha: 1.0),
        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
    
    @IBOutlet weak var headerView: HeaderView!
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    
    //warning views height constraint
    @IBOutlet weak var usernameWarningConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordWarningHeightConstraint: NSLayoutConstraint!
    
    //warning labels
    @IBOutlet weak var usernameWarningLabel: UILabel!
    @IBOutlet weak var passwordWarningLabel: UILabel!
    //loader
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    //redirect to view button
    @IBOutlet weak var redirectBtn: UIButton!
    
    @IBAction func submit(_ sender: UIButton) {
        loader.startAnimating()
        //initialize error value
        isError = false
        
        guard
            let nameField = self.usernameText,
            let passwordField = self.passwordText else {
            return
        }
        
        let charCount = nameField.text?.trim().count
        let passCount = passwordField.text?.trim().count
        
        //throw error if character count exceeds or lacks
        if charCount == 0 || !(8 ... 16 ~= charCount!)  {
            isError = true
            usernameWarningLabel.isHidden = false
            usernameWarningConstraint.constant = 40
        } else {
            usernameWarningLabel.isHidden = true
            usernameWarningConstraint.constant = 20
        }
        
        if passCount == 0 || !(8 ... 16 ~= passCount!) {
            isError = true
            passwordWarningLabel.isHidden = false
            passwordWarningHeightConstraint.constant = 40
        } else {
            passwordWarningLabel.isHidden = true
            passwordWarningHeightConstraint.constant = 20
            
        }
        
        if isError! {
            self.loader.stopAnimating()
            return
        }
        
        self.setAction()
        
        
    }
    
    @IBAction func redirect(_ sender: UIButton) {
      
        actionType = self.oppositeActionType
        //empty fields
        self.resetFieldViews()
        self.modifyView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //firebase config
        let settings = FirestoreSettings()
        settings.areTimestampsInSnapshotsEnabled = true
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        db.settings = settings
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.usernameText.setPlaceHolderColor(placeholderText: "User name")
        self.passwordText.setPlaceHolderColor(placeholderText: "Password")
        self.headerView.logoutView.isHidden = true
        //
        self.modifyView()
    }
    
    func presentChatView() {
        self.actionType = 1
        self.modifyView()
        self.resetFieldViews()
        
        DispatchQueue.main.async {
            let sb = UIStoryboard.init(name: "Chat", bundle: nil)
            let modal = sb.instantiateViewController(withIdentifier: "chatStoryboard") as! ChatViewController
            modal.modalPresentationStyle = .fullScreen
            self.present(modal, animated: true, completion: nil)
        }
        
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func modifyView() {
        let redButton =  actionType == homeAction.login.rawValue ? "Sign up" : "Login"
        if actionType == homeAction.login.rawValue {
            self.oppositeActionType = 0
           // title = "Sign up"
            signupBtn.isSelected = false
        } else {
            self.oppositeActionType = 1
           // title = "Login"
            signupBtn.isSelected = true
        }
        
        let attributeString = NSMutableAttributedString(string: redButton,
                                                        attributes: yourAttributes)
        redirectBtn.setAttributedTitle(attributeString, for: .normal)
    }
    
    func resetFieldViews() {
        usernameWarningLabel.isHidden = true
        usernameWarningConstraint.constant = 20
        passwordWarningLabel.isHidden = true
        passwordWarningHeightConstraint.constant = 20
        
        usernameText.text = ""
        passwordText.text = ""
    }
    
}
