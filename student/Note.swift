//
//  StudyRoom.swift
//  student
//
//  Created by 寺西帝乃 on 2020/10/30.
//

//import Foundation
import UIKit
import Firebase

class Note: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let db = Firestore.firestore()
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var Page: UILabel!
    @IBOutlet weak var subjuct: UILabel!
    @IBOutlet weak var shareWindowTable: UITableView!
    var  shareList = [String]()
    let shareWindowHeight = CGFloat(150)
    var PageNum = 0
    var Note: String?
    var LoginTime: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjuct.text = self.Note
        segmentedControl.selectedSegmentIndex = 0
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
        shareWindowTable.delegate = self
        shareWindowTable.dataSource = self
        shareWindowTable.register (UINib(nibName: "shareWindow", bundle: nil),forCellReuseIdentifier:"shareWindow")
        shareWindowTable.tableFooterView = UIView()
        
        
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
        
        // Do any additional setup after loading the view.
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
        return shareList.count
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // セルの内容を取得
        
        let window = sharingWindow(window: shareWindowTable)
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "shareWindow") as! shareWindow
        
        cell.Username.text = shareList[indexPath.row]
        cell.Username.textAlignment = .center
        cell.Username.adjustsFontSizeToFitWidth = true
        
        cell.drawWindow.readyDB(note: self.Note!, Username: shareList[indexPath.row], ShareWindow: window)
        
        return cell
        }


        // セルの高さを設定
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return shareWindowHeight
        }

    @IBAction func TapBack(_ sender: Any) {
        
        self.db.collection("class").document(self.appDelegate.whichClass!).collection(self.Note!).document("TotalTime").updateData([
            "time": FieldValue.increment(Int64(StudyTime(startTime: self.LoginTime!)))
        ]){err in
            if let err = err {
                print("Error StudyTime: \(err)")
            } else {
                print("StudyTime successfully updated!")
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
