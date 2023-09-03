//
//  SearchViewController.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/02.
//

import UIKit
import RxCocoa
import RxSwift

struct FilterModel {
    var sort: String
    var level: String
    var time: Int
    var star: Int
    var tools: [String]
    
    func checkFilter() -> Bool {
        if level != nil || time != nil || star != nil || tools.count != nil {
            return true
        }
        return false
    }
}

class SearchViewController: UIViewController, UITabBarControllerDelegate {
    
    //property
    private let searchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var EmptyStateView: UIView!
    
    var selectedIndexPath = 0
    
    var FeedData: [FeedInfo] = []
    
    var filteredData: [FeedInfo] = []
    
    var isSearching = false
    var filter: FilterModel?
    
    private var ShowingBlockView = true
    private var isShowingBlockView = PublishSubject<Bool>()
    private var isShowingBlockViewObservable : Observable<Bool> {
        return isShowingBlockView.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    //MARK: LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        
        isShowingBlockView.onNext(true)
    }
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        setupData()
        setupUI()
        setObservable()
        setupSearchBar()
        isShowingBlockView.onNext(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView",
           let detailVC = segue.destination as? DetailViewController {
            detailVC.index = FeedData[selectedIndexPath].id
            print("SENDING DATA>>..",  FeedData[selectedIndexPath].id)
        }
        if segue.identifier == "showFilterView",
           let VC = segue.destination as? FilterViewController {
            VC.searchBarText = searchBar.text ?? ""
            if filter != nil {
                VC.lastFilter = filter
            }
            VC.delegate = self
        }
    }
    func refresh() {
        isShowingBlockView.onNext(true)
        print("TAAPAPAPAPAPAPPED")
    }
    
}

//MARK: DELEGATE
extension SearchViewController: FilterDelegate {
    func passFilter(controller: FilterViewController) {
        isSearching = false
        searchBar.resignFirstResponder()
        filter = FilterModel(sort: controller.selectedSort ?? "", level: controller.levelSelected ?? "", time: Int(controller.stepSlider.index) * 5, star: controller.starSelected ?? 0, tools: controller.tools )
        
        Server.shared.filter(query: controller.searchBar.text, filterType: controller.selectedSort, difficulty: controller.levelSelected, maxTotalCookTime: Int(controller.stepSlider.index) * 5 * 60, minRating: controller.starSelected, cookwares: controller.tools) { result in
            switch result {
            case .success(let data):
                print(data)
                self.filteredData = data.feed
                self.isShowingBlockView.onNext(true)
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: BUTTON FUNC
extension SearchViewController {
    @objc private func filterButtonTapped(){
        performSegue(withIdentifier: "showFilterView", sender: self)
    }
    
    @objc private func toogleButtonTapped(){
        isShowingBlockView.onNext(!ShowingBlockView)
    
    }
}

//MARK: OBSERVABLE
extension SearchViewController {
    private func setObservable(){
        isShowingBlockView.subscribe(onNext: { [weak self] bool in
            guard let self = self else { return }
            if bool {
                ShowingBlockView = true
                self.collectionView.isHidden = false
                self.tableView.isHidden = true
                navigationItem.rightBarButtonItem = nil
                
                //NAVIGATION BAR
                let filterButton = UIBarButtonItem(image: UIImage(named: "Filter"), style: .plain, target: self, action: #selector(filterButtonTapped))
                
                if filter != nil {
                    if filter!.checkFilter() {
                        filterButton.tintColor = UIColor(named: "pink")
                    } else {
                        filterButton.tintColor = .black
                    }
                } else {
                    filterButton.tintColor = .black
                }

                let tableViewToogleButton = UIBarButtonItem(image: UIImage(named: "액자형"), style: .plain, target: self, action: #selector(toogleButtonTapped))
                tableViewToogleButton.tintColor = .black
                
                navigationItem.rightBarButtonItems = [filterButton]
                navigationItem.leftBarButtonItem = tableViewToogleButton
                
                self.collectionView.reloadData()
            
            //SHOW CARD VIEW
            } else {
                ShowingBlockView = false
                self.collectionView.isHidden = true
                self.tableView.isHidden = false
                
                //NAVIGATION BAR
                let filterButton = UIBarButtonItem(image: UIImage(named: "Filter"), style: .plain, target: self, action: #selector(filterButtonTapped))
                
                if filter != nil {
                    if filter!.checkFilter() {
                        filterButton.tintColor = UIColor(named: "pink")
                    } else {
                        filterButton.tintColor = .black
                    }
                } else {
                    filterButton.tintColor = .black
                }

                let tableViewToogleButton = UIBarButtonItem(image: UIImage(named: "카드형"), style: .plain, target: self, action: #selector(toogleButtonTapped))
                tableViewToogleButton.tintColor = .black
                
                navigationItem.rightBarButtonItems = [filterButton]
                navigationItem.leftBarButtonItem = tableViewToogleButton
                
                self.tableView.reloadData()
            }
            
        }).disposed(by: disposeBag)
    }
}

//MARK: DATA
extension SearchViewController {
    private func setupData(){
        
        Server.shared.getRecipeFeed { Result in
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
                self.collectionView.reloadData()
                
            case .failure(let Error):
                print(Error)
            }
            
        }
        
    }
}

//MARK: UI
extension SearchViewController {
    private func setupUI(){
        searchBar.tintColor = .black
        
        setupNavigationBar()
        tableViewSetup()
        collectionViewSetup()
        setupSearchBar()
    }
    
    private func setupNavigationBar(){
        navigationItem.titleView = searchBar
        
        let filterButton = UIBarButtonItem(image: UIImage(named: "Filter"), style: .plain, target: self, action: #selector(filterButtonTapped))
        filterButton.tintColor = .black

        let tableViewToogleButton = UIBarButtonItem(image: UIImage(named: "카드형"), style: .plain, target: self, action: #selector(toogleButtonTapped))
        tableViewToogleButton.tintColor = .black
        
        navigationItem.rightBarButtonItems = [filterButton]
        navigationItem.leftBarButtonItem = tableViewToogleButton
    }
}

//MARK: SEARCH BAR
extension SearchViewController: UISearchBarDelegate {
    private func setupSearchBar(){
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.delegate = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        collectionView.isHidden = true
        tableView.isHidden = true
        
        //CHANGE NAVIGATION ITEM WHEN SEARCH BAR IS FOCUSED
        navigationItem.leftBarButtonItem = nil
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(doneSearching))
        cancelButton.tintColor = .black
        
        let filterButton = UIBarButtonItem(image: UIImage(named: "Filter"), style: .plain, target: self, action: #selector(filterButtonTapped))
        
        if filter != nil {
            if filter!.checkFilter() {
                filterButton.tintColor = UIColor(named: "pink")
            }
        } else {
            filterButton.tintColor = .black
        }
        
        navigationItem.rightBarButtonItems = [cancelButton, filterButton]
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //search for the data
        
        //show it with block view first..
        isShowingBlockView.onNext(true)
        searchBar.resignFirstResponder()
    }
    
    //DONE SEARCHING, INIT THE FILTER.
    @objc private func doneSearching(){
        isSearching = false
        searchBar.resignFirstResponder()
        filter = nil
        isShowingBlockView.onNext(true)
    }
}

//MARK: COLLECTION VIEW
extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func collectionViewSetup(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "FeedBoxCell", bundle: nil), forCellWithReuseIdentifier: "FeedBoxCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filter != nil {
            if filter!.checkFilter() {
                return filteredData.count
            }
        }
        
        return FeedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedBoxCell", for: indexPath) as! FeedBoxCell
        
        if filter != nil {
            if filter!.checkFilter() {
                let url = URL(string: filteredData[indexPath.item].thumbnailURL!)
                cell.img.load(url: url!)
            }
        } else {
            let url = URL(string: FeedData[indexPath.item].thumbnailURL!)
            cell.img.load(url: url!)
        }
        
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
extension SearchViewController : UITableViewDelegate, UITableViewDataSource, FeedCellDelegate {
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
        if filter != nil {
            return filteredData.count
        }
        return FeedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        
        if filter != nil {
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
            cell.followingButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        }
        
        else {
            let data = filteredData[indexPath.item]
            
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
            
            cell.followingButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        }
        
        cell.delegate = self
        cell.selectionStyle = .none
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
