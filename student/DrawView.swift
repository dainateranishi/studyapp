//
//  DrawView.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/02.
//

import Foundation
import UIKit
import Firebase

class DrawView: UIView {
    
    var currentDrawing: Drawing?
    var finishedDrawings:[(String, Drawing)] = []
    var currentColor = UIColor.black
    let db = Firestore.firestore()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        self.db.collection("draw").addSnapshotListener({querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(err!)")
                return
            }
            snapshot.documentChanges.forEach{diff in
                if (diff.type == .added) {
                    print("New draw: \(diff.document.data())")
                    print("is Modified: \(diff.document.metadata.hasPendingWrites ? "Local" : "Server")")
                    if let color:String = diff.document.get("color")as? String,
                       let point:Array = diff.document.get("point")as? Array<Any>{
                        print("ok")
                        
                        var col = UIColor.black
                        if color == "blue"{
                            col = UIColor.blue
                        }else if color == "red"{
                            col = UIColor.red
                        }
                        
                        var points = [CGPoint]()
                        for po in point{
                            let p = po as! Dictionary<String, CGFloat>
                            points.append(CGPoint(x: p["x"]!, y: p["y"]!))
                        }
                        
                        var drawing = Drawing()
                        drawing.color = col
                        drawing.points = points
                        
                        self.finishedDrawings.append((diff.document.documentID, drawing))
                    }
                }
                if (diff.type == .modified) {
                    print("Modified Board: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed")
                }
            }
        })
        
    }
    
    override func draw(_ rect: CGRect) {
        for (_, drawing) in finishedDrawings {
            drawing.color.setStroke()
            stroke(drawing: drawing)
        }
        
        if let drawing = currentDrawing {
            drawing.color.setStroke()
            stroke(drawing: drawing)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchBegan")
        let touch = touches.first!
        let location = touch.location(in: self)
        currentDrawing = Drawing()
        currentDrawing?.color = currentColor
        currentDrawing?.points.append(location)
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchMove")
        let touch = touches.first!
        let location = touch.location(in: self)
                
        currentDrawing?.points.append(location)
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchEnded")
        if var drawing = currentDrawing {
            let touch = touches.first!
            let location = touch.location(in: self)
            let docID = "draw" + String(finishedDrawings.count)
            drawing.points.append(location)
            finishedDrawings.append((docID, drawing))
            writeDB(docID: docID, draw: drawing)
        }
        currentDrawing = nil
        setNeedsDisplay()
    }
    
    func clear() {
        finishedDrawings.removeAll()
        setNeedsDisplay()
    }
    
    func undo() {
        if finishedDrawings.count == 0 {
            return
        }
        finishedDrawings.remove(at: finishedDrawings.count - 1)
        setNeedsDisplay()
    }
    
    func setDrawingColor(color : UIColor){
        currentColor = color
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
    
    func writeDB(docID: String, draw: Drawing) -> Void {
        
        var point:Array<Dictionary<String, CGFloat>> = []
        for po in draw.points {
            point.append(["x":po.x, "y":po.y])
        }
        
        var color:String = "non_color"
        if draw.color == UIColor.black {
            color = "black"
        }else if draw.color == UIColor.blue{
            color = "blue"
        }else if draw.color == UIColor.red{
            color = "red"
        }
        
        self.db.collection("draw").document(docID).setData([
            "color": color,
            "point": point
        ]){err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(docID)")
            }
            
        }
    }
}
