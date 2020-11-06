//
//  replyBoard.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/04.
//

import Foundation
import UIKit
import Firebase

class ReplyBoard: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var ContentLabel: UILabel!
    @IBOutlet weak var ContentUser: UILabel!
    @IBOutlet weak var ConfirmLabel: UILabel!
    @IBOutlet weak var GoodLabel: UILabel!
    @IBOutlet weak var CommentArea: UITextField!
    @IBOutlet weak var CommentTable: UITableView!
    var Content: String? = nil
    var UserName: String? = nil
    var docID: String? = nil
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var CommentList = [Comment]()
    let db = Firestore.firestore()
    var className: String? = nil
    var boardName: String? = nil
    
    
    
    let cellHeigh:CGFloat = 50
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        className = appDelegate.whichClass
        ContentLabel.text = Content!
        ContentUser.text = UserName!
        CommentTable.delegate = self
        CommentTable.dataSource = self
        CommentTable.register (UINib(nibName: "CommentTableViewCell", bundle: nil),forCellReuseIdentifier:"CommentTableViewCell")
        CommentTable.tableFooterView = UIView()
        
        self.db.collection("class").document(self.className!).collection(self.boardName!).document(self.docID!).collection("Comment").addSnapshotListener({querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(err!)")
                return
            }
            snapshot.documentChanges.forEach{diff in
                if (diff.type == .added) {
                    var comment = Comment()
                    comment.UserName = diff.document.get("UserName") as! String
                    comment.Content = diff.document.get("Content") as! String
                    
                    self.CommentList.append(comment)
                    
                    self.CommentTable.reloadData()
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentList.count
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // セルの内容を取得
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        
        cell.CommentText.text = CommentList[indexPath.row].Content
//        cell.CommentText.textAlignment = .center
        cell.CommentText.adjustsFontSizeToFitWidth = true
        cell.CommentUser.text = CommentList[indexPath.row].UserName
//        cell.CommentUser.textAlignment = .center
        cell.CommentUser.adjustsFontSizeToFitWidth = true
        
        return cell
        }


        // セルの高さを設定
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return cellHeigh
        }
    @IBAction func TapAddComment(_ sender: Any) {
        
        var ref: DocumentReference? = nil
        ref = self.db.collection("class").document(self.className!).collection(self.boardName!).document(self.docID!).collection("Comment").addDocument(data: [
            "UserName":appDelegate.UserName!,
            "Content":CommentArea.text!
        ]){err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.CommentArea.text = ""
                
            }
            
        }
        
    }
}


struct Comment {
    var UserName = ""
    var Content = ""
    
    
}
