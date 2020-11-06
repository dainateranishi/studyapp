//
//  Board.swift
//  student
//
//  Created by 寺西帝乃 on 2020/10/30.
//

//import Foundation

import UIKit

class Board: UIView {

    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!
//    var storyboard: UIStoryboard?
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        storyboard = self.storyboard!
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        storyboard = self.storyboard!
        configure()
    }

    private func configure() {
        print("作るよ")
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Board" , bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        addSubview(view)
        
        }

    @IBAction func TapBoard(_ sender: Any) {
        if let parentV = self.parentViewController() as? AllBoard{
            parentV.whichBoard = self.tag
            print(parentV.whichBoard)
        }else if let parentV = self.parentViewController() as? StudentBoard{
            parentV.whichBoard = self.tag
            print(parentV.whichBoard)
        }
    }
    @IBAction func TapReply(_ sender: Any) {
        if let parentV = self.parentViewController() as? AllBoard{
            parentV.Reply(UserName: UserName.text!, Content: content.text!, Title: title.text!, boardTag: self.tag)
        }
    }
    
    
    @IBAction func TapDelete(_ sender: Any) {
        if let parentV = self.parentViewController() as? AllBoard{
            parentV.whichBoard = self.tag
            parentV.deleteBorad()
        }else if let parentV = self.parentViewController() as? StudentBoard{
            parentV.whichBoard = self.tag
            parentV.deleteBorad()
        }
    }
}

