//
//  User.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-05-31.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit
import IGListKit
import Parse

class User: PFUser {
    
    @NSManaged var picture: PFFile?
    @NSManaged var fullname: String?
    @NSManaged var fullname_lower: String?
    @NSManaged var address: String?
    @NSManaged var phone: NSNumber?
    @NSManaged var business: Business?
    
    override class func current() -> User? {
        return PFUser.current() as? User
    }
    
    /// Saves the object to the server
    ///
    /// - Parameter block: completion block
    override func saveInBackground(block: PFBooleanResultBlock? = nil) {
        super.saveInBackground { success, error in
            block?(success, error)
        }
    }
    
    /// Logs in a user and sets them as the current user
    ///
    /// - Parameters:
    ///   - email: Email Credentials
    ///   - password: Password Credentials
    ///   - completion: A completion block with a result indicating if the login was successful
    class func loginInBackground(email: String, password: String, completion: ((Bool, Error?) -> Void)?) {
        
        PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
            completion?(error == nil, error)
            if user != nil {
                PushNotication.shared.registerDeviceInstallation()
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
            completion?(error == nil, error)
            if success {
                PushNotication.shared.registerDeviceInstallation()
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
