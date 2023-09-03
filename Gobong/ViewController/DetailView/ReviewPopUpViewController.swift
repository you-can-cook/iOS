//
//  ReviewPopUpViewController.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/13.
//

import UIKit

protocol ReviewPopUpDelegate: Any {
    func reviewTapped(controller: ReviewPopUpViewController)
}

class ReviewPopUpViewController: UIViewController {

    @IBOutlet weak var blackBackgroundView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var reviewButton: UIButton!
    
    @IBOutlet weak var fiveStarImg: UIImageView!
    @IBOutlet weak var fourStarImg: UIImageView!
    @IBOutlet weak var threeStarImg: UIImageView!
    @IBOutlet weak var twoStarImg: UIImageView!
    @IBOutlet weak var oneStarImg: UIImageView!
    
    var sendedStar = 0
    var star = 0
    var id: Int!
    var delegate: ReviewPopUpDelegate?
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        backgroundView.layer.cornerRadius = 20
        reviewButton.layer.cornerRadius = 15
        showStar(0)
        
        oneStarImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(oneStarTapped)))
        twoStarImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(twoStarTapped)))
        threeStarImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(threeStarTapped)))
        fourStarImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fourStarTapped)))
        fiveStarImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fiveStarTapped)))
        blackBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(xButtonTapped)))
    }
    
    //MARK: BUTTON
    @objc
    @IBAction
    func xButtonTapped(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func reviewButtonTapped(_ sender: Any) {
        if sendedStar > 0 {
            Server.shared.editRating(id: id!, score: star) {
                self.delegate?.reviewTapped(controller: self)
                self.dismiss(animated: false)
            }
        } else {
            Server.shared.sendRating(id: id!, score: star) {
                self.delegate?.reviewTapped(controller: self)
                self.dismiss(animated: false)
            }
        }
    }
    
    //STAR TAPPED FUNCTION
    @objc
    private func oneStarTapped(){
        star = 1
        showStar(star)
    }
    
    @objc
    private func twoStarTapped(){
        star = 2
        showStar(star)
    }
    
    @objc
    private func threeStarTapped(){
        star = 3
        showStar(star)
    }
    
    @objc
    private func fourStarTapped(){
        star = 4
        showStar(star)
    }
    
    @objc
    private func fiveStarTapped(){
        star = 5
        showStar(star)
    }
    
    private func showStar(_ star: Int){
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
        } else {
            oneStarImg.image = UIImage(named: "별점x")
            twoStarImg.image = UIImage(named: "별점x")
            threeStarImg.image = UIImage(named: "별점x")
            fourStarImg.image = UIImage(named: "별점x")
            fiveStarImg.image = UIImage(named: "별점x")
        }
    }

}
