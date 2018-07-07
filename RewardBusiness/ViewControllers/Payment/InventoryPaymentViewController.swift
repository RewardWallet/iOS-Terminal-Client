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
    init(){
        super.init(nibName: nil, bundle: nil)
        title = "Shopping List"
        tabBarItem = UITabBarItem(title: title, image: UIImage.iconCheckout , selectedImage: UIImage.iconCheckout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Private
    
    private func fetchInventory() {
        
        API.shared.fetchInventoryList { (inventories) in
            self.inventories = inventories
            print(self.inventories)
            self.configure()
        }
    }
    
  
    private func configure() {
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





