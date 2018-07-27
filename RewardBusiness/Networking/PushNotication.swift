//
//  PushNotication.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-05-31.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import Foundation
import Parse

class PushNotication: NSObject {
    
    // MARK: - Properties
    
    static let shared = PushNotication()
    
    // MARK: - Initialization
    
    /// Initialization private, use the static `shared` property
    override private init() { super.init() }
    
    // MARK: - Public API
    
    func registerDeviceInstallation() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        guard let installation = PFInstallation.current() else { return }
        installation["user"] = PFUser.current()
        installation.saveInBackground(block: { (success, error) in
            if error != nil {
                print("parsePushUserAssign save error.")
            }
        })
    }
    
    func unregisterDeviceInstallation() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        guard let installation = PFInstallation.current() else { return }
        installation.remove(forKey: "user")
        installation.saveInBackground { (succeeded: Bool, error: Error?) -> Void in
            if error != nil {
                print("parsePushUserResign save error")
            }
        }
    }
    
    
    func sendNotificationToCustomers(message: String){
        let params: [AnyHashable: Any] = ["message": message, "businessId": User.current()?.business?.objectId ?? ""]
        PFCloud.callFunction(inBackground: "sendNotificationToCustomers", withParameters: params) { (object, error) in
            if error == nil {
                print("#### PUSH OK")
            }else{
                print("#### ERROR: \(error.debugDescription)")
            }
        }
    }
    
    //    class func send(to user: User, message: String) {
    //
    //        PFCloud.callFunction(inBackground: "pushToUser",
    //                             withParameters: ["user": user.objectId!, "message": message],
    //                             block: { (object, error) in
    //            if error == nil {
    //                print("##### PUSH OK")
    //            } else {
    //                print("##### ERROR: \(error.debugDescription)")
    //            }
    //        })
    //    }
    
}

