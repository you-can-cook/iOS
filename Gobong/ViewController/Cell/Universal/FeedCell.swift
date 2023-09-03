//
//  FeedCell.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/01.
//

import UIKit
import Kingfisher

protocol FeedCellDelegate: Any {
    func profileTapped(cell: FeedCell)
}

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var starStack: UIStackView!
    @IBOutlet weak var levelStack: UIStackView!
    @IBOutlet weak var toolStack: UIStackView!
    @IBOutlet weak var timeStack: UIStackView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var cookingToolsLabel: UILabel!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var bookmarkCountLabel: UILabel!
    @IBOutlet weak var bookmarkImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var delegate: FeedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        followingButton.layer.cornerRadius = 2
        followingButton.titleLabel?.adjustsFontSizeToFitWidth = true
        followingButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        setBackgroundShadow()
        
        userProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileTapped)))
        userName.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileTapped)))
    }
    
    func setBackgroundShadow(){
        background.layer.cornerRadius = 12
        background.layer.shadowColor = UIColor(red: 0.721, green: 0.721, blue: 0.721, alpha: 0.25).cgColor
        background.layer.shadowOpacity = 1
        background.layer.shadowRadius = 10
        background.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    func configuration(userImg: String? , username: String, following: Bool, thumbnailImg: String?, title: String, bookmarkCount: Int, isBookmarked: Bool, cookingTime: Int, tools: [String], level: String, stars: Double, isFollowing: Bool) {
        
        if userImg != nil {
            let userProfileUrl = URL(string: userImg!)
            userProfile.kf.setImage(with: userProfileUrl)
        } else {
            userProfile.image = UIImage(named: "프로필 이미지")
        }
        userName.text = username
         
        if isFollowing {
            followingButton.setTitle("팔로잉", for: .normal)
            followingButton.backgroundColor = UIColor(named: "softGray")
        } else {
            followingButton.setTitle("팔로우", for: .normal)
            followingButton.backgroundColor = UIColor(named: "pink")
        }
        
        followingButton.setTitle(following ? "팔로잉" : "팔로우", for: .normal)
        
        let thumbnailURL = URL(string: thumbnailImg!)
        thumbnailImage.kf.setImage(with: thumbnailURL)
        
        postTitle.text = title
        
        if isBookmarked {
            bookmarkImage.image = UIImage(named: "BMarkOk")
        } else {
            bookmarkImage.image = UIImage(named: "Bookmark")
        }
        
        bookmarkCountLabel.text = "\(bookmarkCount)"
        
        var minute = cookingTime / 6
        var second = cookingTime % 6
        
        if minute != 0 && second != 0 {
            cookTimeLabel.text = "\(minute)분\(second)초"
        } else if minute != 0 {
            cookTimeLabel.text = "\(minute)분"
        } else {
            cookTimeLabel.text = "\(second)초"
        }
        
        var hanTool = [String]()
        
        for i in tools {
            hanTool.append(CookingTools.caseFromEng(i)!.rawValue)
        }
        
        if hanTool.count > 2 {
            cookingToolsLabel.text = "\(hanTool.first!) +\(hanTool.count-1)개"
        } else if hanTool.count == 1 {
            cookingToolsLabel.text = "\(hanTool.first!)"
        } else {
            cookingToolsLabel.text = "-"
        }
        
        levelLabel.text = level
        
        if stars == 0 {
            starLabel.text = "-"
        } else {
            starLabel.text = "\(stars)공기"
        }
    }
    
    @objc
    private func profileTapped(){
        delegate?.profileTapped(cell: self)
    }
    
    
}
