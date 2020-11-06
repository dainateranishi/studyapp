//
//  replyBoard.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/04.
//

import Foundation
import UIKit

class ReplyBoard: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var ContentLabel: UILabel!
    @IBOutlet weak var ContentUser: UILabel!
    @IBOutlet weak var ConfirmLabel: UILabel!
    @IBOutlet weak var GoodLabel: UILabel!
    @IBOutlet weak var CommentArea: UITextField!
    @IBOutlet weak var CommentTable: UITableView!
    var Content: String? = nil
    var UserName: String? = nil
    
    
    
    let cellHeigh:CGFloat = 50
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ContentLabel.text = Content!
        ContentUser.text = UserName!
        CommentTable.delegate = self
        CommentTable.dataSource = self
        CommentTable.register (UINib(nibName: "CommentTableViewCell", bundle: nil),forCellReuseIdentifier:"CommentTableViewCell")
        CommentTable.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // セルの内容を取得
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
            return cell
        }
//
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            CommentTable.reloadData()
        }

        // セルの高さを設定
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return cellHeigh
        }
}
