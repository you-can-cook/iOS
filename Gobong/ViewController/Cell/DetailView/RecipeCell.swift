//
//  RecipeCell.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/06.
//

import UIKit
import AlignedCollectionViewFlowLayout
import Kingfisher

protocol RecipeCellDelegate : Any {
    func collectionViewTapped(sender: RecipeCell)
}

class RecipeCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: RecipeCellDelegate?
    var tools = [String]()
    
    let stepLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor(named: "darkGray")
        return label
    }()
    
    let stepLabelBackground: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "작성 단계")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = UIColor(named: "softGray")
        
        return image
    }()
    
    let collectionView: SelfSizingCollectionView = {
        let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        alignedFlowLayout.minimumInteritemSpacing = 8
        alignedFlowLayout.minimumLineSpacing = 0
        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: alignedFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let descriptionLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let UIimage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 4
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let dottedLine: DashedLineView = {
        let view = DashedLineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstLineView = UIView()
    
    let informationView = UIView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewTapped)))
    }
    
    @objc func collectionViewTapped(){
        delegate?.collectionViewTapped(sender: self)
    }
    
    private func setupUI(){
        //collection view setup
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HashtagCollectionCell.self, forCellWithReuseIdentifier: "HashtagCollectionCell")
        collectionView.collectionViewLayout.invalidateLayout()
        
        //====
        let mainUIView = UIView()
        mainUIView.translatesAutoresizingMaskIntoConstraints = false
        
        let subMainView = UIView()
        subMainView.translatesAutoresizingMaskIntoConstraints = false
        
        let stepView = UIView()
        stepView.translatesAutoresizingMaskIntoConstraints = false
        
        informationView.translatesAutoresizingMaskIntoConstraints = false
        informationView.layer.borderWidth = 1
        informationView.layer.borderColor = UIColor(named: "darkGray")?.cgColor
        
        firstLineView.translatesAutoresizingMaskIntoConstraints = false
        
        subMainView.addSubview(stepView)
        subMainView.addSubview(informationView)
        
        stepView.addSubview(stepLabelBackground)
        stepView.addSubview(stepLabel)
        
        firstLineView.addSubview(collectionView)
        
        informationView.addSubview(firstLineView)
        informationView.addSubview(UIimage)
        informationView.addSubview(descriptionLabel)
        
        descriptionLabel.backgroundColor = .white
        
        //left side
        NSLayoutConstraint.activate([
            stepLabelBackground.leadingAnchor.constraint(equalTo: stepView.leadingAnchor),
            stepLabelBackground.topAnchor.constraint(equalTo: stepView.topAnchor),
            stepLabelBackground.trailingAnchor.constraint(equalTo: stepView.trailingAnchor),
            stepLabelBackground.bottomAnchor.constraint(equalTo: stepView.bottomAnchor),
            
            stepLabel.centerXAnchor.constraint(equalTo: stepView.centerXAnchor, constant: -3),
            stepLabel.centerYAnchor.constraint(equalTo: stepView.centerYAnchor),
        ])
        
        //right side
        NSLayoutConstraint.activate([
            stepView.leadingAnchor.constraint(equalTo: subMainView.leadingAnchor, constant: 0),
            stepView.topAnchor.constraint(equalTo: subMainView.topAnchor, constant: 0),
            stepView.widthAnchor.constraint(equalToConstant: 48),
            
            informationView.leadingAnchor.constraint(equalTo: stepView.trailingAnchor, constant: 15),
            informationView.topAnchor.constraint(equalTo: subMainView.topAnchor, constant: 0),
            informationView.trailingAnchor.constraint(equalTo: subMainView.trailingAnchor, constant: 0),
            informationView.bottomAnchor.constraint(equalTo: subMainView.bottomAnchor, constant: 15),
//
            firstLineView.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 12),
            firstLineView.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -12),
            firstLineView.topAnchor.constraint(equalTo: informationView.topAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: firstLineView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: firstLineView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: firstLineView.topAnchor, constant: 6),
            
        ])
        
        NSLayoutConstraint.activate([
            UIimage.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 12),
            UIimage.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -12),
            UIimage.heightAnchor.constraint(lessThanOrEqualToConstant: 130),
            UIimage.widthAnchor.constraint(equalTo: informationView.widthAnchor, constant: -24),
            UIimage.topAnchor.constraint(equalTo: firstLineView.bottomAnchor, constant: 5),
            UIimage.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -23),
            
            
            descriptionLabel.topAnchor.constraint(equalTo: UIimage.bottomAnchor, constant: 23),
            descriptionLabel.bottomAnchor.constraint(equalTo: informationView.bottomAnchor, constant: -12),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -12)
            
            
        ])
        
        mainUIView.addSubview(subMainView)
        NSLayoutConstraint.activate([
            subMainView.leadingAnchor.constraint(equalTo: mainUIView.leadingAnchor, constant: 16),
            subMainView.topAnchor.constraint(equalTo: mainUIView.topAnchor, constant: 5),
            subMainView.trailingAnchor.constraint(equalTo: mainUIView.trailingAnchor, constant: -16),
            subMainView.bottomAnchor.constraint(equalTo: mainUIView.bottomAnchor, constant: -24)
        ])
        
        
        dottedLine.backgroundColor = UIColor(named: "gray")
        
        mainUIView.addSubview(dottedLine)
        NSLayoutConstraint.activate([
            dottedLine.topAnchor.constraint(equalTo: stepView.bottomAnchor),
            dottedLine.leadingAnchor.constraint(equalTo: stepView.centerXAnchor, constant: -3),
            dottedLine.bottomAnchor.constraint(equalTo: mainUIView.bottomAnchor),
            dottedLine.widthAnchor.constraint(equalToConstant: 1)
        ])
        
        contentView.addSubview(mainUIView)
        
        NSLayoutConstraint.activate([
            mainUIView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            mainUIView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            mainUIView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            mainUIView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
        collectionView.invalidateIntrinsicContentSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuration(step: Int, time: String, tool: [String], image: UIImage?, description: String, isFolded: Bool) {
        
        stepLabel.text = "\(step)단계"
        
        tools.append(time)
        tools.append(contentsOf: tool)
        
        collectionView.reloadData()
        
        if !isFolded{
            if image != nil{
                UIimage.isHidden = false
                UIimage.image = image
                
            } else {
                UIimage.isHidden = true
            }
        } else {
            UIimage.isHidden = true
        }
        descriptionLabel.text = description
    }
    
    func configuration2(step: Int, time: String, tool: [String], image: String?, description: String, isFolded: Bool) {
        
        stepLabel.text = "\(step)단계"
        
        tools.append(time)
        
        for i in tool {
            tools.append(CookingTools.caseFromEng(i)?.rawValue ?? "--")
            print(CookingTools.caseFromEng(i)?.rawValue)
        }
        
        collectionView.reloadData()
        
        if !isFolded{
            if image != nil{
                UIimage.isHidden = false
                let url = URL(string: image!)
                UIimage.load(url: url!)
                
            } else {
                UIimage.isHidden = true
            }
        } else {
            UIimage.isHidden = true
        }
        descriptionLabel.text = description
    }
    
    func toggleImageViewVisibility(isFolded: Bool, image: UIImage?){
        if !isFolded {
            if image != nil{
                UIimage.isHidden = false
                UIimage.image = UIImage(named: "dummyImg") ?? UIImage(named: "dummyImg")
            } else {
                UIimage.isHidden = true
            }
        } else {
            UIimage.isHidden = true
        }
    }
    
    func toggleImageViewVisibility2(isFolded: Bool, image: String?){
        if !isFolded {
            if image != nil{
                UIimage.isHidden = false
                let url = URL(string: image!)
                UIimage.load(url: url!)
                
            } else {
                UIimage.isHidden = true
            }
        } else {
            UIimage.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashtagCollectionCell", for: indexPath) as! HashtagCollectionCell
        cell.setText2("\(tools[indexPath.item])")
        cell.label.backgroundColor = UIColor(named: "softGray")
        cell.label.textColor = UIColor(named: "darkGray")
        cell.label.layer.borderWidth = 0
        cell.label.font = UIFont.systemFont(ofSize: 12)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelSize = calculateLabelSize(text: tools[indexPath.item])
        return CGSize(width: labelSize.width + 24, height: labelSize.height + 20)
    }
    
    func calculateLabelSize(text: String) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = UIFont.systemFont(ofSize: 10)
        label.sizeToFit()
        return label.frame.size
    }
    
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
