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
    private var selected: [String:Int] = [:]
    var userId : String = ""
    var isRedeem: Bool = false
   
    
    // MARK: Initialization
    init(){
        super.init(nibName: nil, bundle: nil)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Shopping List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next" , style:.plain, target: self, action: #selector(didTapNext))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        fetchInventory()
        
        
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

      
        
        let cells: [StepperRowFormer<InventoryTableViewCell>] = inventories.map { item in
            return StepperRowFormer<InventoryTableViewCell>() {
                $0.titleLabel.text = item.name
                $0.subtitleLabel.text = item.price?.stringValue
                }.onValueChanged { count in
                    self.selected[item.objectId!] = Int(count)
                    print("selectedCounts:",  count)
            }
        }
        
        
  
        
        
        // Create SectionFormers
        
        
        
        
        let sectionFormer1 = SectionFormer(rowFormers: cells)
        former.append(sectionFormer: sectionFormer1)
    }
    
    @objc
    func didTapNext(){
        //perform transaction
        
        let objectIds: [String] = selected.map { (pair) -> [String] in
            var ids = [String]()
            for _ in 0..<pair.value {
                ids.append(pair.key)
            }
            return ids
        }.flatMap { $0 }
        
        let amount: Double = selected.map { (pair) -> [Double] in
            var amounts = [Double]()
            for _ in 0..<pair.value {
                let index = self.inventories.index(where: { $0.objectId == pair.key })!
                amounts.append(self.inventories[index].price?.doubleValue ?? 0)
            }
            return amounts
        }.flatMap { $0 }.reduce(0, +)
        
  
        
        
        let Openparams: [AnyHashable: Any] = ["amount": amount, "inventoryItems": objectIds ,"businessId": User.current()?.business?.objectId]
        PFCloud.callFunction(inBackground: "openTransaction", withParameters: Openparams) { (response, error) in
            let json = response as? [String:Any]
            if let transactionId = json?["objectId"] {
                let info = [self.isRedeem, transactionId] as [Any]
                guard let viewController = AppRouter.shared.viewController(for: .qrcode, context: info) else{ return }
                AppRouter.shared.present(viewController, wrap: PrimaryNavigationController.self, from: self, animated: true, completion: nil)
                
                
//
//                let Closeparams: [AnyHashable: Any] = ["transactionId": transactionId, "userId": self.userId]
//                PFCloud.callFunction(inBackground: "closeTransaction", withParameters: Closeparams) { (response, error) in
//                    let json = response as? [String:Any]
//                    let pointsAdded = json?["pointsAdded"]
//                    print(pointsAdded)
//                }
            }
            
        }

        
    }
    
    @objc
    func didTapCancel(){
        AppRouter.shared.present(.checkout, wrap: nil, from: nil, animated: true, completion: nil)
    }
 
    
    
}






