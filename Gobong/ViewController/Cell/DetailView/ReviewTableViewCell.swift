//
//  ReviewTableViewCell.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/13.
//

import UIKit

protocol ReviewDelegate: Any{
    func reviewTapped(cell: ReviewTableViewCell)
}

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var fiveStarImg: UIImageView!
    @IBOutlet weak var fourStarImg: UIImageView!
    @IBOutlet weak var threeStarImg: UIImageView!
    @IBOutlet weak var twoStarImg: UIImageView!
    @IBOutlet weak var oneStarImg: UIImageView!
    
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    
    var delegate: ReviewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        reviewButton.layer.cornerRadius = 15
    }
    
    @IBAction func reviewButtonTapped(_ sender: Any) {
        delegate?.reviewTapped(cell: self)
    }
    
    func isReviewed(_ star: Int){
        self.titleLabel.text = "내가 남긴 고봉밥"
        subtitleLabel.isHidden = true
        starView.isHidden = false
        showStar(star)
        reviewButton.setTitle("리뷰 수정하기", for: .normal)
    }
    
    func isNotReviewed(){
        self.titleLabel.text = "레시피는 어떠셨나요?"
        subtitleLabel.isHidden = false
        starView.isHidden = true
        reviewButton.setTitle("리뷰 작성하기", for: .normal)
    }
    
    private func showStar(_ star: Int){
        print(star)
        if star == 1 {
            oneStarImg.image = UIImage(named: "별점o")
            twoStarImg.image = UIImage(named: "별점x")
            threeStarImg.image = UIImage(named: "별점x")
            fourStarImg.image = UIImage(named: "별점x")
            fiveStarImg.image = UIImage(named: "별점x")
        } else if star == 2 {
            oneStarImg.image = UIImage(named: "별점o")
            twoStarImg.image = UIImage(named: "별점o")
            threeStarImg.image = UIImage(named: "별점x")
            fourStarImg.image = UIImage(named: "별점x")
            fiveStarImg.image = UIImage(named: "별점x")
        } else if star == 3 {
            oneStarImg.image = UIImage(named: "별점o")
            twoStarImg.image = UIImage(named: "별점o")
            threeStarImg.image = UIImage(named: "별점o")
            fourStarImg.image = UIImage(named: "별점x")
            fiveStarImg.image = UIImage(named: "별점x")
        } else if star == 4 {
            oneStarImg.image = UIImage(named: "별점o")
            twoStarImg.image = UIImage(named: "별점o")
            threeStarImg.image = UIImage(named: "별점o")
            fourStarImg.image = UIImage(named: "별점o")
            fiveStarImg.image = UIImage(named: "별점x")
        } else if star == 5 {
            oneStarImg.image = UIImage(named: "별점o")
            twoStarImg.image = UIImage(named: "별점o")
            threeStarImg.image = UIImage(named: "별점o")
            fourStarImg.image = UIImage(named: "별점o")
            fiveStarImg.image = UIImage(named: "별점o")
        }
    }

}
