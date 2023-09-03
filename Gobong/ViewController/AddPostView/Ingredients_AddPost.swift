//
//  재료_AddPost.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/09.
//

import Foundation
import UIKit
import AlignedCollectionViewFlowLayout

//MARK: UI COLLECTION VIEW (재료 // INGREDIENTS)
extension AddPostViewController: UICollectionViewDelegate, UICollectionViewDataSource, IngredientCellDelegate, AddButtonIngredientCellDelegate {
   
    //INGREDIENTS DELETE BUTTON
    func deleteButtonTapped(in cell: AddIngredientCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        ingredients.remove(at: indexPath.row)
        collectionView.reloadData()
        
        collectionView.performBatchUpdates(nil) { [weak self] _ in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        }
        
        // Update the height constraint of the collection view based on content size
        let contentHeight = collectionView.contentSize.height
        collectionViewHeightConstraint.constant = contentHeight
        
        UIView.animate(withDuration: 0.1) {
            // Update the layout
            self.view.layoutIfNeeded()
        }
        checkOK()
    }
    
    //TEXT FIELD DELEGATE
    func textFieldDidPressReturn(in cell: AddIngredientCell) {
        cell.deleteButton.isUserInteractionEnabled = true
        if let text = cell.textField.text {
            ingredients.removeLast()
            ingredients.append(text)
            
            if cell.textField.text != " " {
                cell.textField.isUserInteractionEnabled = false
            }
        }
        checkOK()
    }
    
    func textFieldChanged(in cell: AddIngredientCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        cell.deleteButton.isUserInteractionEnabled = false
        
        collectionView.performBatchUpdates(nil) { [weak self] _ in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        }
        
        // Update the height constraint of the collection view based on content size
        let contentHeight = collectionView.contentSize.height
        collectionViewHeightConstraint.constant = contentHeight
        self.view.layoutIfNeeded()
    }
    
    // ADD NEW RECIPE / 단계
    func addButtonTapped(in cell: AddButtonIngredientCell) {
        if ingredients.last != " " {
            ingredients.append(" ")
            collectionView.reloadData()
            
            collectionView.performBatchUpdates(nil) { [weak self] _ in
                self?.collectionView.collectionViewLayout.invalidateLayout()
            }
            
            // Update the height constraint of the collection view based on content size
            let contentHeight = collectionView.contentSize.height
            collectionViewHeightConstraint.constant = contentHeight
            
            UIView.animate(withDuration: 0.1) {
                // Update the layout
                self.view.layoutIfNeeded()
            }
        }
    }

    func collectionViewSetup(){
        let alignedFlowLayout = collectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .center
        alignedFlowLayout?.minimumLineSpacing = 8
        alignedFlowLayout?.minimumInteritemSpacing = 8
        
        
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.register(AddIngredientCell.self, forCellWithReuseIdentifier: "AddIngredientCell")
        collectionView.register(AddButtonIngredientCell.self, forCellWithReuseIdentifier: "AddButtonIngredientCell")
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 34)
        collectionViewHeightConstraint.isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row != ingredients.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddIngredientCell", for: indexPath) as! AddIngredientCell
            // Configure the cell with actual ingredient data
            
            cell.delegate = self
            cell.view.tintColor = UIColor(named: "pink")
            cell.view.layer.borderColor = UIColor(named: "pink")?.cgColor
            cell.textField.text = ingredients[indexPath.row]
            cell.textField.textColor = UIColor(named: "pink")
            cell.deleteButton.isHidden = false
            cell.textField.isHidden = false
            
            if ingredients[indexPath.item] != " " {
                cell.textField.isUserInteractionEnabled = false
            } else {
                cell.textField.isUserInteractionEnabled = true
            }
            
            cell.textField.trailingAnchor.constraint(equalTo: cell.deleteButton.leadingAnchor, constant: 2).isActive = true
            return cell
        } else {
            // Reset the cell and configure it for adding
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddButtonIngredientCell", for: indexPath) as! AddButtonIngredientCell
            cell.delegate = self
            
            return cell
        }
        
    }
}
