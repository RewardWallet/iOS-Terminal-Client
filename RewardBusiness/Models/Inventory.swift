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
    @NSManaged var unitCost: NSNumber?
    @NSManaged var image: PFFile?
    @NSManaged var categories: [String]?
    @NSManaged var business: Business?

    override init(){
        super.init()
    }
    
    class func addInventory(name: String, unitCost: Double, image: UIImage,
                            completeion: @escaping ((Bool, Error?)->Void) ) {
        
        let inventory = Inventory()
        inventory.name = name
        inventory.unitCost = NSNumber(value: unitCost)
        if let data = UIImageJPEGRepresentation(image, 0.75) {
            inventory.image = PFFile(data: data)
        }
        
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
