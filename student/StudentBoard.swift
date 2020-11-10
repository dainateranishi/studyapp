//
//  StudentBoadr.swift
//  student
//
//  Created by 寺西帝乃 on 2020/10/30.
//


//import Foundation
//
//  AllBoard.swift
//  student
//
//  Created by 寺西帝乃 on 2020/10/30.
//

//import Foundation
import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class StudentBoard: UIViewController {
 
    
    let db = Firestore.firestore()
    var boarddb:BoardDB?
    var whichBoard = 1
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.boarddb = BoardDB(board: "studentboard", className: self.appDelegate.whichClass!, view: self.view, centerX: view.frame.size.width/2, centerY: view.frame.size.height/2, Flag: true)
    }
    
    // 画面にタッチで呼ばれる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        print(boarddb!.boards)
        
    }
    
    //　ドラッグ時に呼ばれる
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチイベントを取得
        let touchEvent = touches.first!

        // ドラッグ前の座標, Swift 1.2 から
        let preDx = touchEvent.previousLocation(in: self.view).x
        let preDy = touchEvent.previousLocation(in: self.view).y

        // ドラッグ後の座標
        let newDx = touchEvent.location(in: self.view).x
        let newDy = touchEvent.location(in: self.view).y

        
        boarddb!.moveBoard(preDx: preDx, preDy: preDy, newDx: newDx, newDy: newDy, whichBoard: self.whichBoard)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
 
    @IBAction func addBoard(_ sender: Any) {
        let addboard = self.storyboard?.instantiateViewController(withIdentifier: "AddBoard") as! AddBorad
        addboard.BoardName = "studentboard"
        self.present(addboard, animated: true, completion: nil)
    }
    
    func deleteBorad() -> Void {
        print("Delete: \(self.whichBoard)")
        self.boarddb?.deleteBoard(whichBoard: self.whichBoard)
    }
    
    func Reply(UserName: String, Content: String, Title: String, boardTag: Int, time: String) -> Void {
        
        let replyboard = self.storyboard?.instantiateViewController(withIdentifier: "ReplyBoard") as! ReplyBoard
        print(Content)
        print(UserName)
        replyboard.Content = Content
        replyboard.UserName = UserName
        replyboard.docID = boarddb?.boards[boardTag].0
        replyboard.time = time
        replyboard.boardName = "studentboard"
        self.present(replyboard, animated: true, completion: nil)
    }
    
    @IBAction func Tapback(_ sender: Any) {
        self.performSegue(withIdentifier: "backHome", sender: nil)
    }
}

