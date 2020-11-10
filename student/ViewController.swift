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
    @IBOutlet weak var LoginMember: UILabel!
    @IBOutlet weak var JapaneseTimeLabel: UILabel!
    @IBOutlet weak var MathTimeLabel: UILabel!
    @IBOutlet weak var EnglishTimeLabel: UILabel!
    @IBOutlet weak var ScienceTimeLabel: UILabel!
    @IBOutlet weak var SocialTimeLabel: UILabel!
    @IBOutlet weak var AllboardTimesLabel: UILabel!
    @IBOutlet weak var StudentboardTimesLabel: UILabel!
    @IBOutlet weak var BoardImage: UIImageView!
    @IBOutlet weak var CalenderImage: UIImageView!
    @IBOutlet weak var StudyRoomImage: UIImageView!
    @IBOutlet weak var MyRoomImage: UIImageView!
    @IBOutlet weak var ClassnameLabel: UILabel!
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ClassnameLabel.text = appDelegate.whichClass! + "組"
        nowTime()
        Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        
        //入室した生徒の表示
        self.db.collection("class").document(self.appDelegate.whichClass!).addSnapshotListener{documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data:[String: String] = document.get("member") as? [String : String] else {
              print("Document data was empty.")
              return
            }
            
            for name in data.keys{
                if  name != "studentName" {
                    self.LoginMember.text! += name
                }
            }
        }
        
        //国語の時間を表示
        self.db.collection("class").document(self.appDelegate.whichClass!).collection("Japanese").document("TotalTime").addSnapshotListener{ [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
            JapaneseTimeLabel.text = "Japanese : " + String(document.get("time") as! Int) + "分"
          }
        
        //数学の時間を表示
        self.db.collection("class").document(self.appDelegate.whichClass!).collection("Math").document("TotalTime").addSnapshotListener{ [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
            MathTimeLabel.text = "Math : " + String(document.get("time") as! Int) + "分"
          }
        
        //英語の時間を表示
        self.db.collection("class").document(self.appDelegate.whichClass!).collection("English").document("TotalTime").addSnapshotListener{ [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
            EnglishTimeLabel.text = "English : " + String(document.get("time") as! Int) + "分"
          }
        
        //理科の時間を表示
        self.db.collection("class").document(self.appDelegate.whichClass!).collection("Science").document("TotalTime").addSnapshotListener{ [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
            ScienceTimeLabel.text = "Science : " + String(document.get("time") as! Int) + "分"
          }
        
        //社会の時間を表示
        self.db.collection("class").document(self.appDelegate.whichClass!).collection("Social").document("TotalTime").addSnapshotListener{ [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
            SocialTimeLabel.text = "Social : " + String(document.get("time") as! Int) + "分"
          }
        
        //全体掲示板の回数を表示
        self.db.collection("class").document(self.appDelegate.whichClass!).collection("allboard").document("count").addSnapshotListener{ [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
            AllboardTimesLabel.text = "AllBoard : " + String(document.get("count") as! Int) + "回"
          }
        
        //学生掲示板の回数を表示
        self.db.collection("class").document(self.appDelegate.whichClass!).collection("studentboard").document("count").addSnapshotListener{ [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
            StudentboardTimesLabel.text = "StBoard : " + String(document.get("count") as! Int) + "回"
          }
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
    
    

    @IBAction func toStudentBoard(_ sender: Any) {
        self.performSegue(withIdentifier: "toStudyBoard", sender: nil)
    }
    
    @IBAction func TapMyRoom(_ sender: Any) {
        self.performSegue(withIdentifier: "toMyRoom", sender: nil)
    }
    
    
    @IBAction func toStudyRoom(_ sender: Any) {
        self.performSegue(withIdentifier: "toStudyRoom", sender: nil)
    }
}

