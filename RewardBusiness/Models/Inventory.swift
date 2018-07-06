//
//  Inventory.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-06-27.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import Foundation
import Parse
import IGListKit

final class Inventory: PFObject{
    
    @NSManaged var name: String?
    @NSManaged var price: NSNumber?
    @NSManaged var image: PFFile?
    @NSManaged var categories: [String]?
    @NSManaged override var description: String
    @NSManaged var business: Business?
    @NSManaged var rewardModel: RewardModel?

    override init(){
        super.init()
    }
    
    override func saveInBackground(block: PFBooleanResultBlock? = nil) {
        super.saveInBackground { success, error in
            block?(success, error)
        }
    }
    
    
    
//    class func addInventory(name: String, unitCost: Double, image: UIImage,
//                            completeion: @escaping ((Bool, Error?)->Void) ) {
//
//        let inventory = Inventory()
//        inventory.name = name
//        inventory.unitCost = NSNumber(value: unitCost)
//        if let data = UIImageJPEGRepresentation(image, 0.75) {
//            inventory.image = PFFile(data: data)
//        }
//
//        inventory.saveInBackground { (success, error) in
//            completeion(success, error)
//        }
//
//    }


    
    
    class func addInventory(name: String, unitCost: Double, image: UIImage, business: Business, completeion: @escaping ((Bool, Error?)->Void) ) {
        
        let inventory = Inventory()
        inventory.name = name
        inventory.price = NSNumber(value: unitCost)
        if let data = UIImageJPEGRepresentation(image, 0.75) {
            inventory.image = PFFile(data: data)
        }
        inventory.business = business
        inventory.rewardModel = business.rewardModel
        inventory.saveInBackground { (success, error) in
            completeion(success, error)
        }
        
    }
    
    
}

extension Inventory: PFSubclassing{
    static func parseClassName() -> String {
        return "Inventory"
    }
}
