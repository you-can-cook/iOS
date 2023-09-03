//
//  SearchViewController.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/02.
//

import UIKit
import RxCocoa
import RxSwift
import NVActivityIndicatorView

class BookmarkViewController: UIViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var emptyStateView: UIView!
    private let searchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: PROPERTY
    var activityIndicator: NVActivityIndicatorView?
    
    //index path to show in detail view
    var selectedIndexPath = 0

    var FeedData: [FeedInfo] = []
    
    private var ShowingBlockView = true
    private var isShowingBlockView = PublishSubject<Bool>()
    private var isShowingBlockViewObservable : Observable<Bool> {
        return isShowingBlockView.asObservable()
    }
    private let disposeBag = DisposeBag()
    
    
    //MARK: LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        setupData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupData()
        setObservable()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView",
           let detailVC = segue.destination as? DetailViewController {
            detailVC.index = FeedData[selectedIndexPath].id
            print("SENDING DATA>>..",  FeedData[selectedIndexPath].id)
        }
    }
    
    func refresh() {
        isShowingBlockView.onNext(true)
        print("TAAPAPAPAPAPAPPED")
    }
}

//MARK: BUTTON FUNC
extension BookmarkViewController {
    @objc private func toogleButtonTapped(){
        isShowingBlockView.onNext(!ShowingBlockView)
    
    }
}

//MARK: OBSERVABLE
extension BookmarkViewController {
    private func setObservable(){
        isShowingBlockView.subscribe(onNext: { [weak self] bool in
            guard let self = self else { return }
            //BLOCK VIEW
            if bool {
                ShowingBlockView = true
                self.collectionView.isHidden = false
                self.tableView.isHidden = true
                
                //NAVIGATION BAR
                let tableViewToogleButton = UIBarButtonItem(image: UIImage(named: "액자형"), style: .plain, target: self, action: #selector(toogleButtonTapped))
                tableViewToogleButton.tintColor = .black
                
                navigationItem.leftBarButtonItem = tableViewToogleButton
                self.collectionView.reloadData()
            }
            //CARD VIEW
            else {
                ShowingBlockView = false
                self.collectionView.isHidden = true
                self.tableView.isHidden = false
                
                //NAVIGATION BAR
                let tableViewToogleButton = UIBarButtonItem(image: UIImage(named: "카드형"), style: .plain, target: self, action: #selector(toogleButtonTapped))
                tableViewToogleButton.tintColor = .black
                
                navigationItem.leftBarButtonItem = tableViewToogleButton
                self.tableView.reloadData()
            }
            
        }).disposed(by: disposeBag)
    }
}

//MARK: UI
extension BookmarkViewController: UISearchBarDelegate {
    private func setupData(){
        activityIndicator?.startAnimating()
        
        Server.shared.getRecipeBookMark { Result in
            switch Result {
            case .success(let FeedResponse):
                print(Result)
                self.FeedData = FeedResponse.feed
                
                if self.FeedData.isEmpty {
                    self.emptyStateView.isHidden = false
                } else {
                    self.emptyStateView.isHidden = true
                    self.collectionView.reloadData()
                }
                
            case .failure(let Error):
                print(Error)
            }
            
        }
        
        activityIndicator?.stopAnimating()
        
        
    }
    
    private func setupUI(){
        setupNavigationBar()
        tableViewSetup()
        collectionViewSetup()
        
        activityIndicator = ActivityIndicator.shared.setupActivityIndicator(in: view)
    }
    
    private func setupNavigationBar(){
        navigationItem.titleView = searchBar
        searchBar.backgroundColor = .white
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.searchBarStyle = .minimal
        searchBar.text = "저장된 레시피"
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
//            textField.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
            textField.textAlignment = .center
            textField.clearButtonMode = .never
        }
        searchBar.isUserInteractionEnabled = false
        
        
        let tableViewToogleButton = UIBarButtonItem(image: UIImage(systemName: "square.stack.3d.up.fill"), style: .plain, target: self, action: nil)
        tableViewToogleButton.tintColor = .white
        let tableViewToogleButton2 = UIBarButtonItem(image: UIImage(named: "액자형"), style: .plain, target: self, action: #selector(toogleButtonTapped))
        tableViewToogleButton2.tintColor = .black
        
        navigationItem.rightBarButtonItem = tableViewToogleButton
        navigationItem.leftBarButtonItem = tableViewToogleButton2
    }
}


//MARK: COLLECTION VIEW
extension BookmarkViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func collectionViewSetup(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "FeedBoxCell", bundle: nil), forCellWithReuseIdentifier: "FeedBoxCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FeedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedBoxCell", for: indexPath) as! FeedBoxCell
        
        let url = URL(string: FeedData[indexPath.item].thumbnailURL!)
        cell.img.load(url: url!)
        
        NSLayoutConstraint.activate([
            cell.img.widthAnchor.constraint(equalToConstant: view.frame.width/3-2),
            cell.img.heightAnchor.constraint(equalToConstant: view.frame.width/3-2)
        ])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.item
        self.performSegue(withIdentifier: "showDetailView", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set the cell height to match the cellWidth so that the cell appears as a square
        return CGSize(width: (view.frame.width/3)-2, height: view.frame.width/3-2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

//MARK: TABLEVIEW
extension BookmarkViewController : UITableViewDelegate, UITableViewDataSource, FeedCellDelegate {
    func profileTapped(cell: FeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        //get other's profileID then show the profile
        
    
    }
    
    private func tableViewSetup(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        cell.delegate = self
        cell.selectionStyle = .none
        
        let data = FeedData[indexPath.item]
        
        DispatchQueue.main.async {
            cell.configuration(
                userImg: data.author.profileImageURL,
                username: data.author.nickname,
                following: data.author.following,
                thumbnailImg: data.thumbnailURL,
                title: data.title,
                bookmarkCount: data.totalBookmarkCount,
                isBookmarked: data.bookmarked,
                cookingTime: data.totalCookTimeInSeconds,
                tools: data.cookwares,
                level: data.difficulty,
                stars: data.averageRating ?? 0,
                isFollowing: data.author.following
            )
            if data.author.following {
                cell.followingButton.isHidden = true
            } else {
                cell.followingButton.isHidden = false
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.item
        self.performSegue(withIdentifier: "showDetailView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380.0
    }
    
}
