//
//  UserInformationCell.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/04.
//

import UIKit

protocol UserInformationDelegate: Any {
    func followingTapped(controller: UserInformationCell)
    func followersTapped(controller: UserInformationCell)
}

class UserInformationCell: UITableViewCell {
    
    @IBOutlet weak var followingStack: UIStackView!
    @IBOutlet weak var followerStack: UIStackView!
    @IBOutlet weak var profileImg: CircularImageView!
    @IBOutlet weak var recipeCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    var delegate: UserInformationDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        followerStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followerTapped)))
        followingStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followingTapped)))
    }
    
    @objc private func followerTapped(){
        delegate?.followersTapped(controller: self)
    }
    
    @objc private func followingTapped(){
        delegate?.followingTapped(controller: self)
    }
    
    func configuration(img: String?, recipeCount: Int, followerCount: Int, followingCount: Int){
        if img != nil {
            let url = URL(string: img!)
            profileImg.load(url: url!)
        } else {
            profileImg.image = UIImage(named: "프로필 이미지")
        }
      
        recipeCountLabel.text = "\(recipeCount)"
        followerCountLabel.text = "\(followerCount)"
        followingCountLabel.text = "\(followingCount)"
    }

}
