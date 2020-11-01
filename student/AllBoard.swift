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
    @IBOutlet weak var content: UITextField!
    
    // 投稿インスタンス
    var boards: [Board] = []
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var num_board = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 画面背景を設定
        self.view.backgroundColor = UIColor(red:0.85,green:1.0,blue:0.95,alpha:1.0)

    }
    
    // 画面にタッチで呼ばれる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        
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

        // ドラッグしたx座標の移動距離
        let dx = newDx - preDx
        print("x:\(dx)")

        // ドラッグしたy座標の移動距離
        let dy = newDy - preDy
        print("y:\(dy)")

        // 画像のフレーム
        var viewFrame: CGRect = boards[appDelegate.whichBoard].frame

        // 移動分を反映させる
        viewFrame.origin.x += dx
        viewFrame.origin.y += dy

        boards[appDelegate.whichBoard].frame = viewFrame
        
        self.view.addSubview(boards[appDelegate.whichBoard])

        // 小数点以下２桁のみ表示
//        labelX.text = "x: ".appendingFormat("%.2f", newDx)
//        labelY.text = "y: ".appendingFormat("%.2f", newDy)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
 
    @IBAction func addBoard(_ sender: Any) {
        // Screen Size の取得
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
  
        
        let board = Board()
        
        if let username = UserName.text,
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
            UserName.text = ""
            content.text = ""
            
            board.UserName.text = username
            board.content.text = con
            
        }
        
        board.tag = num_board
        appDelegate.whichBoard = num_board
        num_board += 1
        
        // 画像のフレームを設定
        board.frame = CGRect(x:0, y:0, width:250, height:150)

        // 画像をスクリーン中央に設定
        board.center = CGPoint(x:screenWidth/2, y:screenHeight/2)

        // タッチ操作を enable
        board.isUserInteractionEnabled = true

        self.view.addSubview(board)

        
        boards.append(board)
        
    }
    
    
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
