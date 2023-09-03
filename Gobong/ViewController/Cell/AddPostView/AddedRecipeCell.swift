//
//  AddedRecipeCell.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/09.
//

import UIKit
import AlignedCollectionViewFlowLayout


protocol AddedRecipeCellDelegate  : Any {
    func collectionViewTapped(sender: AddedRecipeCell)
    func editTapped(sender: AddedRecipeCell)
}

class AddedRecipeCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var tools = [String]()
    var delegate: AddedRecipeCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    let dottedLine: DashedLineView = {
       let view = DashedLineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let informationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "darkGray")?.cgColor
        return view
    }()
    
    let firstLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let collectionView: SelfSizingCollectionView = {
        let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        alignedFlowLayout.minimumInteritemSpacing = 8
        alignedFlowLayout.minimumLineSpacing = 0
        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: alignedFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let UIimage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 4
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let descriptionLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.paddingBottom = 10
        label.paddingTop = 10
        return label
    }()
    
    let editButton: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "수정하기"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    @objc func collectionViewTapped(){
        delegate?.collectionViewTapped(sender: self)
    }
    
    @objc func editButtonTapped(){
        delegate?.editTapped(sender: self)
    }
    
    private func setupUI(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HashtagCollectionCell.self, forCellWithReuseIdentifier: "HashtagCollectionCell")
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewTapped)))
        collectionView.isScrollEnabled = false
        editButton.isUserInteractionEnabled = true
        descriptionLabel.isUserInteractionEnabled = true
    

        editButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewTapped)))
        
        UIimage.backgroundColor = .black
        descriptionLabel.backgroundColor = .white

        
        let mainUIView = UIView()
        mainUIView.translatesAutoresizingMaskIntoConstraints = false
        
        let subMainView = UIView()
        subMainView.translatesAutoresizingMaskIntoConstraints = false
        
        let stepView = UIView()
        stepView.translatesAutoresizingMaskIntoConstraints = false
        
        subMainView.addSubview(stepView)
        subMainView.addSubview(informationView)
        
        stepView.addSubview(stepLabelBackground)
        stepView.addSubview(stepLabel)
        
        NSLayoutConstraint.activate([
            stepLabelBackground.leadingAnchor.constraint(equalTo: stepView.leadingAnchor),
            stepLabelBackground.topAnchor.constraint(equalTo: stepView.topAnchor),
            stepLabelBackground.trailingAnchor.constraint(equalTo: stepView.trailingAnchor),
            stepLabelBackground.bottomAnchor.constraint(equalTo: stepView.bottomAnchor),
            
            stepLabel.centerXAnchor.constraint(equalTo: stepView.centerXAnchor, constant: -3),
            stepLabel.centerYAnchor.constraint(equalTo: stepView.centerYAnchor),
            
            stepView.leadingAnchor.constraint(equalTo: subMainView.leadingAnchor, constant: 0),
            stepView.topAnchor.constraint(equalTo: subMainView.topAnchor, constant: 0),
            stepView.widthAnchor.constraint(equalToConstant: 48),
            
            informationView.leadingAnchor.constraint(equalTo: stepView.trailingAnchor, constant: 15),
            informationView.topAnchor.constraint(equalTo: subMainView.topAnchor, constant: 0),
            informationView.trailingAnchor.constraint(equalTo: subMainView.trailingAnchor, constant: 0),
            informationView.bottomAnchor.constraint(equalTo: subMainView.bottomAnchor, constant: 15),
        ])
        
        //====================
        informationView.addSubview(infoStackView)
        
        infoStackView.addArrangedSubview(firstLineView)
        infoStackView.addArrangedSubview(UIimage)
        infoStackView.addArrangedSubview(descriptionLabel)
        
        firstLineView.addSubview(collectionView)
        firstLineView.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 0),
            infoStackView.bottomAnchor.constraint(equalTo: informationView.bottomAnchor),
            
            firstLineView.leadingAnchor.constraint(equalTo: infoStackView.leadingAnchor),
            firstLineView.trailingAnchor.constraint(equalTo: infoStackView.trailingAnchor),
            firstLineView.topAnchor.constraint(equalTo: infoStackView.topAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: firstLineView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: firstLineView.topAnchor, constant: 6),
            collectionView.bottomAnchor.constraint(equalTo: firstLineView.bottomAnchor),
            
            editButton.leadingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: 2),
            editButton.trailingAnchor.constraint(equalTo: firstLineView.trailingAnchor),
            editButton.topAnchor.constraint(equalTo: firstLineView.topAnchor, constant: 13),
            
            UIimage.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 12),
            UIimage.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -12),
            UIimage.heightAnchor.constraint(lessThanOrEqualToConstant: 130),
            UIimage.widthAnchor.constraint(equalTo: informationView.widthAnchor, constant: -24)
        ])
        
        
        mainUIView.addSubview(subMainView)
        NSLayoutConstraint.activate([
            subMainView.leadingAnchor.constraint(equalTo: mainUIView.leadingAnchor, constant: 0),
            subMainView.topAnchor.constraint(equalTo: mainUIView.topAnchor, constant: 5),
            subMainView.trailingAnchor.constraint(equalTo: mainUIView.trailingAnchor, constant: 0),
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
        
        
        descriptionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewTapped)))
        editButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editButtonTapped)))
    }
 
    func configuration(step: Int, time: String, tool: [String], image: UIImage?, description: String, isFolded: Bool) {
        stepLabel.text = "\(step)단계"
        
        tools.append(time)
        tools.append(contentsOf: tool)
        
        collectionView.reloadData()
        
        if !isFolded{
            if image != nil {
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
    
    func toggleImageViewVisibility(isFolded: Bool, image: UIImage?){
        if !isFolded {
            if image != nil{
                UIimage.isHidden = false
                UIimage.image = image
            } else {
                UIimage.isHidden = true
            }
            collectionView.isUserInteractionEnabled = false
            descriptionLabel.isUserInteractionEnabled = false
            UIimage.isUserInteractionEnabled = false
        } else {
            UIimage.isHidden = true
            collectionView.isUserInteractionEnabled = true
            descriptionLabel.isUserInteractionEnabled = true
            UIimage.isUserInteractionEnabled = true
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
