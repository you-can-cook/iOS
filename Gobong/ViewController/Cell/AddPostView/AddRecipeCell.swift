//
//  AddRecipeCell.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/09.
//

import UIKit

protocol AddRecipeCellDelegate: Any{
    func addTapped(cell: AddRecipeCell)
}

class AddRecipeCell: UITableViewCell {
    
    var delegate: AddRecipeCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addViewTapped(){
        delegate?.addTapped(cell: self)
    }
    
    let stepLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.white
        return label
    }()
    
    let stepLabelBackground: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "작성 단계")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = UIColor(named: "darkGray")
        
        return image
    }()
    
    
    let addPostImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "단계 레시피")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addViewTapped)))
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
    
    private func setupUI(){
        let mainUIView = UIView()
        mainUIView.translatesAutoresizingMaskIntoConstraints = false
        
        let subMainView = UIView()
        subMainView.translatesAutoresizingMaskIntoConstraints = false
        
        let stepView = UIView()
        stepView.translatesAutoresizingMaskIntoConstraints = false
        
        subMainView.addSubview(stepView)
        
        stepView.addSubview(stepLabelBackground)
        stepView.addSubview(stepLabel)
        
        subMainView.addSubview(addPostImage)
        
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
            
            addPostImage.leadingAnchor.constraint(equalTo: stepView.trailingAnchor, constant: 15),
            addPostImage.topAnchor.constraint(equalTo: subMainView.topAnchor, constant: 0),
            addPostImage.trailingAnchor.constraint(equalTo: subMainView.trailingAnchor, constant: 0),
            addPostImage.bottomAnchor.constraint(equalTo: subMainView.bottomAnchor, constant: 15),
            
        ])
        
        mainUIView.addSubview(subMainView)
        NSLayoutConstraint.activate([
            subMainView.leadingAnchor.constraint(equalTo: mainUIView.leadingAnchor, constant: 0),
            subMainView.topAnchor.constraint(equalTo: mainUIView.topAnchor, constant: 5),
            subMainView.trailingAnchor.constraint(equalTo: mainUIView.trailingAnchor, constant: 0),
            subMainView.bottomAnchor.constraint(equalTo: mainUIView.bottomAnchor, constant: -24)
        ])
    
        contentView.addSubview(mainUIView)
        
        NSLayoutConstraint.activate([
            mainUIView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            mainUIView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            mainUIView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            mainUIView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
        addPostImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addViewTapped)))
    }
}
