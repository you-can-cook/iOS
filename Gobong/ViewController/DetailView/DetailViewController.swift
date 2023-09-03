//
//  DetailViewController.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/04.
//

import UIKit
import RxSwift
import RxCocoa

struct dummyHowTo {
    var minute: String
    var second: String
    var tool: [String]
    var img: UIImage?
    var description: String
}

//POST'S DETAILED INFORMATION
class DetailViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var labelSizeCache: [String: CGSize] = [:]
    
    var index: Int!
    var information: DetailResponse!
    var hashTag: [String] = []
    var recipeInformation: [RecipeDetailSummary] = [
    ]
    
    //table view height 관련 property
    var isFolded = [Bool]()
    var collectionViewHeight = 0
    
    //IF THERE IS REVIEW STAR PROPERTY
    var star = 0
    
    
    //MARK: LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPopUpReview",
           let vc = segue.destination as? ReviewPopUpViewController {
            vc.delegate = self
            vc.id = information.id
            if star > 0 {
                vc.star = star
                vc.sendedStar = star
            }
        }
    }
    
    //데이터 처리 
    private func setupData(){
        Server.shared.getPostDetail(recipeId: index) { Result in
            switch Result {
            case .success(let success):
                print(success)
                self.information = success
                self.hashTag = success.ingredients
                self.recipeInformation = success.recipeDetails
                self.setupUI()
                self.tableViewSetup()
                
                self.isFolded = Array(repeating: true, count: self.recipeInformation.count)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    private func setupData2(){
        Server.shared.getPostDetail(recipeId: index) { Result in
            switch Result {
            case .success(let success):
                print(success)
                self.information = success
                self.hashTag = success.ingredients
                self.recipeInformation = success.recipeDetails
                self.setupUI()
                self.tableViewSetup()
                
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    private func setupData3(){
        Server.shared.getPostDetail(recipeId: index) { Result in
            switch Result {
            case .success(let success):
                print(success)
                self.information = success
                self.hashTag = success.ingredients
                self.recipeInformation = success.recipeDetails
                self.setupUI()
                self.tableViewSetup()
                
                self.navigationBarSetup()
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
}

//MARK: UI
extension DetailViewController {
    private func setupUI(){
        navigationBarSetup()
        navigationController?.navigationBar.isHidden = false
    }
    
    private func navigationBarSetup(){
        navigationItem.title = information.summary.title
        
        let backItemButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backItemButton.tintColor = .black
       
        //SAVE OR DELETE BASED ON MY OR OTHER'S POST
        if information.summary.author.myself {
            let saveItemButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteButtonTapped))
            saveItemButton.tintColor = .black
            
            navigationItem.rightBarButtonItem = saveItemButton
        } else {
            if !information.summary.bookmarked {
                let saveItemButton = UIBarButtonItem(image: UIImage(named: "BMark"), style: .plain, target: self, action: #selector(saveButtonTapped))
                saveItemButton.tintColor = .black
                
                navigationItem.rightBarButtonItem = saveItemButton
                
            } else {
                let saveItemButton = UIBarButtonItem(image: UIImage(named: "BMarkOk"), style: .plain, target: self, action: #selector(unsaveButtonTapped))
                saveItemButton.tintColor = .black
                
                navigationItem.rightBarButtonItem = saveItemButton
            }
           
            
            
        }
        
        navigationItem.leftBarButtonItem = backItemButton
    }
    
    //NAVIGATION BUTTON
    @objc private func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped(){
        Server.shared.bookMark(id: information.id) {
            self.setupData3()
        }
    }
    
    @objc private func unsaveButtonTapped(){
        Server.shared.cancelBookMark(id: information.id) {
            self.setupData3()
        }
    }
    
    @objc private func deleteButtonTapped(){
        Server.shared.deletePost(id: information.id) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

//MARK: TABLE VIEW
extension DetailViewController: UITableViewDelegate, UITableViewDataSource, RecipeCellDelegate, ReviewDelegate, ReviewPopUpDelegate, DetailTitleDelegate {
    func followingTapped(cell: DetailTitleCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if information.summary.author.following {
            Server.shared.unfollowUser(id: information.summary.author.id) { [self] in
                self.setupData2()
                
            }
        } else {
            Server.shared.followUser(id: information.summary.author.id) {
                self.setupData2()
            }
        }
    }
    
    func profileTapped(cell: DetailTitleCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        //get other's profileID then show the profile
        
    
    }
    
    //GET DATA FROM POPUP REVIEW VIEW
    func reviewTapped(controller: ReviewPopUpViewController) {
        Server.shared.getPostDetail(recipeId: index) { Result in
            switch Result {
            case .success(let success):
                print(success)
                self.information = success
                self.tableView.reloadRows(at: [IndexPath(row: self.recipeInformation.count+2, section: 0)], with: .none)
            case .failure(let error):
                print(error)
            }
        }
        
        //리뷰 처리 !! 
    }
    
    //REVIEW BUTTON TAPPED
    func reviewTapped(cell: ReviewTableViewCell) {
         performSegue(withIdentifier: "showPopUpReview", sender: self)
    }
    
    //WHEN COLLECTION VIEW TAPPED FOLD AND UNFOLD THE CELL
    func collectionViewTapped(sender: RecipeCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        tableView(tableView, didSelectRowAt: indexPath)
    }
    
    //MARK: TABLE VIEW INIT
    func tableViewSetup(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "DetailTitleCell", bundle: nil), forCellReuseIdentifier: "DetailTitleCell")
        tableView.register(HashtagCell.self, forCellReuseIdentifier: "HashtagCell")
        tableView.register(RecipeCell.self, forCellReuseIdentifier: "RecipeCell")
        tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeInformation.count + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //REVIEW CELL (LAST)
        if indexPath.item == recipeInformation.count + 2 {
            print("asdfasdf")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell") as! ReviewTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            
            if information.myRate > 0 {
                star = information.myRate
                cell.isReviewed(star)
            }
            else {
                cell.isNotReviewed()
            }
//
            return cell
            
            //PICTURE AND 요약 정보 OF THE POST CELL (1'ST)
        } else if indexPath.item == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTitleCell", for: indexPath) as! DetailTitleCell
            
            cell.configuration(userImg: information.summary.author.profileImageURL , username: information.summary.author.nickname, following: information.summary.author.following, thumbnailImg: information.summary.thumbnailURL!, title: information.summary.title, bookmarkCount: information.summary.totalBookmarkCount, cookingTime: information.summary.totalCookTimeInSeconds, tools: information.summary.cookwares, level: information.summary.difficulty, stars: information.summary.averageRating)
            cell.selectionStyle = .none
            
            if information.summary.author.myself {
                cell.followingButton.isHidden = true
            } else {
                cell.followingButton.isHidden = false
            }
           
            cell.delegate = self
            cell.backgroundColor = .brown
            return cell
        }
        
        // EXPLANATION AND INGREDIENTS CELL (2'ND)
        else if indexPath.item == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HashtagCell", for: indexPath) as! HashtagCell
            cell.titleLabel.text = information.introduction
            cell.setupCollectionView(dataSource: self, delegate: self)
            cell.selectionStyle = .none
            
            return cell
        }
        
        // 단계'S CELL
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
            let data = recipeInformation[indexPath.item-2]
            
            let minute = data.cookTimeInSeconds / 60
            let second = data.cookTimeInSeconds % 60
    
            let time = "\(minute)분\(second)초"
            
            cell.configuration2(step: indexPath.item-1, time: time, tool: data.cookwares, image: data.imageURL, description: data.content, isFolded: isFolded[indexPath.item-2])
            cell.delegate = self
            
            if !isFolded[indexPath.item-2] {
                cell.toggleImageViewVisibility2(isFolded: isFolded[indexPath.item-2], image: data.imageURL)
                cell.informationView.layer.borderColor = UIColor(named: "pink")?.cgColor
                cell.dottedLine.backgroundColor = UIColor(named: "pink")
                cell.stepLabelBackground.tintColor = UIColor(named: "pink")
                cell.stepLabel.textColor = .white
            } else {
                cell.toggleImageViewVisibility2(isFolded: isFolded[indexPath.item-2], image: data.imageURL)
                cell.informationView.layer.borderColor = UIColor(named: "gray")?.cgColor
                cell.dottedLine.backgroundColor = UIColor(named: "gray")
                cell.stepLabelBackground.tintColor = UIColor(named: "softGray")
                cell.stepLabel.textColor = UIColor(named: "gray")
            }
            
            //IF ITS THE LAST STEP HIDE THE DOTTED LINE
            if indexPath.item - 1 == recipeInformation.count  {
                cell.dottedLine.isHidden = true
            } else {
                cell.dottedLine.isHidden = false
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // REVIEW CELL (LAST)
        if indexPath.item == recipeInformation.count + 2 {
            return 158
        }
        
        // POST INFORMATION (1'ST)
        else if indexPath.item == 0 {
            return 344
        }
        
        // INGREDIENT AND EXPLANATION (2'ND)
        else if indexPath.item == 1{
            var addLine = 0
            var currentWidth: CGFloat = 0.0
            let collectionViewWidth = tableView.bounds.width - CGFloat((hashTag.count * 10) + 32)
            for i in hashTag {
                currentWidth += CGFloat(calculateLabelSize(text: i).width)
                if currentWidth > collectionViewWidth {
                    addLine += 30
                    currentWidth = CGFloat(calculateLabelSize(text: i).width)
                }
            }
            return CGFloat(100 + addLine)
            
        //STEP CELL
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
            cell.layoutIfNeeded()
            let data = recipeInformation[indexPath.item-2]
            
            let minute = data.cookTimeInSeconds / 6
            let second = data.cookTimeInSeconds % 6
            let time = "\(minute)분\(second)초"
            
            var firstline: CGFloat = calculateLabelSize(text: time).width
            firstline += data.cookwares.map({calculateLabelSize(text: $0).width}).reduce(0, +)
//            firstline += CGFloat(1 * 12) + 32
            firstline += CGFloat(data.cookwares.count * 12) + 32
            
            if firstline/(view.bounds.width/1.5) > 1 {
                let line = firstline/(view.bounds.width/1.8)
                firstline = ceil(line) * 31
            } else {
                firstline = 30
            }
            
//            var imageHeight: CGFloat = 0
            let last = calculateLabelSizeRecipe(text: data.content).height
            if !isFolded[indexPath.item-2] {
                if data.imageURL != nil {
                    return CGFloat(firstline) + 130 + last + 80
                }
            }
            
            return CGFloat(firstline) + 0 + last + 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item > 1  && indexPath.item != recipeInformation.count + 2 {
            let allTrueValues = Array(repeating: true, count: isFolded.count)
            let lastFolded = isFolded.firstIndex(where: {$0 == false})
            
            isFolded = allTrueValues
            isFolded[indexPath.item-2].toggle()
            
            if let lastFolded = lastFolded {
                tableView.reloadRows(at: [indexPath, IndexPath(row: lastFolded+2, section: 0)], with: .automatic)
            } else {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    //CALCULATE FOR STEP'S HEIGHT
    func calculateLabelSizeRecipe(text: String) -> CGSize {
        if let cachedSize = labelSizeCache[text] {
            return cachedSize
        }
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let attributes = [NSAttributedString.Key.font: label.font!]
        let size = CGSize(width: CGFloat(view.bounds.width/1.3), height: .greatestFiniteMagnitude)
        
        let boundingRect = (text as NSString).boundingRect(
            with: size,
            options: options,
            attributes: attributes,
            context: nil
        )
        
        let calculatedSize = boundingRect.size
        labelSizeCache[text] = calculatedSize
        return calculatedSize
    }
    
}

//MARK: UI COLLECTION VIEW (INGREDIENTS // HASHTAG)
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hashTag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashtagCollectionCell", for: indexPath) as! HashtagCollectionCell
        cell.setText("\(hashTag[indexPath.item])")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelSize = calculateLabelSize(text: hashTag[indexPath.item])
        return CGSize(width: labelSize.width + 24, height: labelSize.height + 16)
    }
    
    //CALCULATING FOR INGREDIENT'S HEIGHT
    func calculateLabelSize(text: String) -> CGSize {
        if let cachedSize = labelSizeCache[text] {
            return cachedSize
        }
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = UIFont.systemFont(ofSize: 10)
        label.sizeToFit()
        let calculatedSize = label.frame.size
        labelSizeCache[text] = calculatedSize // Cache the calculated size
        return calculatedSize
    }
}
