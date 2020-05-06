//
//  ChatViewController.swift
//  MessageApp
//
//  Created by Sharon  Macasaol on 05/05/2020.
//  Copyright © 2020 Sharon  Macasaol. All rights reserved.
//
import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var messageArr: [Message] = []
    var isDataLoaded: Bool = false
    
    @IBOutlet weak var chatFieldView: UIView!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatFieldBottomConstraint: NSLayoutConstraint!
    
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if !isDataLoaded {
            isDataLoaded = true
        }
        
        self.sendMessageDB()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setHeader()

        self.chatTable.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //remove notification observer
        NotificationCenter.default.removeObserver(self)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatAppTableViewCell
        
        cell.msg = messageArr[indexPath.row]
        return cell
    }
    
    func setHeader() {
        
        getData()
        
        self.headerView.logoutBtn.addTarget(self, action: #selector(logoutApp), for: .touchUpInside)
        self.headerView.logoutView.isHidden = false
        
        //execute if keyboard shows
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        //hidekeyboard on tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    
    
}
