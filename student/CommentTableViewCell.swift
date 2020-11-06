//
//  CommentTableViewCell.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/06.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var CommentUser: UILabel!
    @IBOutlet weak var CommentText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
