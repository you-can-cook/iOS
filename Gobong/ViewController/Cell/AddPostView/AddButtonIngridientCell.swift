//
//  AddButtonIngridientCell.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/08.
//

import Foundation
import UIKit

protocol AddButtonIngredientCellDelegate: Any {
    func addButtonTapped(in cell: AddButtonIngredientCell)
}

class AddButtonIngredientCell: UICollectionViewCell {
    var delegate: AddButtonIngredientCellDelegate?
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("추가하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 15
        //        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.addTarget(self, action: #selector(addButtonTappedd), for: .touchUpInside)
        
        button.layer.borderColor = UIColor(named: "gray")?.cgColor
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.tintColor = UIColor(named: "gray")
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }()
    
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.tintColor = UIColor(named: "pink")
        view.layer.borderColor = UIColor(named: "pink")?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add the label to the cell's contentView
        contentView.addSubview(button)
        
        // Set up constraints to make the label hug its content
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    

    @objc private func addButtonTappedd(){
        delegate?.addButtonTapped(in: self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
