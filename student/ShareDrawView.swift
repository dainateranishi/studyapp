//
//  ShareDrawView.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/06.
//

import Foundation
import UIKit
import Firebase

class ShareDrawView: UIView {
    var currentDrawing: Drawing?
    var finishedDrawings:[(String, Drawing)] = []
    var currentColor = UIColor.black
    let db = Firestore.firestore()
    var Note = ""
    var Page = ""
    var className = ""
    var UserName = ""
    var ShareTop = CGFloat(0)
    var ShareLeft = CGFloat(0)
    var ShareBottom: CGFloat?
    var ShareRight: CGFloat?
    

    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    func readyDB(note: String, page: String) -> Void {
        self.finishedDrawings = []
        self.currentColor = UIColor.black
        self.Note = note
        self.Page = page
        self.className = self.appDelegate.whichClass!
        self.UserName = self.appDelegate.UserName!
        self.ShareBottom = self.frame.height
        self.ShareRight = self.frame.width
        
        print(self.Note)
        print(self.Page)
        print(self.UserName)
        print(self.className)
        
        self.db.collection("class").document(self.className).collection("student1").document(self.Note).collection(self.Page).addSnapshotListener({ [self]querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(err!)")
                return
            }
            snapshot.documentChanges.forEach{diff in
                if (diff.type == .added) {
                    print("New draw: \(diff.document.data())")
                    print("New draw: \(diff.document.data())")
                    if let color = diff.document.get("color"),
                       let point = diff.document.get("point"){
                        print("ok")
                        var col = UIColor.black
                        if color as! String == "blue"{
                            col = UIColor.blue
                        }else if color as! String == "red"{
                            col = UIColor.red
                        }
                        
                        var points = [CGPoint]()
                        for po in point as! Array<Any>{
                            let p = po as! Dictionary<String, CGFloat>
                        
                            let drawX = p["x"]! - ShareLeft
                            let drawY = p["y"]! - ShareTop
                        
                            if drawX >= 0, drawX <= ShareRight!, drawY >= 0, drawY <= ShareBottom!{
                                points.append(CGPoint(x: drawX, y: drawY))
                            }
                        }
                        if points.count > 0{
                            print("Points: \(points.count)")
                            var drawing = Drawing()
                            drawing.color = col
                            drawing.points = points
                            self.finishedDrawings.append((diff.document.documentID, drawing))
                        }
                        print("finishDraw: \(self.finishedDrawings.count)")
                        setNeedsDisplay()
                    }
                }
                if (diff.type == .removed) {
                    print("Removed")
                    let docID = diff.document.documentID

                    for i in 0...self.finishedDrawings.count-1{
                        print("finishDraw delete: \(self.finishedDrawings.count)")
                        print(i)
                        if docID == self.finishedDrawings[i].0 {
                            self.finishedDrawings.remove(at: i)
                            setNeedsDisplay()
                            break
                        }
                    }
                }
            }
        })
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        for (_, drawing) in finishedDrawings {
            drawing.color.setStroke()
            stroke(drawing: drawing)
        }
        
//        if let drawing = currentDrawing {
//            drawing.color.setStroke()
//            stroke(drawing: drawing)
//        }
    }
    
    
    func stroke(drawing: Drawing) {
        let path = UIBezierPath()
        path.lineWidth = 10.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        let begin = drawing.points[0];
        path.move(to: begin)
        
        if drawing.points.count > 1 {
            for i in 1...(drawing.points.count - 1) {
                let end = drawing.points[i]
                path.addLine(to: end)
            }
        }
        path.stroke()
        
    }
}
