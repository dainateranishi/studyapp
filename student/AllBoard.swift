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

class AllBoard: UIViewController {
 

    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Title_area: UITextField!
    @IBOutlet weak var content: UITextField!
    
    var boarddb:BoardDB?
    // 投稿インスタンス
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.boarddb = BoardDB(board: "allboard", view: self.view, centerX: view.frame.size.width/2, centerY: view.frame.size.height/2)
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

        
        boarddb!.moveBoard(preDx: preDx, preDy: preDy, newDx: newDx, newDy: newDy)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
 
    @IBAction func addBoard(_ sender: Any) {
        
        if let username = UserName.text,
           let title = Title_area.text,
           let con = content.text {
            if username.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                UserName.layer.borderColor = UIColor.red.cgColor
                return
            }
            if con.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                content.layer.borderColor = UIColor.red.cgColor
                return
            }
            if title.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                Title_area.layer.borderColor = UIColor.red.cgColor
                return
            }
            UserName.text = ""
            content.text = ""
            Title_area.text = ""
    
            
            
            boarddb!.writeDB(name: username, title: title, content: con, width:250, height:250)
            
            
        }
        

    }
    
    
    
    //キーボードの表示に関すること
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.configureObserver()

    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        self.removeObserver() // Notificationを画面が消えるときに削除
    }

    // Notificationを設定
    func configureObserver() {

        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Notificationを削除
    func removeObserver() {

        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }

    // キーボードが現れた時に、画面全体をずらす。
    @objc func keyboardWillShow(notification: Notification?) {

        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = transform

        })
    }

    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {

        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in

            self.view.transform = CGAffineTransform.identity
        })
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder() // Returnキーを押したときにキーボードを下げる
        return true
    }
}