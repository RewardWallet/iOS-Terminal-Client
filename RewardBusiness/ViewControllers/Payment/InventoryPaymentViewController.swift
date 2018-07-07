//
//  InventoryPaymentViewController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-07-06.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//


import UIKit
import Former
import Parse
import AlertHUDKit
import Kingfisher


final class InventoryPaymentViewController: FormViewController{
    
    // MARK: Properties
    private var inventories: [Inventory] = []
    
    // MARK: Initialization
    init(for inventories: [Inventory]){
        self.inventories = inventories
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(inventories, "aaaaa")
        configure()
    }
    
    // MARK: Private
    
  
    private func configure() {
        title = "Shopping List"
        tabBarItem = UITabBarItem.init(title: title, image: UIImage.icon_user , selectedImage: UIImage.iconCheckout)
        // Create RowFomers
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapdone))
        
        
        
        
        
        
        let stepperRow = StepperRowFormer<InventoryTableViewCell>(){
            $0.titleLabel.text = "ItemName"
            $0.subtitleLabel.text = "price"
            
            }.displayTextFromValue { "\(Int($0))" }
        
        
        
        // Create SectionFormers
        
    
        
        let sectionFormer1 = SectionFormer(rowFormer: stepperRow)
        
     
        former.append(sectionFormer: sectionFormer1)
    }
    
    @objc
    func didTapdone(){
        //perform transaction
    }
    
    
}





