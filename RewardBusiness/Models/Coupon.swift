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
    
    @NSManaged var business: Business?
    @NSManaged var expireDate: Date?
    @NSManaged var text: String?
    @NSManaged var image: PFFile
    @NSManaged var isPublic: Bool
    
    override init() {
        super.init()
    }
    
    convenience init(for business: Business){
        self.init()
        self.business = business
       
    }
}

extension Coupon: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Coupon"
    }
}

