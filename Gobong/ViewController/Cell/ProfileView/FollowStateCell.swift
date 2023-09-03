//
//  FollowStateCell.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/12.
//

import UIKit

protocol FollowDelegate {
    func followingTapped(cell: FollowStateCell)
}

class FollowStateCell: UITableViewCell {
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    var delegate: FollowDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    @IBAction func followTapped(_ sender: Any) {
        delegate?.followingTapped(cell: self)
    }
    
    func configuration(img: String?, name: String, following: Bool) {
        if img != nil {
            let url = URL(string: img!)
            profileImg.load(url: url!)
        } else {
            profileImg.image = UIImage(named: "프로필 이미지")
        }
        nameLabel.text = name
        
        setButtonUI(following: following)
    }
    
    private func setButtonUI(following: Bool){
        if !following {
            followButton.backgroundColor = UIColor(named: "pink")
            followButton.titleLabel?.textColor = .white
            followButton.setTitle("팔로우", for: .normal)
        } else {
            followButton.backgroundColor =  UIColor(named: "softGray")
            followButton.titleLabel?.textColor = .white
            followButton.setTitle("팔로잉", for: .normal)
        }
    }
}
