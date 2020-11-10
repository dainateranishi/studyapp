//
//  chatDB.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/01.
//

import Foundation
import Firebase


class BoardDB{
    let db = Firestore.firestore()
    let className: String
    let board: String
    let view: UIView
    let centerX: CGFloat
    let centerY: CGFloat
    
    
    
    var boards: [(String, Board)] = [("test", Board())]

    var num_boards = 1

    
    
    init(board: String, className: String, view: UIView, centerX: CGFloat, centerY: CGFloat, Flag: Bool) {
        self.board = board
        self.view = view
        self.className = className
        self.centerX = centerX
        self.centerY = centerY
        
        if Flag {
            self.db.collection("class").document(self.className).collection(self.board).addSnapshotListener({querySnapshot, err in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(err!)")
                    return
                }
                snapshot.documentChanges.forEach{diff in
                    if (diff.type == .added) {
                        print("New Board: \(diff.document.data())")
                        print("is Modified: \(diff.document.metadata.hasPendingWrites ? "Local" : "Server")")
                        if let username = diff.document.get("username"),
                           let time = diff.document.get("time"),
                           let title = diff.document.get("title"),
                           let content = diff.document.get("content"),
                           let x = diff.document.get("x"),
                           let y = diff.document.get("y"),
                           let width = diff.document.get("width"),
                           let height = diff.document.get("height"),
                           let frame:CGRect = CGRect(x: x as! CGFloat, y: y as! CGFloat, width: width as! CGFloat, height: height as! CGFloat),
                           let point:CGPoint = CGPoint(x: x as! CGFloat, y: y as! CGFloat){
                            print("ok")
                            self.boards.append((diff.document.documentID, self.makeBoard(username: username as! String, title: title as! String, content: content as! String, frame: frame, point: point, time: time as! String)));
                            self.boards[self.num_boards].1.tag = self.num_boards
                            self.view.addSubview(self.boards[self.num_boards].1)
                            self.num_boards += 1
                        }
                    }
                    if (diff.type == .modified) {
                        print("Modified Board: \(diff.document.data())")
                        self.boards.forEach { (arg0) in let (id, bo) = arg0
                            if id == diff.document.documentID{
                                // ドラッグしたx座標の移動距離
                                let dx = diff.document.get("dx") as! CGFloat
                                
                                // ドラッグしたy座標の移動距離
                                let dy = diff.document.get("dy") as! CGFloat
                                
                                var viewFrame: CGRect = bo.frame
                                
                                // 移動分を反映させる
                                viewFrame.origin.x += dx
                                viewFrame.origin.y += dy
                                
                                bo.frame = viewFrame
                                self.view.addSubview(bo)
                            }
                        }
                    }
                    if (diff.type == .removed) {
                        print("Removed")
                        self.boards.forEach { (arg0) in let (id, bo) = arg0
                            if id == diff.document.documentID{
                                bo.removeFromSuperview()
                            }
                        }
                        print("Removed")
                    }
                }
            })
        }
    }
    
    
    func makeBoard(username: String, title: String, content: String, frame: CGRect, point: CGPoint, time: String) -> Board {
        let board = Board()
        
        board.UserName.text = username
        board.content = content
        board.time.text = time
        board.title.text = title
        board.frame = frame
        board.center = point
        board.isUserInteractionEnabled = true
        
        print("作ったよ")
        
        return board
        
    }
    
    func moveBoard(preDx: CGFloat, preDy: CGFloat, newDx: CGFloat, newDy: CGFloat, whichBoard: Int){
        // ドラッグしたx座標の移動距離
        let dx = newDx - preDx
        print("x:\(dx)")

        // ドラッグしたy座標の移動距離
        let dy = newDy - preDy
        print("y:\(dy)")
        
        self.db.collection("class").document(self.className).collection(self.board).document(self.boards[whichBoard].0).updateData([
            "x": newDx,
            "y": newDy,
            "dx": dx,
            "dy": dy
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }

    }
    
    func writeDB(name: String, title: String, content: String,width: CGFloat, height: CGFloat, time: String){
        
        var ref: DocumentReference? = nil
        ref = self.db.collection("class").document(self.className).collection(self.board).addDocument(data: [
            "time": time,
            "username": name,
            "title": title,
            "content": content,
            "x": self.centerX,
            "y": self.centerY,
            "dx": 0,
            "dy": 0,
            "width": width,
            "height": height
        ]){err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
            }
            
        }
    }
    
    func deleteBoard(whichBoard: Int){
        self.db.collection("class").document(self.className).collection(self.board).document(self.boards[whichBoard].0).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }

    }
    
    
}
