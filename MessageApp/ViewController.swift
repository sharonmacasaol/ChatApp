//
//  ViewController.swift
//  MessageApp
//
//  Created by Sharon  Macasaol on 04/05/2020.
//  Copyright © 2020 Sharon  Macasaol. All rights reserved.
//

import UIKit


enum homeAction: Int {
    case signup = 0
    case login = 1
}


class ViewController: UIViewController {

    @IBOutlet weak var signUpBtn: UIView!
    @IBOutlet weak var loginBtn: UIView!
    
    
    @IBAction func signUp(_ sender: UIButton) {
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "signup", sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.signUpBtn.layer.cornerRadius = 8
        self.loginBtn.layer.cornerRadius = 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let signUpViewController = segue.destination as! SignUpViewController
        signUpViewController.modalPresentationStyle = .fullScreen
        signUpViewController.actionType = (sender as? UIButton)?.tag ?? 0
    }


}

