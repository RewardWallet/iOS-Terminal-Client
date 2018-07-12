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
    @NSManaged var text: String
    @NSManaged var business: Business?
    @NSManaged var rewardModel: RewardModel?

    override init() {
        super.init()
    }
    
    convenience init(for business: Business){
        self.init()
        self.business = business
        self.rewardModel = RewardModel()
        self.rewardModel?.modelType = NSNumber(value: 1)
    }
    
    override func saveInBackground(block: PFBooleanResultBlock? = nil) {
        super.saveInBackground { success, error in
            block?(success, error)
        }
    }
    
}

extension Inventory: PFSubclassing{
    static func parseClassName() -> String {
        return "Inventory"
    }
}
