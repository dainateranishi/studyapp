//
//  StudyRoom.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/04.
//

import Foundation
import UIKit
import Firebase

class StudyRoom: UIViewController {
    let db = Firestore.firestore()
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var UserNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserNameLabel.text = self.appDelegate.UserName!

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let next = segue.destination as? Note
        // segueのIDを確認して特定のsegueのときのみ動作させる
        if segue.identifier == "isJapanese" {
            next?.Note = "Japanese"
            next?.LoginTime = nowTimeString()
        }else if segue.identifier == "isMath" {
            next?.Note = "Math"
            next?.LoginTime = nowTimeString()
        }else if segue.identifier == "isEnglish" {
            next?.Note = "English"
            next?.LoginTime = nowTimeString()
        }else if segue.identifier == "isScience" {
            next?.Note = "Science"
            next?.LoginTime = nowTimeString()
        }else if segue.identifier == "isSocial" {
            next?.Note = "Social"
            next?.LoginTime = nowTimeString()
        }
    }
    
    @IBAction func TapJapanese(_ sender: Any) {
        self.db.collection("class").document(self.appDelegate.whichClass!).collection("Japanese").document(self.appDelegate.UserName!).setData([
            "LogIn": nowTimeString(),
            "LogOut": nowTimeString()
        ])
        performSegue(withIdentifier: "isJapanese", sender: nil)
    }
    
    @IBAction func TapMath(_ sender: Any) {
        self.db.collection("class").document(self.appDelegate.whichClass!).collection("Math").document(self.appDelegate.UserName!).setData([
            "LogIn": nowTimeString(),
            "LogOut": nowTimeString()
        ])
        performSegue(withIdentifier: "isMath", sender: nil)
    }
    
    @IBAction func TapEnglish(_ sender: Any) {
        self.db.collection("class").document(self.appDelegate.whichClass!).collection("English").document(self.appDelegate.UserName!).setData([
            "LogIn": nowTimeString(),
            "LogOut": nowTimeString()
        ])
        performSegue(withIdentifier: "isEnglish", sender: nil)
    }
    
    @IBAction func TapScience(_ sender: Any) {
        self.db.collection("class").document(self.appDelegate.whichClass!).collection("Science").document(self.appDelegate.UserName!).setData([
            "LogIn": nowTimeString(),
            "LogOut": nowTimeString()
        ])
        performSegue(withIdentifier: "isScience", sender: nil)
    }
    
    @IBAction func TapSocial(_ sender: Any) {
        self.db.collection("class").document(self.appDelegate.whichClass!).collection("Social").document(self.appDelegate.UserName!).setData([
            "LogIn": nowTimeString(),
            "LogOut": nowTimeString()
        ])
        performSegue(withIdentifier: "isSocial", sender: nil)
    }
    
    @IBAction func TapBack(_ sender: Any) {
        self.performSegue(withIdentifier: "backHomeFromStudyRoom", sender: nil)
    }
}
