//
//  EditAccountViewController.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/13.
//

import UIKit
import YPImagePicker
import Photos

class EditAccountViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var okButton: UIButton = {
        var button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = UIColor(named: "gray")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.textColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UITextField!
    @IBOutlet weak var profileImg: CircularImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func setupUI(){
        setupNavigationBar()
        addButton()
        setupTextField()
        imageSetup()
        
        //데이터 받고 이미지 체인지
        setupData()
        profileImg.image = UIImage(named: "프로필 이미지")
    }
        
    private func setupNavigationBar(){
        navigationItem.title = "내 계정"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .black
    }
    
    @objc
    private func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: DATAA
    private func setupData(){
        Server.shared.getUserInfo { result in
            switch result {
            case .success(let UserInfoResponse):
                self.nickNameLabel.text = UserInfoResponse.nickname
                //SET THE IMAGE TO THE UI
                let url = URL(string: UserInfoResponse.profileImageURL)
                self.profileImg.load(url: url!)
                
            case .failure(let error):
                print(error)
                
                let alert = UIAlertController(title: "데이터 찾을 수 없습니다", message: "잠시 후 다시 시도 해보세요", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "네", style: .default)
                alert.addAction(okButton)
                
                self.present(alert, animated: true)
            }
        }
    }
    
    //MARK: PROFILE IMAGE
    private func imageSetup(){
        profileImg.isUserInteractionEnabled = true
        profileImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage)))
    }
    
    private func setupYPImagePicker() -> YPImagePickerConfiguration {
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        config.showsCrop = .circle
        
        return config
    }

    @objc func pickImage(_ sender: UIButton) {
        requestPhotoLibraryAccess { granted in
            if granted {
                DispatchQueue.main.async {
                    let picker = YPImagePicker(configuration: self.setupYPImagePicker())
                    picker.didFinishPicking { [unowned picker] items, _ in
                        if let photo = items.singlePhoto {
                            self.profileImg.image = photo.image
                            
                            
                            //사진 url에 저장...?
                            
                        }
                        picker.dismiss(animated: true, completion: nil)
                    }
                    self.present(picker, animated: true, completion: nil)
                }
            } else {
                print("Photo library access not granted.")
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
    
    //MARK: NICK NAME TEXT FIELD
    private
    func setupTextField(){
        nickNameLabel.delegate = self
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
      
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isValidInput(textField.text ?? "") {
            okButton.isUserInteractionEnabled = true
            okButton.backgroundColor = UIColor(named: "pink")
            warningLabel.text = ""
        } else {
            okButton.isUserInteractionEnabled = false
            okButton.backgroundColor = UIColor(named: "gray")
            warningLabel.text = "사용이 불가한 닉네임입니다."
        }
    }
    
    private
    func isValidInput(_ input: String) -> Bool {
        let pattern = "^[0-9a-zA-Z가-힣]{1,10}$"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: input.utf16.count)
        
        return regex.firstMatch(in: input, options: [], range: range) != nil
    }
    
    //MARK: SAVE BUTTON
    private func addButton(){
        self.view.addSubview(okButton)
//        if #available(iOS 15.0, *) {
//            NSLayoutConstraint.activate([
//                okButton.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor, constant: -20),
//                okButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
//                okButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
//            ])
//        } else {
//            // Fallback on earlier versions
            NSLayoutConstraint.activate([
                okButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
                okButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                okButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
                okButton.heightAnchor.constraint(equalToConstant: 50)
            ])
//        }
        
        okButton.isUserInteractionEnabled = false
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func okButtonTapped(){
        Server.shared.uploadImage(image: profileImg.image!, nickname: "") { result in
            switch result {
            case .success(let url):
                Server.shared.changeUserInfo(nickName: self.nickNameLabel.text ?? "" , profileURL: url) { result in
                    switch result {
                    case .success(let success):
                        let alert = UIAlertController(title: "변경 성공했습니다", message: "", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "확인", style: .default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                                                     
                        alert.addAction(okButton)
                        
                        self.present(alert, animated: true)
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }

}
