//
//  shareWindow.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/08.
//

import UIKit

class shareWindow: UITableViewCell {
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var drawWindow: ShareDrawView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        let longPress = UILongPressGestureRecognizer(target: self, action:Selector(("showOtherNote")))
        //        longPress.delegate = self
        //        drawWindow.addGestureRecognizer(longPress)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(showOtherNote(sender:)))
        longPress.delegate = self
        drawWindow.addGestureRecognizer(longPress)
        
        // Configure the view for the selected state
    }
    
    
    @objc func showOtherNote(sender: UILongPressGestureRecognizer) -> Void {
        if sender.state == .ended {
            let parentV = self.parentViewController() as? Note
            parentV?.toOtherNore(UserName: Username.text!)
        }
    }
}
