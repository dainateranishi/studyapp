//
//  StudyRoom.swift
//  student
//
//  Created by 寺西帝乃 on 2020/10/30.
//

//import Foundation
import UIKit
import Firebase
import SVProgressHUD

class Note: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    let db = Firestore.firestore()
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var Page: UILabel!
    @IBOutlet weak var subjuct: UILabel!
    @IBOutlet weak var shareWindowTable: UITableView!
    @IBOutlet weak var NextPageImage: UIImageView!
    @IBOutlet weak var MessageOrShareLabel: UILabel!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var chatText: UITextField!
    @IBOutlet weak var chatadd: UIButton!
    
    var  shareList = [String]()
    var  CommentList = [Comment]()
    let shareWindowHeight = CGFloat(150)
    let commentHeigh:CGFloat = 50
    var PageNum = 0
    var Note: String?
    var LoginTime: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        shareWindowTable.delegate = self
        shareWindowTable.dataSource = self
        shareWindowTable.register (UINib(nibName: "shareWindow", bundle: nil),forCellReuseIdentifier:"shareWindow")
        shareWindowTable.register (UINib(nibName: "CommentTableViewCell", bundle: nil),forCellReuseIdentifier:"CommentTableViewCell")
        shareWindowTable.tableFooterView = UIView()
        segmentedControl.selectedSegmentIndex = 0
        Page.text = "page" + String(PageNum)
        chatView.isHidden = true
        NextPageImage.transform = NextPageImage.transform.scaledBy(x: -1, y: 1)
        
        let window = sharingWindow(window: shareWindowTable)
        
        let ref = self.db.collection("class").document(self.appDelegate.whichClass!).collection(self.appDelegate.UserName!).document(Note!).collection("Share")
        
        ref.document("page").setData([
            "page": Page.text
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        ref.document("frameX").setData([
            "frameLeft": window.ShareLeft,
            "frameRight": window.ShareRight!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        ref.document("frameY").setData([
            "frameTop": window.ShareTop,
            "frameBottom": window.ShareBottom!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        
        
        drawView.readyDB(note: Note!, page: Page.text!, ShareWindow: window)
        
        readyShareTable()
        // Do any additional setup after loading the view.
    }
    
    
    func readyShareTable() -> Void {
        shareList = []
        self.shareWindowTable.reloadData()
        
        self.db.collection("class").document(self.appDelegate.whichClass!).collection(self.Note!).addSnapshotListener({ [self]querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(err!)")
                return
            }
            snapshot.documentChanges.forEach{diff in
                if diff.type == .added{
                    if diff.document.documentID != self.appDelegate.UserName!, diff.document.documentID != "TotalTime"{
                        print("New share")
                        shareList.append(diff.document.documentID)
                        self.shareWindowTable.reloadData()
                    }
                }
                if diff.type == .removed{
                    if diff.document.documentID != self.appDelegate.UserName!, diff.document.documentID != "TotalTime"{
                        print(diff.document.documentID)
                        
                        for i in 0...self.shareList.count{
                            if diff.document.documentID == self.shareList[i]{
                                self.shareList.remove(at: i)
                                self.shareWindowTable.reloadData()
                                break
                            }
                        }
                        
                    }
                }
            }
        })
    }
    
    func readyChat() -> Void {
        CommentList = []
        self.shareWindowTable.reloadData()
        
        self.db.collection("class").document(self.appDelegate.whichClass!).collection(self.appDelegate.UserName!).document(self.Note!).collection("Chat").addSnapshotListener({ [self]querySnapshot, err in
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
                    self.shareWindowTable.reloadData()
                }
            }
            //                if diff.type == .removed{
            //                    if diff.document.documentID != self.appDelegate.UserName!, diff.document.documentID != "TotalTime"{
            //                        print(diff.document.documentID)
            //
            //                        for i in 0...self.shareList.count{
            //                            if diff.document.documentID == self.shareList[i]{
            //                                self.shareList.remove(at: i)
            //                                self.shareWindowTable.reloadData()
            //                                break
            //                            }
            //                        }
            //
            //                    }
            //                }
            
        })
    }
    
    func changePage() -> Void {
        Page.text = "page" + String(PageNum)
        
        let window = sharingWindow(window: shareWindowTable)
        
        let ref = self.db.collection("class").document(self.appDelegate.whichClass!).collection(self.appDelegate.UserName!).document(Note!).collection("Share")
        
        ref.document("page").setData([
            "page": Page.text
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        ref.document("frameX").setData([
            "frameLeft": window.ShareLeft,
            "frameRight": window.ShareRight!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        ref.document("frameY").setData([
            "frameTop": window.ShareTop,
            "frameBottom": window.ShareBottom!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        drawView.readyDB(note: Note!, page: Page.text!, ShareWindow: window)
        
    }
    
    
    @IBAction func clearTapped(_ sender: Any) {
        drawView.clear()
    }
    
    @IBAction func undoTapped(_ sender: Any) {
        drawView.undo()
    }
    
    @IBAction func colorChange(_ sender: Any) {
        var c = UIColor.black
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            c = UIColor.blue
            break
        case 2:
            c = UIColor.red
            break
        default:
            break
        }
        drawView.setDrawingColor(color: c)
    }
    @IBAction func TapPreviousPage(_ sender: Any) {
        if PageNum != 0{
            PageNum -= 1
            Page.text = "page" + String(PageNum)
            changePage()
        }
    }
    
    @IBAction func TapNextPage(_ sender: Any) {
        PageNum += 1
        Page.text = "page" + String(PageNum)
        changePage()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MessageOrShareLabel.text == "Chat"{
            return shareList.count
        }else{
            return CommentList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの内容を取得
        if MessageOrShareLabel.text == "Chat"{
            let window = sharingWindow(window: shareWindowTable)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "shareWindow") as! shareWindow
            cell.Username.text = shareList[indexPath.row]
            cell.Username.textAlignment = .center
            cell.Username.adjustsFontSizeToFitWidth = true
            cell.drawWindow.readyDB(note: self.Note!, Username: shareList[indexPath.row], ShareWindow: window)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
            cell.CommentText.text = CommentList[indexPath.row].Content
            cell.CommentText.adjustsFontSizeToFitWidth = true
            cell.CommentUser.text = CommentList[indexPath.row].UserName
            cell.CommentUser.adjustsFontSizeToFitWidth = true
            
            return cell
        }
    }
    
    
    // セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if MessageOrShareLabel.text == "Chat"{
            return shareWindowHeight
        }else{
            return commentHeigh
        }
        
    }
    
    @IBAction func TapBack(_ sender: Any) {
        
        self.db.collection("class").document(self.appDelegate.whichClass!).collection(self.Note!).document("TotalTime").updateData([
            "time": FieldValue.increment(Int64(StudyTime(startTime: self.LoginTime!)))
        ]){err in
            if let err = err {
                print("Error StudyTime: \(err)")
            } else {
                print("StudyTime successfully updated!")
                self.performSegue(withIdentifier: "toStudyRoom", sender: nil)
            }
        }
        
        
        self.db.collection("class").document(self.appDelegate.whichClass!).collection(self.Note!).document(self.appDelegate.UserName!).delete(){err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.performSegue(withIdentifier: "toStudyRoom", sender: nil)
            }
        }
    }
    
    @IBAction func TapChatOrShare(_ sender: Any) {
        if MessageOrShareLabel.text == "Chat"{
            MessageOrShareLabel.text = "Share"
            chatView.isHidden = false
            readyChat()
        }else{
            MessageOrShareLabel.text = "Chat"
            chatView.isHidden = true
            readyShareTable()
        }
    }
    
    
    @IBAction func TapChatAdd(_ sender: Any) {
        
        if let content = chatText.text {
            if content.isEmpty{
                SVProgressHUD.showError(withStatus: "Chat is empty")
                chatText.layer.borderColor = UIColor.red.cgColor
                return
            }
            
            chatText.layer.borderColor = UIColor.black.cgColor
            
            self.db.collection("class").document(self.appDelegate.whichClass!).collection(self.appDelegate.UserName!).document(self.Note!).collection("Chat").addDocument(data: [
                "UserName": self.appDelegate.UserName!,
                "Content": content
            ])
            
            chatText.text = ""
        }
    }
    
    func toOtherNore(UserName: String) -> Void {
        let otherNote = self.storyboard?.instantiateViewController(withIdentifier: "OtherNote") as! OtherUserNote
        otherNote.Note = self.Note!
        otherNote.UserName = UserName
        otherNote.modalPresentationStyle = .fullScreen
        self.present(otherNote, animated: true, completion: nil)
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



class sharingWindow{
    var ShareTop = CGFloat(0)
    var ShareLeft = CGFloat(0)
    var ShareBottom: CGFloat?
    var ShareRight: CGFloat?
    var overX = CGFloat(0)
    var overY = CGFloat(0)
    
    
    
    init(window: UITableView) {
        ShareRight = window.frame.width
        ShareBottom = CGFloat(150)
    }
}
