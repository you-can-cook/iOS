//
//  AddIngredientCell.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/06.
//

import Foundation
import UIKit

protocol IngredientCellDelegate: Any {
    func textFieldDidPressReturn(in cell: AddIngredientCell)
    func textFieldChanged(in cell: AddIngredientCell)
    func deleteButtonTapped(in cell: AddIngredientCell)
}

class AddIngredientCell: UICollectionViewCell, UITextFieldDelegate {
    
    var delegate: IngredientCellDelegate?
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = UIColor(named: "pink")
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = true
        
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.setTitleColor(UIColor(named: "pink"), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
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
        contentView.addSubview(view)
        view.addSubview(textField)
        view.addSubview(deleteButton)
        textField.delegate = self
        
        // Set up constraints to make the label hug its content
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: view.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
            
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.textFieldChanged(in: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 25
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        return newString.count <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldDidPressReturn(in: self)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidPressReturn(in: self)
        textField.resignFirstResponder()
    }
    
    @objc func deleteButtonTapped(){
        delegate?.deleteButtonTapped(in: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
