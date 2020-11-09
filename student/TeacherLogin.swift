//
//  TeacherLogin.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/09.
//

import Foundation
import UIKit
import  Firebase
import FirebaseAuth
import SVProgressHUD


class TeacherLogininViewController: UIViewController {
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var passText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func pushSigninButton(_ sender: Any) {
        if let email = emailtext.text,
           let password = passText.text{
            if email.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                emailtext.layer.borderColor = UIColor.red.cgColor
                return
            }
            if password.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                passText.layer.borderColor = UIColor.red.cgColor
                return
            }
            emailtext.layer.borderColor = UIColor.black.cgColor
            passText.layer.borderColor = UIColor.black.cgColor
            
   
            SVProgressHUD.show()

            // ログイン
            Auth.auth().signIn(withEmail: email, password: password) { user, error in
                if let error = error {
                    print(error)
                    SVProgressHUD.showError(withStatus: "Error!")
                    return
                } else {
                    print(email)
                    print(password)
                    SVProgressHUD.showSuccess(withStatus: "Success!")
                    self.performSegue(withIdentifier: "toMakeClass", sender: nil)
                }
            }
        }
    }
    

}
