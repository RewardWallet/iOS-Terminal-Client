////
////  EditProfileViewController.swift
////  RewaletrdWal
//
//  Created by Nathan Tannar on 1/2/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//
import UIKit
import Former
import Parse
import AlertHUDKit
import Kingfisher

final class EditProfileViewController: FormViewController {

    var user: User
    var userModified = User()
//    var business : Business
//    var businessModified = Business()
    // MARK: Public
    init(user: User){
        self.user = user
        var queries = [PFQuery<PFObject>]()

        guard let businessQuery = Business.query() else { fatalError() }
        businessQuery.fromLocalDatastore()
        businessQuery.getObjectInBackground(withId: "rqosV8jixE") { (business, error) in
            if (business != nil){
                
               // self.business = business as! Business
            }else{
                "Business Not Found"
            }

        }



        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: Private

    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)

//    fileprivate lazy var imageRow: LabelRowFormer<ProfileImageCell> = {
//        LabelRowFormer<ProfileImageCell>(instantiateType: .Nib(nibName: "ProfileImageCell")) {
//            $0.iconView.image = self.user.business?.image
//            }.configure {
//                $0.text = "Choose profile image from library"
//                $0.rowHeight = 60
//            }.onSelected { [weak self] _ in
//                self?.former.deselect(animated: true)
//                self?.presentImagePicker()
//        }
//    }()

    fileprivate lazy var imageRow: LabelRowFormer<ProfileImageCell> = {
        LabelRowFormer<ProfileImageCell>(instantiateType: .Nib(nibName: "ProfileImageCell")) {
            $0.iconView.kf.setImage(with: self.user.business?.image)
            $0.iconView.apply(Stylesheet.ImageViews.filled)
            $0.iconView.backgroundColor = .offWhite
            }.configure {
                $0.text = "Select from your library"
                $0.rowHeight = 60
            }.onSelected { [weak self] row in
                self?.former.deselect(animated: true)
                let imagePicker = ImagePickerController()
                imagePicker.onImageSelection { [weak self] image in
                    guard let image = image, let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
                    row.cell.iconView.image = image
                    if let key = self?.user.picture?.url {
                        KingfisherManager.shared.cache.removeImage(forKey: key)
                    }
                    let file = PFFile(name: "picture.jpg", data: imageData)
                    self?.userModified.picture = file
                }
                self?.present(imagePicker, animated: true, completion: nil)
        }
    }()

    private func configure() {
        title = "Edit Profile"
        tableView.contentInset.top = 40
        tableView.contentInset.bottom = 40

        // Create RowFomers

        let nameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your name"
                $0.text = self.user.business?.name
            }.onTextChanged { [weak self] in
                if $0.isEmpty {
                    self?.userModified.business?.name = self?.user.business?.name
                    self?.userModified.business?.fullname_lower = self?.user.business?.name?.lowercased()
                } else {
                    self?.userModified.business?.name = $0
                    self?.userModified.business?.fullname_lower = $0.lowercased()
                }
               
        }
        let emailRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Email"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.text = self.user.business?.email ?? self.user.business?.username
                $0.enabled = false
        }
        let locationRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Location"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure { [weak self] in
                $0.placeholder = "Add your location"
                $0.text = self?.user.business?.address
            }.onTextChanged { [weak self] in
                self?.userModified.business?.address = $0
        }
        let introductionRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
            $0.textView.font = .systemFont(ofSize: 15)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your business-introduction"
                $0.text = self.user.business?.about
            }.onTextChanged {
                self.userModified.business?.about = $0
        }
        
        let changePasswordRow = LabelRowFormer<FormLabelCell>() {
            $0.titleLabel.textColor = .primaryColor
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            $0.accessoryType = .disclosureIndicator
            }.configure {
                $0.text = "Change Password"
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
                self?.didTapChangePassword()
        }
        

        // Create Headers

        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }

        // Create SectionFormers

        let imageSection = SectionFormer(rowFormer: imageRow)
            .set(headerViewFormer: createHeader("Profile Image"))
        let introductionSection = SectionFormer(rowFormer: introductionRow)
            .set(headerViewFormer: createHeader("Introduction"))
        let aboutSection = SectionFormer(rowFormer: nameRow, emailRow, locationRow)
            .set(headerViewFormer: createHeader("About"))
        let securitySection = SectionFormer(rowFormer: changePasswordRow)
            .set(headerViewFormer: createHeader("Security"))

        former.append(sectionFormer: imageSection, introductionSection, aboutSection, securitySection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
        
   
    }

    func didTapChangePassword() {
        
        let alert = UIAlertController(title: "Change Password", message: "Please enter your current password", preferredStyle: .alert)
        alert.removeTransparency()
        alert.view.tintColor = .primaryColor
        alert.addTextField {
            $0.placeholder = "Password"
            $0.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.verifyCurrentPassword(with: alert.textFields?.first?.text ?? "")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func verifyCurrentPassword(with password: String) {
        
        guard let email = User.current()?.username else { return }
        User.loginInBackground(email: email, password: password) { [weak self] success, error in
            if success {
                self?.promptCreateNewPassword()
            } else {
                self?.handleError(error?.localizedDescription)
            }
        }
    }
    
    func promptCreateNewPassword() {
        
        let alert = UIAlertController(title: "Change Password", message: "Please enter your new password", preferredStyle: .alert)
        alert.removeTransparency()
        alert.view.tintColor = .primaryColor
        alert.addTextField {
            $0.placeholder = "New Password"
            $0.isSecureTextEntry = true
        }
        alert.addTextField {
            $0.placeholder = "Confirm Password"
            $0.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            let newPassword = alert.textFields?.first?.text ?? ""
            let confirmPassword = alert.textFields?.last?.text ?? ""
            if newPassword == confirmPassword {
                self?.user.password = newPassword
                self?.user.saveInBackground(block: { success, error in
                    if success {
                        self?.handleSuccess("Password Updated")
                    } else {
                        self?.handleError(error?.localizedDescription)
                    }
                })
            } else {
                self?.handleError("The passwords do not match")
                self?.promptCreateNewPassword()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func handleError(_ error: String?) {
        var error = error ?? "Unknown Error"
        if error == "The data couldn’t be read because it isn’t in the correct format." {
            error = "The server could not be reached"
        }
        print(error)
        Ping(text: error, style: .danger).show(animated: true, duration: 3)
    }
    
    func handleSuccess(_ message: String?) {
        let message = message ?? "Success"
        print(message)
        Ping(text: message, style: .info).show(animated: true, duration: 3)
    }
    
    
 
}




