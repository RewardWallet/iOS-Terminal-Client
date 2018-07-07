//
//  AddInventoryViewController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-07-05.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit
import Former
import Parse
import AlertHUDKit
import Kingfisher


final class AddInventoryViewController: FormViewController{
    
 
    var user: User
    var inventory = Inventory()
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
        title = "Add Inventory"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        tableView.contentInset.top = 40
        tableView.contentInset.bottom = 40
        
        // Create RowFomers
        
        let nameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add Inventory name"
            }.onTextChanged {
                self.inventory.name = $0
        }
        
        
        let descriptionRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
            $0.textView.font = .systemFont(ofSize: 15)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add Inventory description"
            }.onTextChanged {
                self.inventory.text = $0
        }
        
        let priceRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Price"
            $0.textField.keyboardType = .decimalPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your inventory price"
            }.onTextChanged {
                //self?.inventory.unitCost = NSNumber(value: Int($0.digits) ?? 9999999999)
                self.inventory.price = NSNumber(value: Double($0) ?? 999999999)
        }
        
        
        let businessRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Business"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.text = self.user.business?.name
                $0.enabled = false
        }
        
        
        
        // Create Headers
        
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }
        
        
        
        // Create Inventory Model
        
       
        let rewardModelRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")){
            $0.titleLabel.text = "Type"
            }.configure{
                let modelnames = ["Cash Back", "Token", "Gift Card", "Coupon"]
                
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
                }else{
                    self.rewardModel.modelType = NSNumber(value: 4)
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
        
        
        
        // Create SectionFormers
        
        let imageSection = SectionFormer(rowFormer: imageRow)
            .set(headerViewFormer: createHeader("Inventory Photo"))
        let aboutSection = SectionFormer(rowFormer: nameRow, priceRow,descriptionRow, businessRow)
            .set(headerViewFormer: createHeader("Inventory Info"))
   
        let rewardModelSection = SectionFormer(rowFormer: rewardModelRow,moreRow).set(headerViewFormer: createHeader("Reward Model"))
        
        
        
        former.append(sectionFormer: imageSection, aboutSection, rewardModelSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
        
        
    }
    

    
    
    
    @objc
    func didTapAdd(){
        API.shared.showProgressHUD(ignoreUserInteraction: true)
        
//        user.business?.name = modifiedBusiness.name
//        user.business?.about = modifiedBusiness.about
//        user.business?.phone = modifiedBusiness.phone
//        user.business?.address = modifiedBusiness.address
//        user.business?.rewardModel?.rewardModelName = rewardModel.rewardModelName
//        user.business?.rewardModel?.modelType = rewardModel.modelType
//        user.business?.rewardModel?.cashBackPercent = rewardModel.cashBackPercent
//        user.business?.rewardModel?.tokensPerItem = rewardModel.tokensPerItem
//        user.business?.rewardModel?.giftCardPoints = rewardModel.giftCardPoints
//        user.business?.rewardModel?.giftCardThreshold = rewardModel.giftCardThreshold
//        user.business?.image = modifiedBusiness.image
        
        inventory.business = user.business
        inventory.rewardModel = rewardModel
        inventory.saveInBackground() { (success, error) in
            
            print()
            API.shared.dismissProgressHUD()
            if success {
                self.handleError("Inventory Added")
                self.navigationController?.popViewController(animated: true)
            }else{
                self.handleError(error?.localizedDescription)
            }
        }
        
        
        
        
//        user.business?.saveInBackground() { [weak self] success, error in
//            print()
//            API.shared.dismissProgressHUD()
//            if success{
//                self?.handleError("Profile Updated")
//                self?.navigationController?.popViewController(animated: true)
//            }else{
//                self?.handleError(error?.localizedDescription)
//            }
//        }
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




