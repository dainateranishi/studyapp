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
    let collection: String
    let view: UIView
    let centerX: CGFloat
    let centerY: CGFloat
    
    
    var boards: [(String, Board)] = [("test", Board())]

    var num_boards = 1
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    init(board: String, view: UIView, centerX: CGFloat, centerY: CGFloat) {
        self.collection = board
        self.view = view
        self.centerX = centerX
        self.centerY = centerY
        
//        self.readAllBoards()
        
        self.db.collection(self.collection).addSnapshotListener({querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(err!)")
                return
            }
            snapshot.documentChanges.forEach{diff in
                if (diff.type == .added) {
                    print("New Board: \(diff.document.data())")
                    print("is Modified: \(diff.document.metadata.hasPendingWrites ? "Local" : "Server")")
                    if let username:String = diff.document.get("username")as! String,
                       let title:String = diff.document.get("title")as! String,
                       let content:String = diff.document.get("content")as! String,
                       let x:CGFloat = diff.document.get("x")as! CGFloat,
                       let y:CGFloat = diff.document.get("y")as! CGFloat,
                       let width:CGFloat = diff.document.get("width")as! CGFloat,
                       let height:CGFloat = diff.document.get("height")as! CGFloat,
                       let frame:CGRect = CGRect(x: x, y: y, width: width, height: height),
                       let point:CGPoint = CGPoint(x: x, y: y){
                        print("ok")
                        self.boards.append((diff.document.documentID, self.makeBoard(username: username, title: title, content: content, frame: frame, point: point)));
                        self.boards[self.num_boards].1.tag = self.num_boards
                        self.appDelegate.whichBoard = self.num_boards
                        self.view.addSubview(self.boards[self.num_boards].1)
                        self.num_boards += 1
                    }
                }
                if (diff.type == .modified) {
                    print("Modified city: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed")
                }
            }
        })
    }
    
    
//    func readAllBoards(){
//        self.db.collection(self.collection).getDocuments(){(snapshot, err) in
//            if let err = err{
//                print("Error getting documents: \(err)")
//            }else{
//                for document in snapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                    if let username:String = document.get("username")as! String,
//                       let title:String = document.get("title")as! String,
//                       let content:String = document.get("content")as! String,
//                       let x:CGFloat = document.get("x")as! CGFloat,
//                       let y:CGFloat = document.get("y")as! CGFloat,
//                       let width:CGFloat = document.get("width")as! CGFloat,
//                       let height:CGFloat = document.get("height")as! CGFloat,
//                       let frame:CGRect = CGRect(x: x, y: y, width: width, height: height),
//                       let point:CGPoint = CGPoint(x: x, y: y){
//                        print("ok")
//                        self.boards.append((document.documentID, self.makeBoard(username: username, title: title, content: content, frame: frame, point: point)));
//                        self.boards[self.num_boards].1.tag = self.num_boards
//                        self.appDelegate.whichBoard = self.num_boards
//                        self.view.addSubview(self.boards[self.num_boards].1)
//                        self.num_boards += 1
//                    }
//                }
//            }
//        }
//    }
    
    func moveBoard(preDx: CGFloat, preDy: CGFloat, newDx: CGFloat, newDy: CGFloat){
        
        self.db.collection(self.collection).document(self.boards[appDelegate.whichBoard!].0).updateData([
            "x": newDx,
            "y": newDy
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        // ドラッグしたx座標の移動距離
        let dx = newDx - preDx
        print("x:\(dx)")

        // ドラッグしたy座標の移動距離
        let dy = newDy - preDy
        print("y:\(dy)")
        
        var viewFrame: CGRect = self.boards[appDelegate.whichBoard!].1.frame

        // 移動分を反映させる
        viewFrame.origin.x += dx
        viewFrame.origin.y += dy

        self.boards[self.appDelegate.whichBoard!].1.frame = viewFrame
        self.view.addSubview(self.boards[appDelegate.whichBoard!].1)

    }
    
    func makeBoard(username: String, title: String, content: String, frame: CGRect, point: CGPoint) -> Board {
        let board = Board()
        
        board.UserName.text = username
        board.content.text = content
        board.title.text = title
        board.frame = frame
        board.center = point
        board.isUserInteractionEnabled = true
        
        print("作ったよ")
        
        return board
        
    }
    
    
    
    func writeDB(name: String, title: String, content: String,width: CGFloat, height: CGFloat){
        
        var ref: DocumentReference? = nil
        ref = self.db.collection(self.collection).addDocument(data: [
            "username": name,
            "title": title,
            "content": content,
            "x": self.centerX,
            "y": self.centerY,
            "width": width,
            "height": height
        ]){err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.boards.append((ref!.documentID, self.makeBoard(username: name, title: title, content: content, frame: CGRect(x: self.centerX, y: self.centerY, width: width, height: height), point: CGPoint(x: self.centerX, y: self.centerY))));
                self.boards[self.num_boards].1.tag = self.num_boards
                self.appDelegate.whichBoard = self.num_boards
                self.view.addSubview(self.boards[self.num_boards].1)
                self.num_boards += 1
            }
            
        }
    }
}
