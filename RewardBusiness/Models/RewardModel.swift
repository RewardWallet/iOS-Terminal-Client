//
//  RewardModel.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2018-06-14.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import Parse
import IGListKit

final class RewardModel: PFObject {
    
    @NSManaged var modelType: NSNumber?
    @NSManaged var cashBackPercent: NSNumber?
    @NSManaged var giftCardPoints: NSNumber?
    @NSManaged var giftCardThreshold: NSNumber?
    @NSManaged var tokensPerItem: NSNumber?
    
    func modelTypeDescription() -> String? {
        if let model = modelType?.intValue {
            switch model {
            case 1:
                let percent = cashBackPercent?.doubleValue.roundTwoDecimal() ?? "0"
                return "\(percent)% Cash Back"
            case 2:
                let tokens = tokensPerItem?.doubleValue ?? 0
                if tokens < 0 {
                    return "\((-tokens).roundTwoDecimal()) Points Per Purchase"
                }
                return "\(tokens.roundTwoDecimal()) Points Per Item"
            case 3:
                let points = giftCardPoints?.doubleValue.roundTwoDecimal() ?? "0"
                let threshold = giftCardThreshold?.doubleValue.toDollars() ?? ""
                return "\(points) Points for every \(threshold) purchase"
            case 4:
                return "Coupon Rewards"
            default:
                return "Item Based"
            }
        }
        return nil
    }
    
}

extension RewardModel: PFSubclassing {
    
    static func parseClassName() -> String {
        return "RewardModel"
    }
    
}
