//
//  Transaction.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-05-31.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import Foundation
import Parse
import IGListKit

final class Transaction: PFObject {
    
    //    @NSManaged var someValue: String?
    @NSManaged var transactionId : String?
    
}

extension Transaction: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Transaction"
    }
    
}
