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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
