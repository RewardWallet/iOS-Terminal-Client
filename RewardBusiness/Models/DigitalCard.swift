//
//  DigitalCard.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-05-31.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import Foundation
import Parse
import IGListKit

final class DigitalCard: PFObject {
    
    @NSManaged var business: Business?
    @NSManaged var user: User?
    @NSManaged var points: NSNumber?
    
}

extension DigitalCard: PFSubclassing {
    
    static func parseClassName() -> String {
        return "DigitalCard"
    }
}
