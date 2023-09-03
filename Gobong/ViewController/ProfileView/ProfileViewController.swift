//
//  ProfileViewController.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/04.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    var selectedIndexPath = 0
    var userInfo: UserInfoResponse!
    
    var FeedData: [FeedInfo] = []
    
    var followStateTapped = ""
    private var ShowingBlockView = true
    private var isShowingBlockView = PublishSubject<Bool>()
    private var isShowingBlockViewObservable : Observable<Bool> {
        return isShowingBlockView.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    //MARK: LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupData()
        setObservable()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView",
           let detailVC = segue.destination as? DetailViewController {
            detailVC.index = FeedData[selectedIndexPath].id
            print("SENDING DATA>>..",  FeedData[selectedIndexPath].id)
        }
        
        if segue.identifier == "showFollowView" {
            if let vc = segue.destination as? FollowViewController {
                vc.followStateTapped = followStateTapped
                vc.username = userInfo.nickname
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//MARK: BUTTON FUNC
extension ProfileViewController {
    @objc private func settingsButtonTapped(){
        performSegue(withIdentifier: "showSettingsView", sender: self)
    }

    @objc private func toogleButtonTapped(){
        isShowingBlockView.onNext(!ShowingBlockView)
    }
}

//MARK: OBSERVABLE
extension ProfileViewController {
    private func setObservable(){
        isShowingBlockView.subscribe(onNext: { [weak self] bool in
            guard let self = self else { return }
            if bool {
                ShowingBlockView = true
                mainTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                
                //NAVIGATION BAR
                let tableViewToogleButton = UIBarButtonItem(image: UIImage(named: "액자형"), style: .plain, target: self, action: #selector(toogleButtonTapped))
                tableViewToogleButton.tintColor = .black
                
                navigationItem.leftBarButtonItem = tableViewToogleButton
            } else {
                ShowingBlockView = false
                mainTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                
                //NAVIGATION BAR
                let tableViewToogleButton = UIBarButtonItem(image: UIImage(named: "카드형"), style: .plain, target: self, action: #selector(toogleButtonTapped))
                tableViewToogleButton.tintColor = .black
                
                navigationItem.leftBarButtonItem = tableViewToogleButton
            }

        }).disposed(by: disposeBag)
    }
}

//MARK: DELEGATE
extension ProfileViewController: UserInformationDelegate, profileFeedDelegete {
    //SHOW DETAILED POST
    func cellTapped(cell: ProfileFeedCell) {
        selectedIndexPath = cell.selectedIndexPath
        self.performSegue(withIdentifier: "showDetailView", sender: self)
    }
    
    //SHOW FOLLOWING VIEW
    func followingTapped(controller: UserInformationCell) {
        followStateTapped = "followings"
        performSegue(withIdentifier: "showFollowView", sender: self)
    }
    
    //SHOW FOLLOWERS VIEW
    func followersTapped(controller: UserInformationCell) {
        followStateTapped = "followers"
        performSegue(withIdentifier: "showFollowView", sender: self)
    }
}

//MARK: DATA
extension ProfileViewController {
    private func setupData(){
        Server.shared.getUserInfo { result in
            switch result {
            case .success(let UserInfoResponse):
                self.userInfo = UserInfoResponse
                //SET THE IMAGE TO THE UI
                self.setupUI()
                self.setupMainTableView()
            case .failure(let error):
                print(error)
                
                let alert = UIAlertController(title: "데이터 찾을 수 없습니다", message: "잠시 후 다시 시도 해보세요", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "네", style: .default)
                alert.addAction(okButton)
                
                self.present(alert, animated: true)
            }
        }
        
        Server.shared.getMyFeed { Result in
            switch Result {
            case .success(let FeedResponse):
                print(Result)
                self.FeedData = FeedResponse.feed
                
//                if self.FeedData.isEmpty {
//                    self.emptyStateView.isHidden = false
//                } else {
//                    self.emptyStateView.isHidden = true
//                    self.tableView.reloadData()
//                }
                
                self.mainTableView.reloadData()
                
            case .failure(let Error):
                print(Error)
            }
        }
        
    }
}

//MARK: UI
extension ProfileViewController: UISearchBarDelegate{
    private func setupUI(){
        setupNavigationBar()
    }

    private func setupNavigationBar(){
        let tableViewToogleButton = UIBarButtonItem(image: UIImage(named: "액자형"), style: .plain, target: self, action: #selector(toogleButtonTapped))
        tableViewToogleButton.tintColor = .black
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        settingsButton.tintColor = .black

        navigationItem.leftBarButtonItem = tableViewToogleButton
        
        //IF MY PROFILE
        navigationItem.rightBarButtonItem = settingsButton
        
        //ELSE CHANGE THE SETTINGS TO FOLLOW BUTTON 
        
        navigationItem.title = userInfo.nickname
    }
}

//MARK: TABLE VIEW
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    private func setupMainTableView(){
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.register(UINib(nibName: "UserInformationCell", bundle: nil), forCellReuseIdentifier: "UserInformationCell")
        mainTableView.register(ProfileFeedCell.self, forCellReuseIdentifier: "ProfileFeedCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //USER INFORMATION
        if indexPath.item == 0 {
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "UserInformationCell") as! UserInformationCell
            
            cell.configuration(img: userInfo.profileImageURL, recipeCount: userInfo.recipeNumber, followerCount: userInfo.followerNumber, followingCount: userInfo.followingNumber)
            cell.selectionStyle = .none
            cell.delegate = self
            
            return cell
        } else {
            //IF THE FEED IS EMPTY
            if FeedData.isEmpty {
                let cell = mainTableView.dequeueReusableCell(withIdentifier: "ProfileFeedCell") as! ProfileFeedCell
                cell.configEmpty()
                cell.delegate = self
                cell.selectionStyle = .none
                
                return cell
                
            //ELSE IF THE FEED IS NOT EMPTY
            } else {
                //IF SHOWING BLOCK VIEW
                if ShowingBlockView {
                    let cell = mainTableView.dequeueReusableCell(withIdentifier: "ProfileFeedCell") as! ProfileFeedCell
                    cell.FeedData = FeedData
                    cell.configuration(isShowingBlock: ShowingBlockView)
                    cell.collectionView.reloadData()
                    cell.delegate = self
                    
                    return cell
                
                //IF SHOWING CARD VIEW 
                } else {
                    let cell = mainTableView.dequeueReusableCell(withIdentifier: "ProfileFeedCell") as! ProfileFeedCell
                    cell.FeedData = FeedData
                    cell.configuration(isShowingBlock: ShowingBlockView)
                    cell.tableView.reloadData()
                    cell.delegate = self
                    
                    return cell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return 180
        } else {
            //if empty
            if FeedData.isEmpty {
                return view.bounds.height - 500
            } else {
                if ShowingBlockView {
                    return CGFloat(FeedData.count) * tableView.bounds.width / 3 - 2
                } else {
                    // Calculate the height based on the dummy data count and cell height
                    let cellHeight: CGFloat = 314 // Adjust the expected cell height
                    return CGFloat(FeedData.count) * cellHeight
                }
            }
        }
    }

}


