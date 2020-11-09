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
    var sharewindow: sharingWindow?
    
    
    

    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    func readyDB(note: String, Username: String, ShareWindow: sharingWindow) -> Void {
        self.finishedDrawings = []
        self.currentColor = UIColor.black
        self.Note = note
        self.className = self.appDelegate.whichClass!
        self.UserName = Username
        self.sharewindow = ShareWindow
        
        self.db.collection("class").document(self.className).collection(self.UserName).document(self.Note).collection("Share").addSnapshotListener({ [self]querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(err!)")
                return
            }
            snapshot.documentChanges.forEach{diff in
                
                if diff.document.documentID == "page"{
                    print("page chaged")
                    self.finishedDrawings = []
                    setNeedsDisplay()
                    self.Page = diff.document.get("page") as! String
                    getShareFrame()
                    self.db.collection("class").document(self.className).collection(self.UserName).document(self.Note).collection(self.Page).addSnapshotListener({ [self]querySnapshot, err in
                        guard let snapshot = querySnapshot else {
                            print("Error fetching snapshots: \(err!)")
                            return
                        }
                        snapshot.documentChanges.forEach{diff in
                            if (diff.type == .added) {
                                if let color = diff.document.get("color"),
                                   let point = diff.document.get("point"){
                                    
                                    var col = UIColor.black
                                    if color as! String == "blue"{
                                        col = UIColor.blue
                                    }else if color as! String == "red"{
                                        col = UIColor.red
                                    }
                                    
                                    var points = [CGPoint]()
                                    for po in point as! Array<Any>{
                                        let p = po as! Dictionary<String, CGFloat>
                                        points.append(CGPoint(x: p["x"]!, y: p["y"]!))
                                    }
                                    var drawing = Drawing()
                                    drawing.color = col
                                    drawing.points = points
                                    
                                    self.finishedDrawings.append((diff.document.documentID, drawing))
                                    setNeedsDisplay()
                                    
                                }
                            }
                            if (diff.type == .modified) {
                                print("Modified Board: \(diff.document.data())")
                            }
                            if (diff.type == .removed) {
                                let docID = diff.document.documentID
                                for i in 0...self.finishedDrawings.count{
                                    if docID == self.finishedDrawings[i].0 {
                                        self.finishedDrawings.remove(at: i)
                                        setNeedsDisplay()
                                        break
                                    }
                                }
                            }
                        }
                    })
                }
            }
        })
    }
    
    func getShareFrame() -> Void {
        self.db.collection("class").document(self.className).collection(self.UserName).document(self.Note).collection("Share").addSnapshotListener({ [self]querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(err!)")
                return
            }
            snapshot.documentChanges.forEach{diff in
                if(diff.type == .added){
                    if diff.document.documentID == "frameX" {
                        self.sharewindow!.ShareLeft = diff.document.get("frameLeft") as! CGFloat
                        self.sharewindow!.ShareRight = diff.document.get("frameRight") as? CGFloat
                    }
                    if diff.document.documentID == "frameY" {
                        self.sharewindow!.ShareTop = diff.document.get("frameTop") as! CGFloat
                        self.sharewindow!.ShareBottom = diff.document.get("frameBottom") as? CGFloat
                    }
                }
                if(diff.type == .modified){
                    if diff.document.documentID == "frameX" {
                        self.sharewindow!.ShareLeft = diff.document.get("frameLeft") as! CGFloat
                        self.sharewindow!.ShareRight = diff.document.get("frameRight") as? CGFloat
                    }
                    if diff.document.documentID == "frameY" {
                        self.sharewindow!.ShareTop = diff.document.get("frameTop") as! CGFloat
                        self.sharewindow!.ShareBottom = diff.document.get("frameBottom") as? CGFloat
                    }
                }
            }
        })
    }
    
    override func draw(_ rect: CGRect) {
        for (_, drawing) in self.finishedDrawings {
            
            var frameDraw = Drawing()
            frameDraw.color = drawing.color
            frameDraw.color.setStroke()
            
            for point in drawing.points{
                let po = CGPoint(x: point.x - self.sharewindow!.ShareLeft, y: point.y - self.sharewindow!.ShareTop)
                frameDraw.points.append(po)
            }
            stroke(drawing: frameDraw)
        }
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
