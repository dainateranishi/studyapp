//
//  StudyRoom.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/04.
//

import Foundation
import UIKit

class StudyRoom: UIViewController {
    
    @IBOutlet weak var roomName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let next = segue.destination as? Note
        // segueのIDを確認して特定のsegueのときのみ動作させる
        if segue.identifier == "isJapanese" {
            next?.Note = "Japanese"
        }else if segue.identifier == "isMath" {
            next?.Note = "Math"
        }else if segue.identifier == "isEnglish" {
            next?.Note = "English"
        }else if segue.identifier == "isScience" {
            next?.Note = "Science"
        }else if segue.identifier == "isSocial" {
            next?.Note = "Social"
        }
    }
    
    @IBAction func TapJapanese(_ sender: Any) {
        performSegue(withIdentifier: "isJapanese", sender: nil)
    }
    
    @IBAction func TapMath(_ sender: Any) {
        performSegue(withIdentifier: "isMath", sender: nil)
    }
    
    @IBAction func TapEnglish(_ sender: Any) {
        performSegue(withIdentifier: "isEnglish", sender: nil)
    }
    
    @IBAction func TapScience(_ sender: Any) {
        performSegue(withIdentifier: "isScience", sender: nil)
    }
    
    @IBAction func TapSocial(_ sender: Any) {
        performSegue(withIdentifier: "isSocial", sender: nil)
    }
    
}
