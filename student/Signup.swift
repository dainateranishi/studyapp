//
//  Signup.swift
//  student
//
//  Created by 寺西帝乃 on 2020/10/30.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class SignupViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameTextField.layer.borderWidth = 2
        emailTextField.layer.borderWidth = 2
        passTextField.layer.borderWidth = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pushSignupButton(_ sender: Any) {
        
        if let username = usernameTextField.text,
           let email = emailTextField.text,
           let password = passTextField.text {
            if username.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                usernameTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
            if email.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                emailTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
            if password.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                passTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
            usernameTextField.layer.borderColor = UIColor.black.cgColor
            emailTextField.layer.borderColor = UIColor.black.cgColor
            passTextField.layer.borderColor = UIColor.black.cgColor

            SVProgressHUD.show()

            // ユーザー作成
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                if let error = error {
                    print(error)
                    SVProgressHUD.showError(withStatus: "Error!")
                    return
                }
                // ユーザーネームを設定
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = username
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print(error)
                            SVProgressHUD.showError(withStatus: "Error!")
                            return
                        }
                        SVProgressHUD.showSuccess(withStatus: "Success!")
                        self.performSegue(withIdentifier: "fromSignup", sender: nil)
                        
                    }
                } else {
                    print("Error - User not found")
                }
                SVProgressHUD.dismiss()
            }
        }
    }
}
