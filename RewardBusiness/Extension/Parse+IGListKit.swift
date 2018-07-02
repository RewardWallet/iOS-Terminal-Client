//
//  Parse+IGListKit.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Parse
import IGListKit

extension PFFile: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return (url ?? name) as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let file = object as? PFFile else { return false }
        return url == file.url
    }
    
}

extension PFQuery: ListDiffable {

    public func diffIdentifier() -> NSObjectProtocol {
        return self.debugDescription as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }

}

extension PFObject: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
}

extension PFGeoPoint: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
}

extension PFUser {
    
    
    public override func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let user = object as? PFUser else { return false }
        return isEqual(object) && user.updatedAt == updatedAt
    }
    
}
