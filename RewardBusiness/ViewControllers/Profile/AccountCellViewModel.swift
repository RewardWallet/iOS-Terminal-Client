//
//  AccountCellViewModel.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import IGListKit

final class AccountCellViewModel {
    
    let text: String
    
    let icon: UIImage?
    
    let route: AppRoute?
    
    init(text: String, icon: UIImage?, route: AppRoute?) {
        self.text = text
        self.icon = icon
        self.route = route
    }
    
}

extension AccountCellViewModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return text as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let model = object as? AccountCellViewModel else { return false }
        return text == model.text
    }
    
}

