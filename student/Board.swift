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
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        print("作るよ")
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Board" , bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        addSubview(view)
        
        }

//    @IBAction func TapBoard(_ sender: Any) {
//
//        appDelegate.whichBoard = self.tag
//    }
    @IBAction func TapBoard(_ sender: Any) {
        appDelegate.whichBoard = self.tag
    }
}
