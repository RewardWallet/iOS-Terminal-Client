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
    
    var isPointsPerPurchase: Bool = false
    
    var rewardModel: RewardModel {
        if user.business?.rewardModel == nil {
            user.business?.rewardModel = RewardModel()
        }
        return user.business!.rewardModel!
    }
    
    private var couponDescription: String = ""
    private var couponExpiry: Date = Date()
    private var rewardModelSection: SectionFormer?

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
                    if let key = self?.user.business?.image?.url {
                            KingfisherManager.shared.cache.removeImage(forKey: key)
                        }
                        let file = PFFile(name: "picture.jpg", data: imageData)
                        self?.modifiedBusiness.image = file
                }
                self?.present(imagePicker, animated: true, completion: nil)
        }
    }()

    
    fileprivate lazy var cashBackPercentRow: TextFieldRowFormer<ProfileFieldCell> = {
        TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) {
            $0.titleLabel.text = "Cash Back"
            $0.textField.keyboardType = .decimalPad
            $0.textField.inputAccessoryView = self.formerInputAccessoryView
            }.configure {
                $0.placeholder = "% of total"
                if let num = self.rewardModel.cashBackPercent  {
                    $0.text = "\(num)"
                }
            }.onTextChanged {
                self.rewardModel.cashBackPercent = NSNumber(value: Int($0.digits) ?? 0)
        }
    }()
    
    fileprivate lazy var tokenPointsRows: [RowFormer] = {
        
        let pointsPerItem = self.rewardModel.tokensPerItem?.doubleValue ?? 0
        self.isPointsPerPurchase = pointsPerItem < 0
        
        let inputRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) {
                $0.titleLabel.text = "Tokens"
                $0.textField.keyboardType = .decimalPad
                $0.textField.inputAccessoryView = self.formerInputAccessoryView
            }.configure {
                $0.placeholder = self.isPointsPerPurchase ? "Points per purchase" : "Points per item"
                $0.text = self.isPointsPerPurchase ? "\(-pointsPerItem)" : "\(pointsPerItem)"
            }.onTextChanged {
                if self.isPointsPerPurchase {
                    self.rewardModel.tokensPerItem = NSNumber(value: -(Int($0.digits) ?? 0))
                } else {
                    self.rewardModel.tokensPerItem = NSNumber(value: Int($0.digits) ?? 0)
                }
        }
        let switchRow = SwitchRowFormer<FormSwitchCell>() {
                $0.titleLabel.text = "Per Purchase"
                $0.titleLabel.font = .boldSystemFont(ofSize: 15)
                $0.switchButton.onTintColor = .primaryColor
            }.configure {
                $0.switched = self.isPointsPerPurchase
            }.onSwitchChanged { isPerPurchase in
                
                inputRow.cell.textField.placeholder = isPerPurchase ? "Points per purchase" : "Points per item"
                self.isPointsPerPurchase = isPerPurchase
                if self.isPointsPerPurchase {
                    self.rewardModel.tokensPerItem = NSNumber(value: -(Int(inputRow.cell.textField.text?.digits ?? "0") ?? 0))
                } else {
                    self.rewardModel.tokensPerItem = NSNumber(value: Int(inputRow.cell.textField.text?.digits ?? "0") ?? 0)
                }
        }
        return [inputRow, switchRow]
    }()
    
    fileprivate lazy var giftCardPointsRows: [TextFieldRowFormer<ProfileFieldCell>] = {
        let giftCardPointsRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Gift Card"
            $0.textField.keyboardType = .decimalPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Points per purchase"
                if let num = self.rewardModel.giftCardPoints  {
                    $0.text = "\(num)"
                }
            }.onTextChanged {
                self.rewardModel.giftCardPoints = NSNumber(value: Int($0.digits) ?? 0)
        }
        let giftCardThresholdRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Gift Card"
            $0.textField.keyboardType = .decimalPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Minimum purchase"
                if let num = self.rewardModel.giftCardThreshold  {
                    $0.text = "\(num)"
                }
            }.onTextChanged {
                self.rewardModel.giftCardThreshold = NSNumber(value: Int($0.digits) ?? 9999999999)
        }
        return [giftCardPointsRow, giftCardThresholdRow]
    }()
    
    fileprivate lazy var couponRows: [RowFormer] = {
        let descriptionRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
            $0.textView.font = .systemFont(ofSize: 15)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Coupon Description"
                $0.text = self.rewardModel.coupon?.text
            }.onTextChanged {
                self.couponDescription = $0
                self.rewardModel.coupon?.text = $0
        }
        let expiryRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "Expires"
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            $0.displayLabel.font = .systemFont(ofSize: 15)
            }.configure {
                $0.date = self.rewardModel.coupon?.expireDate ?? Date()
            }.inlineCellSetup {
                $0.datePicker.date = self.rewardModel.coupon?.expireDate ?? Date()
                $0.datePicker.datePickerMode = .dateAndTime
            }.onDateChanged {
                self.couponExpiry = $0
                self.rewardModel.coupon?.expireDate = $0
            }.displayTextFromDate(String.mediumDateShortTime)
        return [descriptionRow, expiryRow]
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
            }.configure {
                let modelnames = ["Select One", "Cash Back", "Token", "Gift Card", "Coupon", "Inventory"]
                $0.pickerItems = modelnames.map {
                    InlinePickerItem(title: $0)
                }
                if let modelType = self.rewardModel.modelType?.intValue {
                    $0.selectedRow = modelType
                }
            }.onValueChanged {
                
                guard let rmSection = self.rewardModelSection else { return }
                
                let rowsToRemove: [RowFormer] = [1..<rmSection.numberOfRows].flatMap {
                    return rmSection.rowFormers[$0]
                }
                self.former.removeUpdate(rowFormers: rowsToRemove, rowAnimation: .automatic)
                
                if ($0.title == "Cash Back") {
                    self.rewardModel.modelType = NSNumber(value: 1)
                    self.former.insertUpdate(rowFormer: self.cashBackPercentRow, below: self.rewardModelSection!.firstRowFormer!, rowAnimation: .automatic)
                } else if ($0.title == "Token") {
                    self.rewardModel.modelType = NSNumber(value: 2)
                    self.former.insertUpdate(rowFormers: self.tokenPointsRows, below: self.rewardModelSection!.firstRowFormer!, rowAnimation: .automatic)
                } else if ($0.title == "Gift Card"){
                    self.rewardModel.modelType = NSNumber(value: 3)
                    self.former.insertUpdate(rowFormers: self.giftCardPointsRows, below: self.rewardModelSection!.firstRowFormer!, rowAnimation: .automatic)
                } else if ($0.title == "Coupon") {
                    self.rewardModel.modelType = NSNumber(value: 4)
                    self.former.insertUpdate(rowFormers: self.couponRows, below: self.rewardModelSection!.firstRowFormer!, rowAnimation: .automatic)
                } else if ($0.title == "Inventory") {
                    self.rewardModel.modelType = NSNumber(value: 5)
                } else {
                    self.rewardModel.modelType = NSNumber(value: 0)
                }
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
        
        
        let type = rewardModel.modelType?.intValue ?? 0
        switch type {
        case 1:
            rewardModelSection = SectionFormer(rowFormer: rewardModelRow, cashBackPercentRow).set(headerViewFormer: createHeader("Reward Model"))
        case 2:
            rewardModelSection = SectionFormer(rowFormer: rewardModelRow, tokenPointsRows[0], tokenPointsRows[1]).set(headerViewFormer: createHeader("Reward Model"))
        case 3:
            rewardModelSection = SectionFormer(rowFormer: rewardModelRow, giftCardPointsRows[0], giftCardPointsRows[1]).set(headerViewFormer: createHeader("Reward Model"))
        case 4:
            rewardModelSection = SectionFormer(rowFormer: rewardModelRow, couponRows[0], couponRows[1]).set(headerViewFormer: createHeader("Reward Model"))
        default:
            rewardModelSection = SectionFormer(rowFormer: rewardModelRow).set(headerViewFormer: createHeader("Reward Model"))
        }
        
        
        
        let securitySection = SectionFormer(rowFormer: changePasswordRow)
            .set(headerViewFormer: createHeader("Security"))

        
        
        former.append(sectionFormer: imageSection, introductionSection, aboutSection,  securitySection, rewardModelSection!)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
        
   
    }
    

    
    @objc
    func didTapSave(){
        API.shared.showProgressHUD(ignoreUserInteraction: true)
        
        if rewardModel.modelType?.intValue == 4 && rewardModel.coupon == nil {
            // create coupon
            let coupon = Coupon()
            coupon.business = user.business
            coupon.text = couponDescription
            coupon.expireDate = couponExpiry
            do {
                try coupon.save()
            } catch let error {
                handleError(error.localizedDescription)
            }
            rewardModel.coupon = coupon
        }
       
        user.business?.name = modifiedBusiness.name ?? user.business?.name
        user.business?.about = modifiedBusiness.about ?? user.business?.about
        user.business?.phone = modifiedBusiness.phone ?? user.business?.phone
        user.business?.address = modifiedBusiness.address ?? user.business?.address
        user.business?.rewardModel?.modelType = rewardModel.modelType ?? user.business?.rewardModel?.modelType
        user.business?.rewardModel?.cashBackPercent = rewardModel.cashBackPercent ?? user.business?.rewardModel?.cashBackPercent
        user.business?.rewardModel?.tokensPerItem = rewardModel.tokensPerItem ?? user.business?.rewardModel?.tokensPerItem
        user.business?.rewardModel?.giftCardPoints = rewardModel.giftCardPoints ?? user.business?.rewardModel?.giftCardPoints
        user.business?.rewardModel?.giftCardThreshold = rewardModel.giftCardThreshold ?? user.business?.rewardModel?.giftCardThreshold
        user.business?.image = modifiedBusiness.image ?? user.business?.image
        user.business?.saveInBackground() { [weak self] success, error in
            print()
            API.shared.dismissProgressHUD()
            if success{
                self?.handleSuccess("Profile Updated")
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




