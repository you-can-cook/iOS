//
//  SearchToolsViewController.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/11.
//

import UIKit
import AlignedCollectionViewFlowLayout

protocol SearchToolsDelegate: Any {
    func passToolData(controller: SearchToolsViewController)
}

class SearchToolsViewController: UIViewController {
    
    var delegate: SearchToolsDelegate?

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectedCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var toolList = CookingTools.allCases
    
    var forFilter = [String]()
    var selectedTools = [String]()
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.passToolData(controller: self)
    }
    
    //BUTTON
    @IBAction func backButton(_ sender: Any) {
        delegate?.passToolData(controller: self)
        self.dismiss(animated: true)
    }
    
    @objc private func tapped(){
        searchBar.resignFirstResponder()
    }
}

extension SearchToolsViewController {
    private func setupUI(){
        selectedCollectionViewSetup()
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        collectionViewSetup()
        
        selectedCollectionView.reloadData()
        updateHeight()
        backButton.setTitle("", for: .normal)
    }
}

extension SearchToolsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tapped()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        selectedTools = forFilter
        selectedCollectionView.reloadData()
        updateHeight()
        toolList = CookingTools.allCases
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        selectedTools.removeAll()
        selectedCollectionView.reloadData()
        updateHeight()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        selectedTools = forFilter
        selectedCollectionView.reloadData()
        updateHeight()
        toolList = CookingTools.allCases
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            toolList = CookingTools.allCases // Show all items if search text is empty
        } else {
            toolList = CookingTools.allCases.filter { $0.rawValue.contains(searchText) }
        }
        collectionView.reloadData()
    }
}


extension SearchToolsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func selectedCollectionViewSetup(){
        let alignedFlowLayout = selectedCollectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .center
        alignedFlowLayout?.minimumLineSpacing = 8
        alignedFlowLayout?.minimumInteritemSpacing = 8

        selectedCollectionView.dataSource = self
        selectedCollectionView.delegate = self

        selectedCollectionView.register(HashtagCollectionCell.self, forCellWithReuseIdentifier: "HashtagCollectionCell")

        selectedCollectionView.invalidateIntrinsicContentSize()
        
    }

    private func collectionViewSetup(){
        let alignedFlowLayout = collectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .center
        alignedFlowLayout?.minimumLineSpacing = 8
        alignedFlowLayout?.minimumInteritemSpacing = 8

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(HashtagCollectionCell.self, forCellWithReuseIdentifier: "HashtagCollectionCell")

        collectionView.invalidateIntrinsicContentSize()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == selectedCollectionView {
            return selectedTools.count
        }

        //모든 도구
        else {
            return toolList.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == selectedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashtagCollectionCell", for: indexPath) as! HashtagCollectionCell
            cell.setText3(selectedTools[indexPath.item])
            cell.label.font = UIFont.systemFont(ofSize: 14)
            cell.label.textColor = .white
            cell.label.layer.borderColor = UIColor.white.cgColor
            cell.view.backgroundColor = UIColor(named: "pink")

            return cell
        }

        //모든 도구
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashtagCollectionCell", for: indexPath) as! HashtagCollectionCell
            cell.setText3(toolList[indexPath.item].rawValue)
            cell.label.font = UIFont.systemFont(ofSize: 14)
            
            if forFilter.contains(toolList[indexPath.item].rawValue) {
                cell.label.textColor = .white
                cell.label.layer.borderColor = UIColor.white.cgColor
                cell.view.backgroundColor = UIColor(named: "pink")
            } else {
                cell.label.textColor = UIColor(named: "gray")
                cell.label.layer.borderColor = UIColor(named: "gray")?.cgColor
                cell.view.backgroundColor = UIColor.white
            }

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == selectedCollectionView {
            selectedTools.remove(at: indexPath.row)
            forFilter.remove(at: indexPath.row)
            self.selectedCollectionView.reloadData()
            self.collectionView.reloadData()
            updateHeight()
        }
        
        else {
            if !forFilter.contains(toolList[indexPath.row].rawValue){
                forFilter.append(toolList[indexPath.row].rawValue)
                
                if !searchBar.isFirstResponder {
                    selectedTools.append(toolList[indexPath.row].rawValue)
                }
                
                self.selectedCollectionView.reloadData()
                self.collectionView.reloadData()
                updateHeight()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == selectedCollectionView {
            let labelSize = calculateLabelSize(text: selectedTools[indexPath.item])
            return CGSize(width: labelSize.width + 24, height: labelSize.height + 16)
        }

        //모든 도구
        else {
            let labelSize = calculateLabelSize(text: toolList[indexPath.item].rawValue)
            return CGSize(width: labelSize.width + 24, height: labelSize.height + 16)
        }
    }

    func calculateLabelSize(text: String) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        let calculatedSize = label.frame.size
        return calculatedSize
    }
    
    func updateHeight(){
        selectedCollectionView.performBatchUpdates(nil) { [weak self] _ in
            self?.selectedCollectionView.collectionViewLayout.invalidateLayout()
        }
        
        // Update the height constraint of the collection view based on content size
        let contentHeight = selectedCollectionView.contentSize.height
        selectedCollectionViewHeightConstraint.constant = contentHeight
        
        UIView.animate(withDuration: 0.1) {
            // Update the layout
            self.view.layoutIfNeeded()
        }
    }
}
