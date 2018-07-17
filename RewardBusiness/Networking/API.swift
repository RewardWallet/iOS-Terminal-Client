//
//  API.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-05-31.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import Foundation
import Parse
import SVProgressHUD

class API: NSObject {
    
    // Shared Singleton
    static let shared = API()
    
    private var rewardBeamerHost = "http://localhost:5000"
    
    private var isIgnoreingUserInteraction: Bool {
        return UIApplication.shared.isIgnoringInteractionEvents
    }
    
    // MARK: - Initialization
    
    /// Initialization private, use the static `shared` property
    override private init() {
        super.init()
        SVProgressHUD.setHapticsEnabled(true)
        SVProgressHUD.setRingRadius(30)
        SVProgressHUD.setMinimumSize(CGSize(width: 75, height: 75))
        SVProgressHUD.setBackgroundColor(UIColor(r: 250, g: 250, b: 250))
    }
    
    func initialize() {
        
        [User.self, Transaction.self, Business.self, RewardModel.self, DigitalCard.self].forEach { $0.registerSubclass() }
        Parse.setLogLevel(.debug)
        Parse.enableLocalDatastore()
    
        let config = ParseClientConfiguration {
            $0.applicationId = "5ejBLYkzVaVibHAIIQZvbawrEywUCNqpDFVpHgU"
            $0.clientKey = "oR3Jp5YMyxSBu6r6nh9xuYQD5AcsdubQmvATY1OEtXo"
            $0.server = "https://nathantannar.me/api/prod/"
            $0.isLocalDatastoreEnabled = true
        }
        Parse.initialize(with: config)
    }
    
    // MARK: - Methods [Public]
    
    func showProgressHUD(ignoreUserInteraction: Bool) {
        SVProgressHUD.show()
        if ignoreUserInteraction {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func dismissProgressHUD() {
        SVProgressHUD.dismiss()
        if isIgnoreingUserInteraction {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func showSuccessHUD(for duration: TimeInterval = 1) {
        SVProgressHUD.showSuccess(withStatus: "Success")
        SVProgressHUD.dismiss(withDelay: duration)
    }
    
    func fetchRecommendedBusinesses(inBackground completion: @escaping ([Business])->Void) {
        
        guard let query = Business.query() as? PFQuery<Business> else { fatalError() }
        query.findObjectsInBackground { (objects, error) in
            guard let businesses = objects, error == nil else {
                print(error ?? "Error")
                return
            }
            completion(businesses)
        }
    }
    
    func fetchTransactions(inBackground completion: @escaping ([Transaction])->Void) {
        
        guard let user = User.current(), let query = Transaction.query() as? PFQuery<Transaction> else { fatalError() }
        query.whereKey("user", equalTo: user)
        query.addDescendingOrder("updatedAt")
        query.includeKeys(["business"])
        query.findObjectsInBackground { (objects, error) in
            guard let transactions = objects, error == nil else {
                print(error ?? "Error")
                return
            }
            completion(transactions)
        }
    }
    
    func fetchInventoryList(inBackground completion: @escaping ([Inventory])->Void) {

        guard let business = User.current()?.business, let query = Inventory.query() as? PFQuery<Inventory> else { fatalError() }
        
        query.whereKey("business", equalTo: business)
        query.includeKeys(["business", "rewardModel.coupon", "rewardModel"])
        query.findObjectsInBackground { (objects, error) in
            guard let inventorys = objects, error == nil else {
                print(error ?? "Error")
                return
            }
            completion(inventorys)
        }
    }

    func closeTransaction(transactionId: String, inBackground block: (([String:Any]?, Error?)->Void)?) {
        
        guard let userId = User.current()?.objectId else { return }
        let params: [AnyHashable: Any] = ["transactionId": transactionId, "userId": userId]
        PFCloud.callFunction(inBackground: "closeTransaction", withParameters: params) { (response, error) in
            block?(response as? [String:Any], error)
        }
        
    }
    
    func fetchBusinesses(filtered filter: String, completion: @escaping ([Business])->Void) {
        
        var queries = [PFQuery<PFObject>]()
        
        guard let nameQuery = Business.query() else { fatalError() }
        nameQuery.whereKey("name", contains: filter)
        queries.append(nameQuery)
        
        guard let addressQuery = Business.query() else { fatalError() }
        addressQuery.whereKey("address", contains: filter)
        queries.append(addressQuery)
        
        guard let categoryQuery = Business.query() else { fatalError() }
        categoryQuery.whereKey("categories", contains: filter)
        queries.append(categoryQuery)
        
        let query = PFQuery.orQuery(withSubqueries: queries)
        query.includeKey("rewardModel")
        query.limit = 10
        query.findObjectsInBackground { (objects, error) in
            guard let businesses = objects as? [Business], error == nil else {
                print(error ?? "Error")
                return
            }
            completion(businesses)
        }
    }
    
    func openTransaction(amount: Double, itemCount: Int, completion: @escaping ([String:Any]?)->Void) {
        let params: [AnyHashable: Any] = ["businessId": User.current()?.business?.objectId ?? "", "amount": amount, "itemCount": itemCount]
        PFCloud.callFunction(inBackground: "openTransaction", withParameters: params) { (response, error) in
            let json = response as? [String:Any]
            completion(json)
        }
    }
    
    func openTransactionOnRewardBeamer(amount: Double, itemCount: Int, completion: @escaping ([String:Any]?)->Void) {
        let params: [String: Any] = ["businessId": User.current()?.business?.objectId ?? "", "amount": amount, "itemCount": itemCount]
        
        let url = URL(string: rewardBeamerHost + "/openTransaction")!
        var request = URLRequest(url: url)
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            if let dict = json as? [String:Any] {
                completion(dict)
            } else if let str = json as? String {
                completion(["result":str])
            }
        }.resume()
    }
    
    func openRedeemTransaction(points: Double, completion: @escaping ([String:Any]?)->Void) {
        let params: [AnyHashable: Any] = ["points": points, "businessId": User.current()?.business?.objectId ?? ""]
        PFCloud.callFunction(inBackground: "openRedeemTransaction", withParameters: params) { (response, error) in
            let json = response as? [String:Any]
            completion(json)
        }
    }
    
    func openRedeemTransactionOnRewardBeamer(points: Double, completion: @escaping ([String:Any]?)->Void) {
        let params: [String: Any] = ["businessId": User.current()?.business?.objectId ?? "", "points": points]
        
        let url = URL(string: rewardBeamerHost + "/openRedeemTransaction")!
        var request = URLRequest(url: url)
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            if let dict = json as? [String:Any] {
                completion(dict)
            } else if let str = json as? String {
                completion(["result":str])
            }
            }.resume()
    }
    
    func closeTransaction(transactionId: String, userId: String, completion: @escaping ([String:Any]?)->Void) {
        let params: [AnyHashable: Any] = ["transactionId": transactionId, "userId": userId]
        PFCloud.callFunction(inBackground: "closeTransaction", withParameters: params) { (response, error) in
            let json = response as? [String:Any]
            completion(json)
        }
    }
    
    
}

