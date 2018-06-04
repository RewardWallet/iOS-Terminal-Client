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
    
}

extension Transaction: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Transaction"
    }
    
}

extension Transaction: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
}
