//
//  ViewController.swift
//  student
//
//  Created by 寺西帝乃 on 2020/10/28.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var Monthlabel: UILabel!
    @IBOutlet weak var Daylabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowTime()
        Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    //NSTimerを利用して60分の1秒ごとに呼びたす。
    @objc func update() {
        nowTime()
    }
    
    func nowTime(){
        let myDate: Date = Date()//現在時刻を取得
        let myCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!//カレンダーを取得する
        
        let myComponetns = myCalendar.components([NSCalendar.Unit.year,
                                                    NSCalendar.Unit.month,
                                                    NSCalendar.Unit.day,
                                                    NSCalendar.Unit.hour,
                                                    NSCalendar.Unit.minute,
                                                    NSCalendar.Unit.second,
                                                    NSCalendar.Unit.weekday], from: myDate)
        let MonthStrings: Array = ["nil","January","February","March","April","May","June","July","August", "September", "October", "November", "December"]//曜日の配列
            /*Storyboardに表示*/
        Monthlabel.text = MonthStrings[myComponetns.month!]
        Daylabel.text = addZero(num: myComponetns.day!)
        TimeLabel.text = addZero(num: myComponetns.hour!) + ":" + addZero(num: myComponetns.minute!) + ":" + addZero(num: myComponetns.second!)

    }
    
    func addZero(num: Int) -> String {
        if num < 10{
            return String(0) + String(num)
        }
        else{
            return String(num)
        }
    }
    
    
    @IBAction func toMyRoom(_ sender: Any) {
    }
    
    @IBAction func toPublicBoard(_ sender: Any) {
    }
    
    @IBAction func toStudentBoard(_ sender: Any) {
    }
    
    @IBAction func toStudyRoom(_ sender: Any) {
    }
}

