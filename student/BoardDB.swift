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
    var boards: [(String, Board)] = [("test", Board())]
    var num_boards = 1
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    init(board: String) {
        self.collection = board
    }
    
    
    func readAllBoards(view: UIView){
        self.db.collection(self.collection).getDocuments(){(snapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let username:String = document.get("username")as! String,
                       let title:String = document.get("title")as! String,
                       let content:String = document.get("content")as! String,
                       let x:CGFloat = document.get("x")as! CGFloat,
                       let y:CGFloat = document.get("y")as! CGFloat,
                       let width:CGFloat = document.get("width")as! CGFloat,
                       let height:CGFloat = document.get("height")as! CGFloat,
                       let frame:CGRect = CGRect(x: x, y: y, width: width, height: height),
                       let point:CGPoint = CGPoint(x: x, y: y){
                        print("ok")
                        self.boards.append((document.documentID, self.makeBoard(username: username, title: title, content: content, frame: frame, point: point)));
                        self.boards[self.num_boards].1.tag = self.num_boards
                        self.appDelegate.whichBoard = self.num_boards
                        view.addSubview(self.boards[self.num_boards].1)
                        self.num_boards += 1
                    }
                }
            }
        }
    }
    
    func moveBoard(view: UIView, preDx: CGFloat, preDy: CGFloat, newDx: CGFloat, newDy: CGFloat){
        
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
        view.addSubview(self.boards[appDelegate.whichBoard!].1)

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
    
    
    
    func writeDB(name: String, title: String, content: String, x:CGFloat, y:CGFloat, width: CGFloat, height: CGFloat, point: CGPoint, view: UIView){
        
        var ref: DocumentReference? = nil
        ref = self.db.collection(self.collection).addDocument(data: [
            "username": name,
            "title": title,
            "content": content,
            "x": x,
            "y": y,
            "width": width,
            "height": height
        ]){err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.boards.append((ref!.documentID, self.makeBoard(username: name, title: title, content: content, frame: CGRect(x: x, y: y, width: width, height: height), point: point)));
                self.boards[self.num_boards].1.tag = self.num_boards
                self.appDelegate.whichBoard = self.num_boards
                view.addSubview(self.boards[self.num_boards].1)
                self.num_boards += 1
            }
            
        }
    }
}
