//
//  StudyRoom.swift
//  student
//
//  Created by 寺西帝乃 on 2020/10/30.
//

//import Foundation
import UIKit
import Firebase

class StudyRoom: UIViewController {
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 0
        // Do any additional setup after loading the view.
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

    @IBAction func tapDB(_ sender: Any) {
        self.db.collection("draw").getDocuments(){(querySnapshot, err) in
            if let err = err{
                print("Error \(err)")
            }else{
                for  document in querySnapshot!.documents  {
                    let po = document.get("point") as! Array<Any>
                    print(po)
                    print(type(of: po))
                    for p in po {
                        let o = p as! Dictionary<String, Float>
                        print(type(of: p))
                        print(o["x"])
                        print(o["y"])
                    }
                }
            }
            
        }
    }
}

