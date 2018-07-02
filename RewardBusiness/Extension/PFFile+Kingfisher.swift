//
//  PFFile+Kingfisher.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Parse
import Kingfisher

extension PFFile: Resource {
    
    public var cacheKey: String {
        return downloadURL.absoluteString
    }
    
    public var downloadURL: URL {
        return URL(string: url ?? "http://www.google.ca")!
    }
    
}
