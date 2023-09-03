//
//  ProfileFeedCell.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/06.
//a

import UIKit

protocol profileFeedDelegete: Any {
    func cellTapped(cell: ProfileFeedCell)
}

class ProfileFeedCell: UITableViewCell {
    
    var FeedData: [FeedInfo] = []
    var selectedIndexPath = 0
    
    var delegate: profileFeedDelegete?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addEmptyState(){
        let emptyUI = UIView()
        emptyUI.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fill
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "profileEmpty")
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "작성된 레시피가 없습니다."
        label.textColor = UIColor(named: "gray")
        label.font = UIFont.systemFont(ofSize: 14)
        
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
        
        emptyUI.addSubview(stack)
        
        contentView.addSubview(emptyUI)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: emptyUI.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: emptyUI.centerXAnchor),
            
            emptyUI.topAnchor.constraint(equalTo: contentView.topAnchor),
            emptyUI.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emptyUI.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emptyUI.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        
    }
    
    private func addCollectionView(){
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        collectionViewSetup()
    }
    
    private func addTableView(){
        contentView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        tableViewSetup()
    }
            
    func removeAllSubviews() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func configuration(isShowingBlock: Bool){
        if isShowingBlock{
            removeAllSubviews()
            addCollectionView()
        } else {
            removeAllSubviews()
            addTableView()
        }
    }
    
    func configEmpty(){
        removeAllSubviews()
        addEmptyState()
    }
}

//MARK: COLLECTION VIEW
extension ProfileFeedCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func collectionViewSetup(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "FeedBoxCell", bundle: nil), forCellWithReuseIdentifier: "FeedBoxCell")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FeedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.item
        delegate?.cellTapped(cell: self)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedBoxCell", for: indexPath) as! FeedBoxCell

        let url = URL(string:  FeedData[indexPath.item].thumbnailURL!)
        cell.img.load(url: url!)
    
        NSLayoutConstraint.activate([
            cell.img.widthAnchor.constraint(equalToConstant: contentView.frame.width/3-2),
            cell.img.heightAnchor.constraint(equalToConstant: contentView.frame.width/3-2)
        ])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set the cell height to match the cellWidth so that the cell appears as a square
        return CGSize(width: (contentView.frame.width/3)-2, height: contentView.frame.width/3-2)
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
extension ProfileFeedCell : UITableViewDelegate, UITableViewDataSource {
    private func tableViewSetup(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.item
        delegate?.cellTapped(cell: self)
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell

//        cell.delegate = self
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
        cell.followingButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)

        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380.0
    }

}

