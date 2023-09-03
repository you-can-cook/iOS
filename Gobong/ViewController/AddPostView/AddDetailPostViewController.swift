//
//  AddDetailPostViewController.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/10.
//

import UIKit
import YPImagePicker
import Photos
import AlignedCollectionViewFlowLayout

protocol AddDetailPostDelegate: Any {
    func passData(controller: AddDetailPostViewController)
}

class AddDetailPostViewController: UIViewController {
    
    var delegate: AddDetailPostDelegate?

    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var add10MinButton: UIButton!
    @IBOutlet weak var add5MinButton: UIButton!
    @IBOutlet weak var add1MinButotn: UIButton!
    @IBOutlet weak var add30secButton: UIButton!
    @IBOutlet weak var add10Sec: UIButton!
    @IBOutlet weak var secondField: UITextField!
    @IBOutlet weak var minuteField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    var tools = [String]()
    
    //IS EDITING? THEN THERE IS DATA IF NOT ITS NIL
    var selectedForEdit: RecipeDetailsModel?
    
    //IF EDITING, EDITING INDEX PATH ELSE NEW CELL INDEX PATH
    var editIndex: IndexPath?
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
//        setData()
        setTapGesture()
        collectionViewSetup()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchToolBar" {
            if let VC = segue.destination as? SearchToolsViewController {
                VC.delegate = self
                VC.selectedTools = tools
                VC.forFilter = tools
            }
        }
    }
    
    //SAVE BUTTON
    @IBAction func saveButton(_ sender: Any) {
        if saveButton.backgroundColor == UIColor(named: "pink") {
            delegate?.passData(controller: self)
        }
        
        self.dismiss(animated: true)
    }
    
    //DELETE BUTTON ONLY SHOWING WHEN EDITING
    @IBAction func trashButton(_ sender: Any) {
        let alert = UIAlertController(title: "단계 삭제", message: "단계를 삭제하면 다시 복구할 수 없습니다. 정말 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        
        let yesAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            //delete with delegateee
        }
        
        alert.addAction(cancelAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true)
    }
}


//MARK: DATA
extension AddDetailPostViewController {
    //IF EDITING STATE (NOT NEW STEP) SET THE DATA TO THE UI
//    private func setData(){
//        if selectedForEdit != nil {
//            postImage.image = selectedForEdit?.img
//            tools = selectedForEdit?.tool ?? []
//            minuteField.text = selectedForEdit?.minute
//            secondField.text = selectedForEdit?.second
//
//            if minuteField.text != "" || secondField.text != "" {
//                minuteField.layer.borderColor = UIColor(named: "pink")?.cgColor
//                secondField.layer.borderColor = UIColor(named: "pink")?.cgColor
//            }
//
//            descriptionTextField.text = selectedForEdit?.description
//            if descriptionTextField.text != "" || descriptionTextField.text != "자세한 조리 과정을 입력하세요" {
//                descriptionTextField.layer.borderColor = UIColor(named: "pink")?.cgColor
//            }
//
//            collectionView.reloadData()
//            checkOkNext()
//        }
//    }
}

//MARK: UI
extension AddDetailPostViewController: UITextFieldDelegate, UITextViewDelegate {
    private func setupUI(){
        if selectedForEdit != nil {
            trashButton.isHidden = false
        } else {
            trashButton.isHidden = true
        }
        
        add10Sec.layer.cornerRadius = 16
        add30secButton.layer.cornerRadius = 16
        add1MinButotn.layer.cornerRadius = 16
        add5MinButton.layer.cornerRadius = 16
        add10MinButton.layer.cornerRadius = 16
        
        descriptionTextField.layer.borderColor = UIColor(named: "gray")?.cgColor
        descriptionTextField.layer.borderWidth = 1
        
        minuteField.layer.borderWidth = 1
        minuteField.layer.borderColor = UIColor(named: "gray")?.cgColor
        minuteField.layer.masksToBounds = true
        
        secondField.layer.borderWidth = 1
        secondField.layer.borderColor = UIColor(named: "gray")?.cgColor
        secondField.layer.masksToBounds = true
        
        postImage.image = UIImage(named: "uploadPhoto")
        
        //완료 버튼
        checkOkNext()
        
        minuteField.delegate = self
        secondField.delegate = self
        descriptionTextField.delegate = self
        
        descriptionTextField.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
    }
    
    //text field
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (minuteField.text != "0" && minuteField.text != "" && minuteField.text != nil) ||
           (secondField.text != "0" && secondField.text != "" && secondField.text != nil) {

            minuteField.layer.borderColor = UIColor(named: "pink")?.cgColor
            secondField.layer.borderColor = UIColor(named: "pink")?.cgColor
            checkOkNext()
        } else {
            minuteField.layer.borderColor = UIColor(named: "gray")?.cgColor
            secondField.layer.borderColor = UIColor(named: "gray")?.cgColor
            checkOkNext()
        }
    }

    //text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextField.text == "자세한 조리 과정을 입력하세요" {
            descriptionTextField.textColor = .black
            descriptionTextField.layer.borderColor = UIColor(named: "pink")?.cgColor
            descriptionTextField.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextField.text == "" {
            descriptionTextField.textColor = .gray
            descriptionTextField.layer.borderColor = UIColor(named: "gray")?.cgColor
            descriptionTextField.text = "자세한 조리 과정을 입력하세요"
        }
        checkOkNext()
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        checkOkNext()
    }
    
    //IMAGE
    private func setupYPImagePicker() -> YPImagePickerConfiguration{
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        config.showsCrop = .rectangle(ratio: (16/9))
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 168.0, height: 168.0))
        let newCapturePhotoImage = renderer.image { context in
            let symbolImage = UIImage(systemName: "largecircle.fill.circle")?.withTintColor(UIColor(named: "pink")!)
            symbolImage?.draw(in: CGRect(x: 0, y: 0, width: 168.0, height: 168.0))
        }
        let finalCapturePhotoImage = newCapturePhotoImage ?? config.icons.capturePhotoImage
        config.icons.capturePhotoImage = finalCapturePhotoImage
    
        return config
    }
    
    private func setTapGesture(){
        postImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage)))
    }
    
    @IBAction func pickImage(_ sender: UIButton) {
        requestPhotoLibraryAccess { granted in
            if granted {
                DispatchQueue.main.async {
                    let picker = YPImagePicker(configuration: self.setupYPImagePicker())
                    picker.didFinishPicking { [unowned picker] items, _ in
                        if let photo = items.singlePhoto {
                            self.postImage.image = photo.image
                            
                            self.checkOkNext()
                        }
                        picker.dismiss(animated: true, completion: nil)
                    }
                    self.present(picker, animated: true, completion: nil)
                }
            } else {
                print(granted)
            }
        }
        
    }
    
    func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        // Check the current authorization status
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized:
            // User has already granted access
            completion(true)
        case .notDetermined:
            // Request access
            PHPhotoLibrary.requestAuthorization { status in
                completion(status == .authorized)
            }
        default:
            // User has denied or restricted access
            completion(false)
        }
    }
    
    //BUTTON
    @IBAction func initTapped(_ sender: Any) {
        minuteField.text = ""
        secondField.text = ""
        
        minuteField.layer.borderColor = UIColor(named: "gray")?.cgColor
        secondField.layer.borderColor = UIColor(named: "gray")?.cgColor
    }
    
    @IBAction func tenMinTapped(_ sender: Any) {
        if let currMinutes = minuteField.text {
            let newMinutes = (Int(currMinutes) ?? 0) + 10
            minuteField.text = "\(newMinutes)"
        } else {
            minuteField.text = "\(10)"
        }
        
        minuteField.layer.borderColor = UIColor(named: "pink")?.cgColor
        secondField.layer.borderColor = UIColor(named: "pink")?.cgColor
        checkOkNext()
        
    }
    
    @IBAction func fiveMinTapped(_ sender: Any) {
        if let currMinutes = minuteField.text {
            let newMinutes = (Int(currMinutes) ?? 0) + 5
            minuteField.text = "\(newMinutes)"
        } else {
            minuteField.text = "\(5)"
        }
        
        minuteField.layer.borderColor = UIColor(named: "pink")?.cgColor
        secondField.layer.borderColor = UIColor(named: "pink")?.cgColor
        checkOkNext()
    }
    
    @IBAction func oneMinTapped(_ sender: Any) {
        if let currMinutes = minuteField.text {
            let newMinutes = (Int(currMinutes) ?? 0) + 1
            minuteField.text = "\(newMinutes)"
        } else {
            minuteField.text = "\(1)"
        }
        
        minuteField.layer.borderColor = UIColor(named: "pink")?.cgColor
        secondField.layer.borderColor = UIColor(named: "pink")?.cgColor
        checkOkNext()
    }
    
    @IBAction func thirtysecTapped(_ sender: Any) {
        if let curr = secondField.text {
            var new = (Int(curr) ?? 0) + 30
            var newMinutes = 0
            
            if new > 59 {
                newMinutes = new / 60
                new = new % 60
            }

            if let min = minuteField.text {
                let totalMinutes = (Int(min) ?? 0) + newMinutes
                minuteField.text = "\(totalMinutes)"
                secondField.text = "\(new)"
            } else {
                minuteField.text = "\(newMinutes)"
                secondField.text = "\(new)"
            }
        } else {
            secondField.text = "\(30)"
        }
        
        minuteField.layer.borderColor = UIColor(named: "pink")?.cgColor
        secondField.layer.borderColor = UIColor(named: "pink")?.cgColor
        checkOkNext()
    }
    
    @IBAction func tenSecTapped(_ sender: Any) {
        if let curr = secondField.text {
            var new = (Int(curr) ?? 0) + 10
            if new > 59 {
                if let min = minuteField.text {
                    minuteField.text = "\((Int(min) ?? 0) + 1)"
                    new = new - 60
                    secondField.text = "\(new)"
                } else {
                    minuteField.text = "\(1)"
                    new = new - 60
                    secondField.text = "\(new)"
                }
            } else {
                secondField.text = "\(new)"
            }
        } else {
            secondField.text = "\(10)"
        }
        
        minuteField.layer.borderColor = UIColor(named: "pink")?.cgColor
        secondField.layer.borderColor = UIColor(named: "pink")?.cgColor
        checkOkNext()
    }
    
    private func checkOkNext(){
        if minuteField.layer.borderColor == UIColor(named: "pink")?.cgColor &&
           (descriptionTextField.text != "" && descriptionTextField.text != "자세한 조리 과정을 입력하세요") ||  postImage.image != UIImage(named: "uploadPhoto") {

            print(postImage.image != UIImage(named: "uploadPhoto"))
            saveButton.backgroundColor = UIColor(named: "pink")
            saveButton.isUserInteractionEnabled = true
        } else {
            // Both conditions are not met
            saveButton.backgroundColor = UIColor(named: "softGray")
            saveButton.isUserInteractionEnabled = false
        }

    }
}

//MARK: COLLECTION VIEW (TOOLS)
extension AddDetailPostViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchToolsDelegate {
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
        if indexPath.item != tools.count {
            cell.setText3(tools[indexPath.item])
            cell.label.font = UIFont.systemFont(ofSize: 14)
            cell.label.textColor = UIColor.white
            cell.view.backgroundColor = UIColor(named: "pink")
            cell.label.layer.borderColor = UIColor(named: "pink")?.cgColor
        } else {
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
        } else {
            performSegue(withIdentifier: "showSearchToolBar", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item != tools.count {
            let labelSize = calculateLabelSize(text: tools[indexPath.item])
            return CGSize(width: labelSize.width + 24, height: labelSize.height + 16)
        } else {
            let labelSize = calculateLabelSize(text: "•••")
            return CGSize(width: labelSize.width + 24, height: labelSize.height + 16)
        }
    }
    
    //CALCULATE COLLECTION VIEW HEIGHT
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
