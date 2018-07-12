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
    
 
    let business: Business
    let inventory: Inventory
    
    var rewardModel: RewardModel? {
        return inventory.rewardModel
    }
    
    private var couponDescription: String = ""
    private var couponExpiry: Date = Date()
    private var rewardModelSection: SectionFormer?
    
    // MARK: Public
    init(for business: Business){
        self.business = business
        self.inventory = Inventory(for: self.business)
        super.init(nibName: nil, bundle: nil)
    }
    
    init(editing inventory: Inventory) {
        self.business = inventory.business!
        self.inventory = inventory
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
            $0.iconView.kf.setImage(with: self.inventory.image)
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
                    if let key = self?.inventory.image?.url {
                        KingfisherManager.shared.cache.removeImage(forKey: key)
                    }
                    let file = PFFile(name: "picture.jpg", data: imageData)
                    self?.inventory.image = file
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
            if let num = self.rewardModel?.cashBackPercent  {
                $0.text = "\(num)"
            }
        }.onTextChanged {
            self.rewardModel?.cashBackPercent = NSNumber(value: Int($0.digits) ?? 0)
        }
    }()
    
    fileprivate lazy var tokensPointsRow: TextFieldRowFormer<ProfileFieldCell> = {
        TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) {
            $0.titleLabel.text = "Tokens"
            $0.textField.keyboardType = .decimalPad
            $0.textField.inputAccessoryView = self.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Points per item"
                if let num = self.rewardModel?.tokensPerItem  {
                    $0.text = "\(num)"
                }
            }.onTextChanged {
                self.rewardModel?.tokensPerItem = NSNumber(value: Int($0.digits) ?? 0)
        }
    }()
    
    fileprivate lazy var giftCardPointsRows: [TextFieldRowFormer<ProfileFieldCell>] = {
        let giftCardPointsRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Gift Card"
            $0.textField.keyboardType = .decimalPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Points per purchase"
                if let num = self.rewardModel?.giftCardPoints  {
                    $0.text = "\(num)"
                }
            }.onTextChanged {
                self.rewardModel?.giftCardPoints = NSNumber(value: Int($0.digits) ?? 0)
        }
        let giftCardThresholdRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Gift Card"
            $0.textField.keyboardType = .decimalPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Minimum purchase"
                if let num = self.rewardModel?.giftCardThreshold  {
                    $0.text = "\(num)"
                }
            }.onTextChanged {
                self.rewardModel?.giftCardThreshold = NSNumber(value: Int($0.digits) ?? 9999999999)
        }
        return [giftCardPointsRow, giftCardThresholdRow]
    }()
    
    fileprivate lazy var couponRows: [RowFormer] = {
        let descriptionRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
                $0.textView.font = .systemFont(ofSize: 15)
                $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Coupon Description"
                $0.text = self.rewardModel?.coupon?.text
            }.onTextChanged {
                self.couponDescription = $0
                self.rewardModel?.coupon?.text = $0
        }
        let expiryRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
                $0.titleLabel.text = "Expires"
                $0.titleLabel.font = .boldSystemFont(ofSize: 15)
                $0.displayLabel.font = .systemFont(ofSize: 15)
            }.inlineCellSetup {
                $0.datePicker.date = self.rewardModel?.coupon?.expireDate ?? Date()
                $0.datePicker.datePickerMode = .dateAndTime
            }.onDateChanged {
                self.couponExpiry = $0
                self.rewardModel?.coupon?.expireDate = $0
            }.displayTextFromDate(String.mediumDateShortTime)
        return [descriptionRow, expiryRow]
    }()
    
    
    func configure() {
        title = "Add Inventory"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapAdd))
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 100
        
        // Create RowFomers
        
        let nameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.text = self.inventory.name
                $0.placeholder = "Add Inventory name"
            }.onTextChanged {
                self.inventory.name = $0
        }
        
        
        let descriptionRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
            $0.textView.font = .systemFont(ofSize: 15)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.text = self.inventory.text
                $0.placeholder = "Add Inventory description"
            }.onTextChanged {
                self.inventory.text = $0
        }
        
        let priceRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Price"
            $0.textField.keyboardType = .decimalPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                if let price = self.inventory.price?.doubleValue {
                    $0.text = String(price)
                }
                $0.placeholder = "$0.00"
            }.onTextChanged {
                self.inventory.price = NSNumber(value: Double($0) ?? 0)
        }
        
        
        let businessRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Business"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.text = self.business.name
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
            }.configure {
                let modelnames = ["Select One", "Cash Back", "Token", "Gift Card", "Coupon"]
                $0.pickerItems = modelnames.map {
                    InlinePickerItem(title: $0)
                }
                if let modelType = self.rewardModel?.modelType?.intValue {
                    $0.selectedRow = modelType
                }
            }.onValueChanged {
                
                guard let rmSection = self.rewardModelSection else { return }
                
                let rowsToRemove: [RowFormer] = [1..<rmSection.numberOfRows].flatMap {
                    return rmSection.rowFormers[$0]
                }
                self.former.removeUpdate(rowFormers: rowsToRemove, rowAnimation: .automatic)
                
                if ($0.title == "Cash Back") {
                    self.rewardModel?.modelType = NSNumber(value: 1)
                    self.former.insertUpdate(rowFormer: self.cashBackPercentRow, below: self.rewardModelSection!.firstRowFormer!, rowAnimation: .automatic)
                } else if ($0.title == "Token") {
                    self.rewardModel?.modelType = NSNumber(value: 2)
                    self.former.insertUpdate(rowFormer: self.tokensPointsRow, below: self.rewardModelSection!.firstRowFormer!, rowAnimation: .automatic)
                } else if ($0.title == "Gift Card"){
                    self.rewardModel?.modelType = NSNumber(value: 3)
                    self.former.insertUpdate(rowFormers: self.giftCardPointsRows, below: self.rewardModelSection!.firstRowFormer!, rowAnimation: .automatic)
                } else if ($0.title == "Coupon") {
                    self.rewardModel?.modelType = NSNumber(value: 4)
                    self.former.insertUpdate(rowFormers: self.couponRows, below: self.rewardModelSection!.firstRowFormer!, rowAnimation: .automatic)
                } else {
                    self.rewardModel?.modelType = NSNumber(value: 0)
                }
        }
        
        // Create SectionFormers
        
        let imageSection = SectionFormer(rowFormer: imageRow)
            .set(headerViewFormer: createHeader("Inventory Photo"))
        let aboutSection = SectionFormer(rowFormer: nameRow, priceRow, descriptionRow, businessRow)
            .set(headerViewFormer: createHeader("Inventory Info"))
   
        let type = rewardModel?.modelType?.intValue ?? 0
        switch type {
        case 1:
            rewardModelSection = SectionFormer(rowFormer: rewardModelRow, cashBackPercentRow).set(headerViewFormer: createHeader("Reward Model"))
        case 2:
            rewardModelSection = SectionFormer(rowFormer: rewardModelRow, tokensPointsRow).set(headerViewFormer: createHeader("Reward Model"))
        case 3:
            rewardModelSection = SectionFormer(rowFormer: rewardModelRow, giftCardPointsRows[0], giftCardPointsRows[1]).set(headerViewFormer: createHeader("Reward Model"))
        case 4:
            rewardModelSection = SectionFormer(rowFormer: rewardModelRow, couponRows[0], couponRows[1]).set(headerViewFormer: createHeader("Reward Model"))
        default:
            rewardModelSection = SectionFormer(rowFormer: rewardModelRow).set(headerViewFormer: createHeader("Reward Model"))
        }
        
        former.append(sectionFormer: imageSection, aboutSection, rewardModelSection!)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
    }

    @objc
    func didTapAdd(){
        
        guard inventory.price != nil, inventory.name != nil, rewardModel != nil, rewardModel?.modelType?.intValue != 0 else {
            handleError("Please enter all details")
            return
        }
        
        API.shared.showProgressHUD(ignoreUserInteraction: true)
        
        if rewardModel?.modelType?.intValue == 4 && rewardModel?.coupon == nil {
            // create coupon
            let coupon = Coupon()
            coupon.business = business
            coupon.text = couponDescription
            coupon.expireDate = couponExpiry
            do {
                try coupon.save()
            } catch let error {
                handleError(error.localizedDescription)
            }
            rewardModel?.coupon = coupon
        }
        
        inventory.saveInBackground() { (success, error) in
            API.shared.dismissProgressHUD()
            if success {
                self.handleSuccess("Inventory Added")
                self.navigationController?.popViewController(animated: true)
            }else{
                self.handleError(error?.localizedDescription)
            }
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

extension String {
    static func mediumDateShortTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}


