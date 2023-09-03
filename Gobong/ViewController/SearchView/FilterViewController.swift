//
//  FilterViewController.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/12.
//

import UIKit
import StepSlider
import AlignedCollectionViewFlowLayout

protocol FilterDelegate: Any {
    func passFilter(controller: FilterViewController)
}

class FilterViewController: UIViewController {

    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var collectionView: SelfSizingCollectionView!
    //별점
    @IBOutlet weak var oneStarButton: UIButton!
    @IBOutlet weak var twoStarButton: UIButton!
    @IBOutlet weak var threeStarButton: UIButton!
    @IBOutlet weak var fourStarButton: UIButton!
    @IBOutlet weak var fiveStarButton: UIButton!
    //슬라이더
    @IBOutlet weak var stepSlider: StepSlider!
    //난이도
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var easyButton: UIButton!
    //정렬
    @IBOutlet weak var byPopularityButton: UIButton!
    @IBOutlet weak var byNewestButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var tools = [String]()
    var searchBarText = ""
    var delegate: FilterDelegate?
    var lastFilter: FilterModel?
    
    //MARK: LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchToolBar" {
            if let VC = segue.destination as? SearchToolsViewController {
                VC.delegate = self
                
                //SEND ALREADY SELECTED TOOLS TO SEARCH TOOL VIEW
                VC.selectedTools = tools
                VC.forFilter = tools
            }
        }
    }
    
    //BUTTON
    @IBAction func searchButtonTapped(_ sender: Any) {
        delegate?.passFilter(controller: self)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func defaultButtonTapped(_ sender: Any) {
        selectedSort = "recent"
        starSelected = nil
        levelSelected = nil
        searchBar.text = nil
        stepSlider.index = 6
        
    }
    
    //별점 //STAR
    var starSelected: Int? {
        didSet {
            if starSelected == 1 {
                selected(oneStarButton)
                notSelected(twoStarButton)
                notSelected(threeStarButton)
                notSelected(fourStarButton)
                notSelected(fiveStarButton)
                
            } else if starSelected == 2 {
                notSelected(oneStarButton)
                selected(twoStarButton)
                notSelected(threeStarButton)
                notSelected(fourStarButton)
                notSelected(fiveStarButton)
                
            } else if starSelected == 3 {
                notSelected(oneStarButton)
                notSelected(twoStarButton)
                selected(threeStarButton)
                notSelected(fourStarButton)
                notSelected(fiveStarButton)
                
            } else if starSelected == 4 {
                notSelected(oneStarButton)
                notSelected(twoStarButton)
                notSelected(threeStarButton)
                selected(fourStarButton)
                notSelected(fiveStarButton)
                
            } else if starSelected == 5 {
                notSelected(oneStarButton)
                notSelected(twoStarButton)
                notSelected(threeStarButton)
                notSelected(fourStarButton)
                selected(fiveStarButton)
                
            } else {
                notSelected(oneStarButton)
                notSelected(twoStarButton)
                notSelected(threeStarButton)
                notSelected(fourStarButton)
                notSelected(fiveStarButton)
                
            }
        }
    }
    
    @IBAction func fiveStarTapped(_ sender: Any) {
        starSelected = 5
    }
    
    @IBAction func fourStarTapped(_ sender: Any) {
        starSelected = 4
    }

    @IBAction func threeStarTapped(_ sender: Any) {
        starSelected = 3
    }
    
    @IBAction func twoStarTapped(_ sender: Any) {
        starSelected = 2
    }
    
    @IBAction func oneStarTapped(_ sender: Any) {
        starSelected = 1
    }
    
    //LEVEL // 난이도
    var levelSelected: String? {
        didSet{
            if levelSelected == "쉬워요" {
                selected(easyButton)
                notSelected(normalButton)
                notSelected(hardButton)
                
            } else if levelSelected == "보통이에요" {
                notSelected(easyButton)
                selected(normalButton)
                notSelected(hardButton)
                
            } else if levelSelected == "어려워요" {
                notSelected(easyButton)
                notSelected(normalButton)
                selected(hardButton)
                
            } else {
                notSelected(easyButton)
                notSelected(normalButton)
                notSelected(hardButton)
            }
        }
    }
    
    @IBAction func easyTapped(_ sender: Any) {
        levelSelected = "쉬워요"
    }
    
    @IBAction func normalTapped(_ sender: Any) {
        levelSelected = "보통이에요"
    }
    
    @IBAction func hardTapped(_ sender: Any) {
        levelSelected = "어려워요"
    }
    
    //정렬 // SORT
    var selectedSort: String? {
        didSet {
            if selectedSort == "recent" {
                
                selected(byNewestButton)
                notSelected(byPopularityButton)
                byNewestButton.layer.cornerRadius = 0
                byPopularityButton.layer.cornerRadius = 0
            } else {
                selected(byPopularityButton)
                notSelected(byNewestButton)
                byNewestButton.layer.cornerRadius = 0
                byPopularityButton.layer.cornerRadius = 0
            }
        }
    }
    
    @IBAction func byNewestTapped(_ sender: Any) {
        selectedSort = "recent"
    }
    
    @IBAction func byPopularityTapped(_ sender: Any) {
        selectedSort = "popular"
    }
    
}

//MARK: UI
extension FilterViewController {
    private func setupUI(){
        if lastFilter != nil {
            selectedSort = lastFilter?.sort
            levelSelected = lastFilter?.level
            stepSlider.setIndex(UInt((lastFilter?.time ?? 0)/5), animated: true)
            starSelected = lastFilter?.star
            tools = lastFilter?.tools ?? []
        } else {
            levelSelected = nil
            starSelected = nil
            selectedSort = "recent"
        }
        
        collectionViewSetup()
        setupSlider()
        setupNavigationBar()
        setupSearchBar()
    }
    
    private func setupNavigationBar(){
        navigationItem.title = "필터"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButton))
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    //NAVIGATION FUNC
    @objc private func backButton(){
        navigationController?.popViewController(animated: true)
    }
    
    //SELECTED NOT SELECTED UI
    private func selected(_ button: UIButton) {
        button.layer.borderColor = UIColor(named: "pink")?.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = UIColor(named: "pink")
        button.titleLabel?.tintColor = .white
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 16
    }
    
    private func notSelected(_ button: UIButton) {
        button.layer.borderColor = UIColor(named: "gray")?.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.titleLabel?.tintColor = UIColor(named: "gray")
        button.titleLabel?.textColor = UIColor(named: "gray")
        button.layer.cornerRadius = 16
    }
    
    //SETUP SLIDER
    private func setupSlider(){
        stepSlider.labels = ["0분", "5분", "10분", "15분", "20분", "25분", "30분 이상"]
        stepSlider.trackColor = UIColor(named: "softGray")
        stepSlider.tintColor = UIColor(named: "pink")
        stepSlider.labelColor = UIColor(named: "gray")
        stepSlider.labelOffset = CGFloat(3)
        stepSlider.labelFont = UIFont.systemFont(ofSize: 10)
        stepSlider.trackHeight = 10
        stepSlider.sliderCircleRadius = stepSlider.trackHeight
        
        let imageSize = CGSize(width: 20, height: 20)
        let borderedImage = createTintedWithCircularBorderImage(systemName: "circle.fill", tintColor: UIColor.white ,borderColor: UIColor(named: "pink")!, borderWidth: 4, imageSize: imageSize)
        
        stepSlider.sliderCircleImage = borderedImage
        stepSlider.index = 6
    }
    
    //STEP SLIDER CIRCLE
    func createTintedWithCircularBorderImage(systemName: String, tintColor: UIColor, borderColor: UIColor, borderWidth: CGFloat, imageSize: CGSize) -> UIImage? {
        let originalImage = UIImage(systemName: systemName)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0) // Use 0.0 scale to keep the original image size
        let context = UIGraphicsGetCurrentContext()
        
        // Draw the tinted image
        let imageRect = CGRect(origin: .zero, size: imageSize)
        originalImage?.draw(in: imageRect)
        
        // Apply tint color
        context?.setBlendMode(.sourceIn)
        context?.setFillColor(tintColor.cgColor)
        context?.fill(imageRect)
        
        // Draw the circular border
        context?.setStrokeColor(borderColor.cgColor)
        context?.setLineWidth(borderWidth)
        let borderRect = imageRect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        context?.addEllipse(in: borderRect)
        context?.strokePath()
        
        // Create a new image with the applied tint and circular border
        let tintedWithCircularBorderImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedWithCircularBorderImage
    }
    
}

//MARK: SEARCH BAR
extension FilterViewController: UISearchBarDelegate {
    private func setupSearchBar(){
        searchBar.delegate = self
        searchBar.text = searchBarText
        searchBar.tintColor = UIColor(named: "pink")
        searchBar.backgroundImage = UIImage()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//COLLECTION VIEW (TOOLS)
extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchToolsDelegate {
    //GET DATA FROM FINDING TOOLS VIEW
    func passToolData(controller: SearchToolsViewController) {
        tools = controller.selectedTools
        collectionView.reloadData()
        updateHeight()
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
        return tools.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashtagCollectionCell", for: indexPath) as! HashtagCollectionCell
        
        // SELECTED TOOLS SET
        if indexPath.item != tools.count {
            cell.setText3(tools[indexPath.item])
            cell.label.font = UIFont.systemFont(ofSize: 14)
            cell.label.textColor = UIColor.white
            cell.view.backgroundColor = UIColor(named: "pink")
            cell.label.layer.borderColor = UIColor(named: "pink")?.cgColor
        }
        
        //SEARCH TOOLS VIEW
        else {
            cell.setText("•••")
            cell.label.font = UIFont.systemFont(ofSize: 14)
            cell.label.textColor = UIColor(named: "gray")
            cell.label.layer.borderColor = UIColor(named: "gray")?.cgColor
            cell.view.backgroundColor = .white
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != tools.count {
            //DELETE TOOLS?
            tools.remove(at: indexPath.item)
            collectionView.reloadData()
            updateHeight()
        }
        
        else {
            performSegue(withIdentifier: "showSearchToolBar", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item != tools.count {
            let labelSize = calculateLabelSize(text: tools[indexPath.item])
            return CGSize(width: labelSize.width + 24, height: labelSize.height + 16)
        }
        else {
            let labelSize = calculateLabelSize(text: "•••")
            return CGSize(width: labelSize.width + 24, height: labelSize.height + 16)
        }
    }
    
    //CALCULATE SIZE
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
        collectionView.performBatchUpdates(nil) { [weak self] _ in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        }
        
        let contentHeight = collectionView.contentSize.height
        collectionViewHeightConstraint.constant = contentHeight
        
        UIView.animate(withDuration: 0.1) {
            // Update the layout
            self.view.layoutIfNeeded()
        }
    }
    
}
