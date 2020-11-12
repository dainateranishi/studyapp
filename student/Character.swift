//
//  Character.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/12.
//

import UIKit

class Character: UIView {
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    
    
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
        let nib = UINib(nibName: "Character" , bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        addSubview(view)
    }
    
    func setCharacter(imageName: String) -> Void {
        let flower:UIImage = UIImage(named: imageName)!
        self.characterImage.image = flower
        self.addSubview(characterImage)
    }

}
