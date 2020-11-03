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
    @IBOutlet weak var Page: UILabel!
    var PageNum = 0
    let Note = "note1"
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        Page.text = "page" + String(PageNum)
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 0
        Page.text = "page" + String(PageNum)
        drawView.readyDB(note: Note, page: Page.text!)
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
    @IBAction func TapPreviousPage(_ sender: Any) {
        if PageNum != 0{
            PageNum -= 1
            Page.text = "page" + String(PageNum)
            viewDidLoad()
        }
    }
    
    @IBAction func TapNextPage(_ sender: Any) {
        PageNum += 1
        Page.text = "page" + String(PageNum)
        viewDidLoad()
    }
}

