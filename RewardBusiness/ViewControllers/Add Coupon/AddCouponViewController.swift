//
//  AddCouponViewController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-07-26.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//


import UIKit
import Former
import Parse
import AlertHUDKit
import Kingfisher


final class AddCouponViewController: FormViewController{
    
    
    let business: Business
    
    var coupon: Coupon
    

    
    private var couponDescription: String = ""
    private var couponExpiry: Date = Date()
    private var rewardModelSection: SectionFormer?
    private var isCouponPublic: Bool = false
    
    // MARK: Public
    init(for business: Business){
        self.business = business
        self.coupon = Coupon(for: self.business )
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
    
    fileprivate lazy var couponRows: [RowFormer] = {
        let descriptionRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
            $0.textView.font = .systemFont(ofSize: 15)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add Coupon description"
                $0.text = self.coupon.text
            }.onTextChanged {
                self.couponDescription = $0
                self.coupon.text = $0
        }
        let expiryRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "Expires"
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            $0.displayLabel.font = .systemFont(ofSize: 15)
            }.configure {
                $0.date = self.coupon.expireDate ?? Date()
            }.inlineCellSetup {
                $0.datePicker.date = self.coupon.expireDate ?? Date()
                $0.datePicker.datePickerMode = .dateAndTime
            }.onDateChanged {
                self.couponExpiry = $0
                self.coupon.expireDate = $0
            }.displayTextFromDate(String.mediumDateShortTime)
        
        let isPublic = SwitchRowFormer<FormSwitchCell>(){
            $0.titleLabel.text = "Make it Public?"
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            $0.switchButton.onTintColor = .primaryColor
            }.configure{
                $0.switched = self.coupon.isPublic
            }.onSwitchChanged { [weak self] in
                self?.isCouponPublic = $0
        }
        return [descriptionRow, expiryRow, isPublic]
    }()
    
    
    func configure(){
        title = "Add Coupon"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapAdd))
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 100
        
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
        
        
        // Create SectionFormers
        
        let CouponDescriptionSection = SectionFormer(rowFormer: businessRow, couponRows[0])
            .set(headerViewFormer: createHeader("Coupon Description"))
        let CouponExpireDateSection = SectionFormer(rowFormer: couponRows[1])
            .set(headerViewFormer: createHeader("Coupon Expire Date"))
        let CouponIsPublic = SectionFormer(rowFormer: couponRows[2])
            .set(headerViewFormer: createHeader("Set to Public"))
        
        former.append(sectionFormer: CouponDescriptionSection, CouponExpireDateSection, CouponIsPublic)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
        
    }
    
    @objc
    func didTapAdd(){
        

        guard coupon.description != nil else{
            handleError("Please enter coupon description")
            return
        }
        
        
        API.shared.showProgressHUD(ignoreUserInteraction: true)
        
        
        if couponDescription != "" {
            let coupon = Coupon()
            coupon.business = business
            coupon.text = couponDescription
            coupon.expireDate = couponExpiry
            coupon.isPublic = isCouponPublic
            do{
                try coupon.save()
            } catch let error {
                handleError(error.localizedDescription)
            }
            self.coupon = coupon
        }
        
        coupon.saveInBackground() { (success, error ) in
            API.shared.dismissProgressHUD()
            if success{
                self.handleSuccess("Coupon Added")
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

