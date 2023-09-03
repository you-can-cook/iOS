//
//  DetailTitleCell.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/06.
//

import UIKit
import Kingfisher

protocol DetailTitleDelegate: Any {
    func profileTapped(cell: DetailTitleCell)
    func followingTapped(cell: DetailTitleCell)
}

class DetailTitleCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var cookingToolsLabel: UILabel!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var delegate: DetailTitleDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        followingButton.layer.cornerRadius = 2
        followingButton.titleLabel?.adjustsFontSizeToFitWidth = true
        followingButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        setBackgroundShadow()
        
        userName.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileTapped)))
        userProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileTapped)))
        
    }
    
    @IBAction func followingTapped(_ sender: Any) {
        delegate?.followingTapped(cell: self)
    }
    
    @objc
    private func profileTapped(){
        delegate?.profileTapped(cell: self)
    }
    
    func setBackgroundShadow(){
        background.layer.cornerRadius = 12
        background.layer.shadowColor = UIColor(red: 0.721, green: 0.721, blue: 0.721, alpha: 0.25).cgColor
        background.layer.shadowOpacity = 1
        background.layer.shadowRadius = 10
        background.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    func configuration(userImg: String? , username: String, following: Bool, thumbnailImg: String, title: String, bookmarkCount: Int, cookingTime: Int, tools: [String], level: String, stars: Double?) {
        
        if userImg != nil {
            let url = URL(string: userImg!)
            userProfile.kf.setImage(with: url)
        } else {
            userProfile.image = UIImage(named: "프로필 이미지")
        }
        
        userName.text = username
        followingButton.setTitle(following ? "팔로잉" : "팔로우", for: .normal)
        followingButton.backgroundColor = following ? UIColor(named: "softGray") : UIColor(named: "pink")
        
        let url = URL(string: thumbnailImg)
        thumbnailImage.kf.setImage(with: url)
        
        cookTimeLabel.text = "\(cookingTime)분"
        
        var hanTool = [String]()
        
        for i in tools {
            hanTool.append(CookingTools.caseFromEng(i)!.rawValue)
        }
        
        if hanTool.count > 2 {
            cookingToolsLabel.text = "\(hanTool.first!) +\(hanTool.count-1)개"
        } else if tools.count == 1 {
            cookingToolsLabel.text = hanTool.first!
        } else {
            cookingToolsLabel.text = "-"
        }
        
        levelLabel.text = level
        
        if stars != nil {
            starLabel.text = "\(stars!)공기"
        } else {
            starLabel.text = "-"
        }
    }
    
}
