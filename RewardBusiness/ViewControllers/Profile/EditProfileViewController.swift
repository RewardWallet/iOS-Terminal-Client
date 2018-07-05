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
    
    var modifiedBusiness = Business()
    var rewardModel = RewardModel()
    var moreInfo  = false

    // MARK: Public
    init(user: User){
        self.user = user
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
//                    if let key = self?.user.picture?.url {
//                        KingfisherManager.shared.cache.removeImage(forKey: key)
//                    }
//                    let file = PFFile(name: "picture.jpg", data: imageData)
//                    self?.userModified.picture = file
                    if let key = self?.user.business?.image?.url {
                            KingfisherManager.shared.cache.removeImage(forKey: key)
                        }
                        let file = PFFile(name: "picture.jpg", data: imageData)
                        self?.modifiedBusiness.image = file
                }
                self?.present(imagePicker, animated: true, completion: nil)
        }
    }()

    
    private lazy var informationSection: SectionFormer = {
        let cashBackPercentRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "CashBack"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter your cash back percent"
                if let num = self.user.business?.rewardModel?.cashBackPercent  {
                    $0.text = "\(num)"
                }
            }.onTextChanged {
                self.rewardModel.cashBackPercent = NSNumber(value: Int($0.digits) ?? 9999999999)
        }
        let tokensPointsRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Tokens"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter your cash reward points per purchase"
                if let num = self.user.business?.rewardModel?.tokensPerItem  {
                    $0.text = "\(num)"
                }
            }.onTextChanged {
                self.rewardModel.tokensPerItem = NSNumber(value: Int($0.digits) ?? 9999999999)
        }
        let giftCardPointsRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "GiftCard"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter your giftCard Points"
                if let num = self.user.business?.rewardModel?.giftCardPoints  {
                    $0.text = "\(num)"
                }
            }.onTextChanged {
                self.rewardModel.giftCardPoints = NSNumber(value: Int($0.digits) ?? 9999999999)
        }
        let giftCardThresholdRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "GiftCard"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter your giftCard threshold"
                if let num = self.user.business?.rewardModel?.giftCardThreshold  {
                    $0.text = "\(num)"
                }
            }.onTextChanged {
                self.rewardModel.giftCardThreshold = NSNumber(value: Int($0.digits) ?? 9999999999)
        }
        return SectionFormer(rowFormer: cashBackPercentRow,tokensPointsRow,giftCardPointsRow,giftCardThresholdRow)
    }()
    
    
    
    
    
    func configure() {
        title = "Edit Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
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
                    
                    self?.modifiedBusiness.name = self?.user.business?.name
                    self?.modifiedBusiness.fullname_lower = self?.user.business?.name?.lowercased()
                } else {
                    //self?.userModified.business?.name = $0
                    self?.modifiedBusiness.name = $0
                    
                    self?.modifiedBusiness.fullname_lower = $0.lowercased()
                }
               
        }
        
        
        let introductionRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
            $0.textView.font = .systemFont(ofSize: 15)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your business-introduction"
                $0.text = self.user.business?.about
            }.onTextChanged {
                self.modifiedBusiness.about = $0
        }
        
        let emailRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Email"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.text = self.user.business?.email ?? self.user.business?.username
                $0.enabled = false
        }
        
        
        let phoneRow = TextFieldRowFormer<PhoneFieldCell>(instantiateType: .Nib(nibName: "PhoneFieldCell")) { [weak self] in
            $0.titleLabel.text = "Phone"
            $0.textField.keyboardType = .numberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure { [weak self] in
                $0.placeholder = "Add your phone number"
                if let num = self?.user.business?.phone {
                    $0.text = "\(num)"
                }
            }.onTextChanged { [weak self] in
                self?.modifiedBusiness.phone = NSNumber(value: Int($0.digits) ?? 9999999999)
        }
        
        
        let locationRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Location"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure { [weak self] in
                $0.placeholder = "Add your location"
                $0.text = self?.user.business?.address
            }.onTextChanged { [weak self] in
                self?.modifiedBusiness.address = $0
        }
        
        let rewardModelRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")){
            $0.titleLabel.text = "Type"
            }.configure{
                let modelnames = ["Cash Back", "Token", "Gift Card", "Coupon", "Inventory"]
                
                $0.pickerItems = modelnames.map {
                    InlinePickerItem(title: $0)
                }
                
                if let modelname = self.user.business?.rewardModel?.rewardModelName{
                    $0.selectedRow = modelnames.index(of: modelname) ?? 0
                    
                }
                
            }.onValueChanged {
                //self.modifiedBusiness.rewardModel?.rewardModelName = $0.title
                self.rewardModel.rewardModelName = $0.title
                if ($0.title == "Cash Back") {
                    self.rewardModel.modelType = NSNumber(value: 1)
                }else if($0.title == "Token") {
                    self.rewardModel.modelType = NSNumber(value: 2)
                }else if($0.title == "Gift Card"){
                    self.rewardModel.modelType = NSNumber(value: 3)
                }else if($0.title == "Coupon"){
                    self.rewardModel.modelType = NSNumber(value: 4)
                }else {
                    self.rewardModel.modelType = NSNumber(value: 5)
                }
                
                
        }
        
        let moreRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Add more information ?"
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            }.configure {
                $0.switched = moreInfo
                $0.switchWhenSelected = true
            }.onSwitchChanged { [weak self] in
                self?.moreInfo = $0
                self?.switchInfomationSection()
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
        let aboutSection = SectionFormer(rowFormer: nameRow, emailRow, phoneRow, locationRow)
            .set(headerViewFormer: createHeader("About"))
        let rewardModelSection = SectionFormer(rowFormer: rewardModelRow,moreRow).set(headerViewFormer: createHeader("Reward Model"))
        let securitySection = SectionFormer(rowFormer: changePasswordRow)
            .set(headerViewFormer: createHeader("Security"))

        
        
        former.append(sectionFormer: imageSection, introductionSection, aboutSection,  securitySection,rewardModelSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
        
   
    }
    
    private lazy var subRowFormers: RowFormer = {
            return CheckRowFormer<FormCheckCell>() {
                $0.titleLabel.text = "Enter more detail"
                $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            }
    }()
    

    private func insertRows(sectionTop: RowFormer, sectionBottom: RowFormer) -> (Bool) -> Void {
        return { [weak self] insert in
            guard let `self` = self else { return }
            if insert {
            
                self.former.insertUpdate(rowFormers: [self.subRowFormers], below: sectionBottom)
                
            } else {
                self.former.removeUpdate(rowFormers: [self.subRowFormers])
            }
        }
    }
    
    private func switchInfomationSection() {
        if moreInfo {
            former.insertUpdate(sectionFormer: informationSection, toSection: former.numberOfSections, rowAnimation: .top)
        } else {
            former.removeUpdate(sectionFormer: informationSection, rowAnimation: .top)
        }
    }
    

    
    @objc
    func didTapSave(){
        API.shared.showProgressHUD(ignoreUserInteraction: true)
       
        user.business?.name = modifiedBusiness.name
        user.business?.about = modifiedBusiness.about
        user.business?.phone = modifiedBusiness.phone
        user.business?.address = modifiedBusiness.address
        user.business?.rewardModel?.rewardModelName = rewardModel.rewardModelName
        user.business?.rewardModel?.modelType = rewardModel.modelType
        user.business?.rewardModel?.cashBackPercent = rewardModel.cashBackPercent
        user.business?.rewardModel?.tokensPerItem = rewardModel.tokensPerItem
        user.business?.rewardModel?.giftCardPoints = rewardModel.giftCardPoints
        user.business?.rewardModel?.giftCardThreshold = rewardModel.giftCardThreshold
        user.business?.image = modifiedBusiness.image
        user.business?.saveInBackground() { [weak self] success, error in
            print()
            API.shared.dismissProgressHUD()
            if success{
                self?.handleError("Profile Updated")
                self?.navigationController?.popViewController(animated: true)
            }else{
                self?.handleError(error?.localizedDescription)
            }
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




