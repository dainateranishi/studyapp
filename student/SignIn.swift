//
//  SignIn.swift
//  student
//
//  Created by 寺西帝乃 on 2020/10/30.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class SigninViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.layer.borderWidth = 2
        passTextField.layer.borderWidth = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushSigninButton(_ sender: Any) {
        if let email = emailTextField.text,
           let password = passTextField.text {
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
            emailTextField.layer.borderColor = UIColor.black.cgColor
            passTextField.layer.borderColor = UIColor.black.cgColor
            
            SVProgressHUD.show()

            // ログイン
            Auth.auth().signIn(withEmail: email, password: password) { user, error in
                if let error = error {
                    print(error)
                    SVProgressHUD.showError(withStatus: "Error!")
                    return
                } else {
                    SVProgressHUD.showSuccess(withStatus: "Success!")
                    self.performSegue(withIdentifier: "fromLogin", sender: nil)
                    }
                }
            }
        }
    }
