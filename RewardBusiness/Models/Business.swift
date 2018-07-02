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
    @NSManaged var fullname_lower: String?
    @NSManaged var image: PFFile?
    @NSManaged var address: String?
    @NSManaged var category: String?
    @NSManaged var email: String?
    @NSManaged var about: String?
    @NSManaged var distributionModel: NSNumber?
    
    
    /// Saves the object to the server
    ///
    /// - Parameter block: completion block
    override func saveInBackground(block: PFBooleanResultBlock? = nil) {
        super.saveInBackground { success, error in
            block?(success, error)
        }
    }

    /// Logs in a Business and sets them as the current Business
    ///
    /// - Parameters:
    ///   - email: Email Credentials
    ///   - password: Password Credentials
    ///   - completion: A completion block with a result indicating if the login was successful
    class func loginInBackground(email: String, password: String, completion: ((Bool, Error?) -> Void)?) {

        PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
            if user != nil {
                PushNotication.shared.registerDeviceInstallation()
                guard let user = user as? User else { fatalError() }
                if user.business != nil {
                    // Pointer exists to fetch object
                    user.business?.fetchIfNeededInBackground(block: { (object, error) in
                        completion?(error == nil, error)
                    })
                } else {
                    completion?(error == nil, error)
                }
            } else {
                completion?(error == nil, error)
            }
        }

    }

    /// Signs up a user in the background using their email as their username
    ///
    /// - Parameters:
    ///   - email: Email
    ///   - password: Password (8 character min)
    ///   - completion: Result
    class func signUpInBackground(email: String, password: String, completion: ((Bool, Error?) -> Void)?) {

        let user = User()
        user.email = email
        user.username = email
        user.password = password
        user.signUpInBackground { (success, error) in
//            completion?(error == nil, error)
            if success {
                PushNotication.shared.registerDeviceInstallation()
                
                let business = Business()
                business.email = email
                business.name = email
                business.saveInBackground(block: { (success, error) in
                    if (success == false){
                        completion?(false, error)
                    }else{
                        user.business = business
                        user.saveInBackground(block: { (success, error) in
                            completion?(error == nil, error)
                        })
                    }
                })
            }else {
                completion?(false, error)
            }
        }
    }

    /// Logs out the user in the background and unregisters the devices installation token
    ///
    /// - Parameter completion: Result
    class func logoutInBackground(_ completion: ((Bool, Error?) -> Void)?) {

        PFUser.logOutInBackground { (error) in
            PushNotication.shared.unregisterDeviceInstallation()
            completion?(error == nil, error)
        }
    }
}

extension Business: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Business"
    }
}
