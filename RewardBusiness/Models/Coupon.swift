//
//  Coupon.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2018-06-21.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import Parse

class Coupon: PFObject {
    
    @NSManaged var business: User?
    @NSManaged var expireDate: Date?
    @NSManaged var text: String?
    @NSManaged var image: PFFile
}

extension Coupon: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Coupon"
    }
}

