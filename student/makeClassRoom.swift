//
//  makeClassRoom.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/09.
//

import Foundation
import UIKit
import  Firebase
import FirebaseAuth
import SVProgressHUD


class MakeClassViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var classNameText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func pushMakeButton(_ sender: Any) {
        if let className = classNameText.text{
            if className.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                classNameText.layer.borderColor = UIColor.red.cgColor
                return
            }
            classNameText.layer.borderColor = UIColor.black.cgColor
        
            SVProgressHUD.show()
            
            let ref = self.db.collection("class").document(className)
            
            ref.setData([
                "member": ["studentName": "LogINTime"]
            ]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    ref.collection("allboard").document("count").setData([
                        "count": 0
                    ]){ err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                            ref.collection("studentboard").document("count").setData([
                                "count": 0
                            ]){ err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print("Document successfully written!")
                                    ref.collection("Japanese").document("TotalTime").setData([
                                        "time": 0
                                    ]){ err in
                                        if let err = err {
                                            print("Error writing document: \(err)")
                                        } else {
                                            print("Document successfully written!")
                                            ref.collection("Math").document("TotalTime").setData([
                                                "time": 0
                                            ]){ err in
                                                if let err = err {
                                                    print("Error writing document: \(err)")
                                                } else {
                                                    print("Document successfully written!")
                                                    ref.collection("English").document("TotalTime").setData([
                                                        "time": 0
                                                    ]){ err in
                                                        if let err = err {
                                                            print("Error writing document: \(err)")
                                                        } else {
                                                            print("Document successfully written!")
                                                            ref.collection("Science").document("TotalTime").setData([
                                                                "time": 0
                                                            ]){ err in
                                                                if let err = err {
                                                                    print("Error writing document: \(err)")
                                                                } else {
                                                                    print("Document successfully written!")
                                                                    ref.collection("Social").document("TotalTime").setData([
                                                                        "time": 0
                                                                    ]){ err in
                                                                        if let err = err {
                                                                            print("Error writing document: \(err)")
                                                                        } else {
                                                                            print("Document successfully written!")
                                                                            self.performSegue(withIdentifier: "backLogin", sender: nil)
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
