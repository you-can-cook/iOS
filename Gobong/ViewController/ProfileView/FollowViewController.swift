//
//  FollowViewController.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/12.
//

import UIKit

struct dummyProfileData {
    var name: String
    var following: Bool
}

class FollowViewController: UIViewController, FollowDelegate {
    
    //IS USER TAP FOLLOWERS OR FOLLOWING?
    func followingTapped(cell: FollowStateCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if followStateTapped == "followers" {
            if followerData[indexPath.item].isFollowed {
                Server.shared.unfollowUser(id: followerData[indexPath.item].userId) {
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            } else {
                Server.shared.followUser(id: followerData[indexPath.item].userId) {
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
            
        } else if followStateTapped == "followings" {
            //CANCEL FOLLOW
            Server.shared.unfollowUser(id: followingData[indexPath.item].userId) {
                cell.followButton.backgroundColor = UIColor(named: "pink")
                cell.followButton.titleLabel?.textColor = .white
                cell.followButton.setTitle("팔로우", for: .normal)
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    
    var followingData = [UserProfile]()
    var followerData = [UserWithFollowStatus]()
    
    var followStateTapped = ""
    var username = "유저 이름"
    
    //MARK: LIFE CYCLE
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        setupData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupNavigationBar()
        self.followStateUI()
        
        setupData()
        
    }
    
    
    //MARK: UI
    
    private func setupData(){
        if followStateTapped == "followings" {
            Server.shared.getFollowing { result in
                switch result {
                case .success(let UserInfo):
                    //SET THE IMAGE TO THE UI
                    self.followingData = UserInfo
                    self.tableViewSetup()
                    self.checkIfEmpty()
                    self.tableView.reloadData()
                    print("here")
                    
                case .failure(let error):
                    print(error)
                    
                }
            }
        } else {
            Server.shared.getFollowers {result in
                switch result {
                case .success(let UserInfo):
                    //SET THE IMAGE TO THE UI
                    self.followerData = UserInfo
                    self.tableViewSetup()
                    self.checkIfEmpty()
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
    }
    
    private func setupNavigationBar(){
        navigationItem.title = username
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButton))
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func followStateUI(){
        if followStateTapped == "followers" {
            //get data
            checkIfEmpty()
            
            followingButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            followingButton.titleLabel?.textColor = UIColor(named: "softGray")
            let bottomBorder = CALayer()
            bottomBorder.backgroundColor = UIColor(named: "softGray")?.cgColor// Set the border color
            bottomBorder.frame = CGRect(x: 0, y: followingButton.frame.height - 1, width: 500, height: 1)
            followingButton.layer.addSublayer(bottomBorder)
            
            followerButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            followerButton.titleLabel?.textColor = .black
            let bottomBorder2 = CALayer()
            bottomBorder2.backgroundColor = UIColor(named: "pink")?.cgColor// Set the border color
            bottomBorder2.frame = CGRect(x: 0, y: followerButton.frame.height - 1, width: 500, height: 1)
            followerButton.layer.addSublayer(bottomBorder2)
        } else {
            //get data
            checkIfEmpty()
            
            followingButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            followingButton.titleLabel?.textColor = .black
            let bottomBorder = CALayer()
            bottomBorder.backgroundColor = UIColor(named: "pink")?.cgColor// Set the border color
            bottomBorder.frame = CGRect(x: 0, y: followerButton.frame.height - 1, width: 500, height: 1)
            followingButton.layer.addSublayer(bottomBorder)
            
            followerButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            followerButton.titleLabel?.textColor = UIColor(named: "softGray")
            let bottomBorder2 = CALayer()
            bottomBorder2.backgroundColor = UIColor(named: "softGray")?.cgColor// Set the border color
            bottomBorder2.frame = CGRect(x: 0, y: followerButton.frame.height - 1, width: 500, height: 1)
            followerButton.layer.addSublayer(bottomBorder2)
        }
    }
    
    //BUTTON
    @objc private func backButton(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func followerTapped(_ sender: Any) {
        followStateTapped = "followers"
        followStateUI()
        tableView.reloadData()
    }
    
    @IBAction func followingTapped(_ sender: Any) {
        followStateTapped = "followings"
        followStateUI()
        tableView.reloadData()
    }
    
    private func checkIfEmpty(){
        if followStateTapped == "followers" {
            if followerData.isEmpty {
                tableView.isHidden = true
                emptyStateView.isHidden = false
                emptyStateLabel.text = "회원님을 팔로우하는 모든 사람이 \n여기에 표시됩니다."
            } else {
                tableView.isHidden = false
                emptyStateView.isHidden = true
            }
        } else {
            if followingData.isEmpty {
                tableView.isHidden = true
                emptyStateView.isHidden = false
                emptyStateLabel.text = "회원님이 팔로우하는 사람들이 \n여기에 표시됩니다."
            } else {
                tableView.isHidden = false
                emptyStateView.isHidden = true
            }
        }
    }
}

//MARK: TABLE VIEW 
extension FollowViewController: UITableViewDelegate, UITableViewDataSource {
    private func tableViewSetup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FollowStateCell", bundle: nil), forCellReuseIdentifier: "FollowStateCell")
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if followStateTapped == "followers" {
            return followerData.count
        } else {
            return followingData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowStateCell") as! FollowStateCell
        
        //followers
        if followStateTapped == "followers" {
            cell.delegate = self
            cell.selectionStyle = .none
            
            let data = followerData[indexPath.item]
            cell.configuration(img: data.profileImageURL, name: data.nickname, following: data.isFollowed)
        }
        
        //following
        else {
            cell.delegate = self
            cell.selectionStyle = .none
            
            let data = followingData[indexPath.item]
            cell.configuration(img: data.profileImageURL, name: data.nickname, following: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}
