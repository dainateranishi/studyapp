//
//  chatWindow.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/12.
//

import UIKit
import Firebase

class chatWindow: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ChatTable: chatTable!
    let db = Firestore.firestore()
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var chatList = [Comment]()
    var otherUserName: String?
    var Note: String?
    let commentHeigh:CGFloat = 50
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        cell.CommentText.text = chatList[indexPath.row].Content
        cell.CommentText.adjustsFontSizeToFitWidth = true
        cell.CommentUser.text = chatList[indexPath.row].UserName
        cell.CommentUser.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    // セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return commentHeigh
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        ChatTable.delegate = self
        ChatTable.dataSource = self
        ChatTable.register (UINib(nibName: "CommentTableViewCell", bundle: nil),forCellReuseIdentifier:"CommentTableViewCell")
        ChatTable.tableFooterView = UIView()

        // Configure the view for the selected state
    }
    
    func readyChat() -> Void {
        self.db.collection("class").document(self.appDelegate.whichClass!).collection(self.appDelegate.UserName!).document(self.Note!).collection(self.otherUserName!).addSnapshotListener({[self]querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(err!)")
                return
            }
            snapshot.documentChanges.forEach{diff in
                if diff.type == .added{
                    var comment = Comment()
                    comment.UserName = diff.document.get("UserName") as! String
                    comment.Content = diff.document.get("Content") as! String
                    self.chatList.append(comment)
                    self.ChatTable.reloadData()
                }
            }
        })
    }
    
}
