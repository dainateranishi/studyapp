//
//  otherUserNote.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/11.
//

import Foundation
import Foundation
import UIKit
import  Firebase
import FirebaseAuth
import SVProgressHUD


class OtherUserNote: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backMyNote: UIImageView!
    @IBOutlet weak var otherdrawView: OtherDrawView!
    @IBOutlet weak var NoteLabel: UILabel!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var otherUsername: UILabel!
    @IBOutlet weak var chatText: UITextField!
    var Note: String?
    var UserName: String?
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var CommentList = [Comment]()
    let commentHeigh:CGFloat = 50
    let db = Firestore.firestore()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let next = segue.destination as? Note
        // segueのIDを確認して特定のsegueのときのみ動作させる
        
        next?.Note = self.Note!
        next?.LoginTime = nowTimeString()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NoteLabel.text = Note!
        otherUsername.text = UserName!
        
        chatTable.delegate = self
        chatTable.dataSource = self
        chatTable.register (UINib(nibName: "CommentTableViewCell", bundle: nil),forCellReuseIdentifier:"CommentTableViewCell")
        chatTable.tableFooterView = UIView()
        
        
        
        otherdrawView.readyDB(note: Note!, Username: UserName!)
        readyChat()
    }
    
    func readyChat() -> Void {
        CommentList = []
        self.chatTable.reloadData()
        
        self.db.collection("class").document(self.appDelegate.whichClass!).collection(self.UserName!).document(self.Note!).collection("Chat").addSnapshotListener({ [self]querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(err!)")
                return
            }
            snapshot.documentChanges.forEach{diff in
                if diff.type == .added{
                    var comment = Comment()
                    comment.UserName = diff.document.get("UserName") as! String
                    comment.Content = diff.document.get("Content") as! String
                    CommentList.append(comment)
                    self.chatTable.reloadData()
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        cell.CommentText.text = CommentList[indexPath.row].Content
        cell.CommentText.adjustsFontSizeToFitWidth = true
        cell.CommentUser.text = CommentList[indexPath.row].UserName
        cell.CommentUser.adjustsFontSizeToFitWidth = true
        
        return cell
        
    }
    
    
    // セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return commentHeigh
        
    }
    
    @IBAction func TapChatAdd(_ sender: Any) {
        if let content = chatText.text {
            if content.isEmpty{
                SVProgressHUD.showError(withStatus: "Chat is empty")
                chatText.layer.borderColor = UIColor.red.cgColor
                return
            }
            
            chatText.layer.borderColor = UIColor.black.cgColor
            
            self.db.collection("class").document(self.appDelegate.whichClass!).collection(self.UserName!).document(self.Note!).collection("Chat").addDocument(data: [
                "UserName": self.appDelegate.UserName!,
                "Content": content
            ])
            
            chatText.text = ""
        }
    }
    
    
    @IBAction func TapBack(_ sender: Any) {
        self.performSegue(withIdentifier: "backMyNote", sender: nil)
    }
    
    //キーボード関連
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                self.view.frame.origin.y -= suggestionHeight
            }
        }
    }
    
    @objc func keyboardWillHide() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
