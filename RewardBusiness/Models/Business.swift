//
//  Business.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-05-31.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import Foundation
import Parse
import IGListKit

final class Business: PFObject {
    
    @NSManaged var username: String?
    @NSManaged var name: String?
    @NSManaged var image: PFFile?
    @NSManaged var address: String?
    @NSManaged var category: String?
    @NSManaged var email: String?
    @NSManaged var about: String?
    @NSManaged var distributionModel: NSNumber?
    
//    /// Saves the object to the server
//    ///
//    /// - Parameter block: completion block
//    override func saveInBackground(block: PFBooleanResultBlock? = nil) {
//        super.saveInBackground { success, error in
//            block?(success, error)
//        }
//    }
//
//    /// Logs in a Business and sets them as the current Business
//    ///
//    /// - Parameters:
//    ///   - email: Email Credentials
//    ///   - password: Password Credentials
//    ///   - completion: A completion block with a result indicating if the login was successful
//    class func loginInBackground(email: String, password: String, completion: ((Bool, Error?) -> Void)?) {
//
//        PFObject.logInWithUsername(inBackground: email, password: password) { (user, error) in
//            completion?(error == nil, error)
//            if user != nil {
//                PushNotication.shared.registerDeviceInstallation()
//            }
//        }
//
//    }
//
//    /// Signs up a user in the background using their email as their username
//    ///
//    /// - Parameters:
//    ///   - email: Email
//    ///   - password: Password (8 character min)
//    ///   - completion: Result
//    class func signUpInBackground(email: String, password: String, completion: ((Bool, Error?) -> Void)?) {
//
//        let user = User()
//        user.email = email
//        user.username = email
//        user.password = password
//        user.signUpInBackground { (success, error) in
//            completion?(error == nil, error)
//            if success {
//                PushNotication.shared.registerDeviceInstallation()
//            }
//        }
//    }
//
//    /// Logs out the user in the background and unregisters the devices installation token
//    ///
//    /// - Parameter completion: Result
//    class func logoutInBackground(_ completion: ((Bool, Error?) -> Void)?) {
//
//        PFUser.logOutInBackground { (error) in
//            PushNotication.shared.unregisterDeviceInstallation()
//            completion?(error == nil, error)
//        }
//    }
}

extension Business: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Business"
    }
}

extension Business: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
}

