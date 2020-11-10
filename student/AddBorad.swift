//
//  AddBorad.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/10.
//

import Foundation
import UIKit
import Firebase
import SVProgressHUD

class AddBorad: UIViewController {
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var TitleText: PlaceHolderTextView!
    @IBOutlet weak var ContentText: PlaceHolderTextView!
    @IBOutlet weak var UserNameLabel: UILabel!
    let db = Firestore.firestore()
    var boarddb:BoardDB?
    var BoardName: String?
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TimeLabel.text = nowTimeString()
        TimeLabel.textAlignment = .center
        UserNameLabel.text = "〜" + self.appDelegate.UserName! + "より"
        
        self.boarddb = BoardDB(board: BoardName!, className: self.appDelegate.whichClass!, view: self.view, centerX: view.frame.size.width/2, centerY: view.frame.size.height/2, Flag: false)
    }
    
    
    @IBAction func TapAdd(_ sender: Any) {
        if let title = TitleText.text,
           let content = ContentText.text{
            if title.isEmpty {
                SVProgressHUD.showError(withStatus: "Title is empty")
                TitleText.layer.borderColor = UIColor.red.cgColor
                return
            }
            if content.isEmpty {
                SVProgressHUD.showError(withStatus: "Content is empty")
                ContentText.layer.borderColor = UIColor.red.cgColor
                return
            }
            
            TitleText.layer.borderColor = UIColor.black.cgColor
            ContentText.layer.borderColor = UIColor.black.cgColor
            
            SVProgressHUD.show()
            
            boarddb!.writeDB(name: self.appDelegate.UserName!, title: title, content: content, width: 250, height: 250, time: TimeLabel.text!)
            
            self.db.collection("class").document(self.appDelegate.whichClass!).collection(self.BoardName!).document("count").updateData([
                "count": FieldValue.increment(Int64(1))
            ]){err in
                if let err = err {
                    print("Error StudyTime: \(err)")
                }else {
                    print("StudyTime successfully updated!")
                    SVProgressHUD.dismiss()
                }
            }
            
            if self.BoardName == "allboard"{
                self.performSegue(withIdentifier: "toAllboard", sender: nil)
            }else if self.BoardName == "studentboard"{
                self.performSegue(withIdentifier: "toStudentboard", sender: nil)
            }
            
        }
    }
    
    
    @IBAction func TapBack(_ sender: Any) {
        if self.BoardName == "allboard"{
            self.performSegue(withIdentifier: "toAllboard", sender: nil)
        }else if self.BoardName == "studentboard"{
            self.performSegue(withIdentifier: "toStudentboard", sender: nil)
        }
    }
}
