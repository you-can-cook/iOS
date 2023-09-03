//
//  SignUpViewController.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/13.
//

import UIKit
import YPImagePicker
import Photos

class SignUpViewController: UIViewController {
    
    var okButton: UIButton = {
        var button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = UIColor(named: "gray")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.textColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UITextField!
    @IBOutlet weak var profileImg: CircularImageView!
    
    var temporaryToken: String?
    var provider: String?
    var oauthId: String?
    var userDefault = UserDefaults.standard
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    //MARK: UI
    private func setupUI(){
        addButton()
        setupTextField()
        imageSetup()
        
        profileImg.image = UIImage(named: "프로필 이미지")
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
    
    //MARK: BUTTON
    private func addButton(){
        self.view.addSubview(okButton)
        NSLayoutConstraint.activate([
            okButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            okButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            okButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            okButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        okButton.isUserInteractionEnabled = false
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func okButtonTapped(){
        var imageUrl: String? = nil
        
        Server.shared.signUp(nickName: nickNameLabel.text ?? "", provider: provider ?? "", oauthId: oauthId ?? "", temporaryToken: temporaryToken ?? "", profileImageUrl: imageUrl) { result in
            switch result {
            case .success(let info):
                self.userDefault.set(info.grantType, forKey: "grantType")
                self.userDefault.set(info.accessToken, forKey: "accessToken")
                self.userDefault.set(info.refreshToken, forKey: "refreshToken")

                self.userDefault.set(self.nickNameLabel.text, forKey: "nickName")
                
                //UPLOAD IMAGE
                if self.profileImg.image == UIImage(named: "프로필 이미지") {
                    //암것도 안 함
                    self.performSegue(withIdentifier: "showMainView", sender: self)
                } else {
                    Server.shared.uploadImage(image: self.profileImg.image!, nickname: self.nickNameLabel.text ?? "") { result in
                        switch result {
                        case .success(let result):
                            print(result)
                            
                            Server.shared.changeUserInfo(nickName: self.nickNameLabel.text ?? "", profileURL: result) { Result in
                                print("sended")
                                switch Result {
                                case.success(_):
                                    self.performSegue(withIdentifier: "showMainView", sender: self)
                                case .failure(let error):
                                    print(error)
                                }
                            }
                            
                        case.failure(let error):
                            print(error)
                        }
                    }
                }
                

            case .failure(let error):
                //무슨
                print("Error:", error.localizedDescription)
            }
        }
    }
    
    //MARK: NICK NAME TEXT FIELD
    private func setupTextField(){
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
    
    func isValidInput(_ input: String) -> Bool {
        let pattern = "^[0-9a-zA-Z가-힣]{1,10}$"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: input.utf16.count)
        
        return regex.firstMatch(in: input, options: [], range: range) != nil
    }

}

class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
    }
}
