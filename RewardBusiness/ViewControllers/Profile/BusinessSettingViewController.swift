//
//  BusinessSettingViewController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-05-26.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit
import IGListKit
import Parse

class BusinessSettingViewController: ListViewController{

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
//    fileprivate let business: Business
//
//    init(for business: Business){
//        self.business = business
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    var business : Business
//
//    // MARK: Public
//    init(business: Business){
//        self.business = business
//        super.init(nibName: nil, bundle: nil)
//        let query = PFQuery(className: "Business")
//        query.fromLocalDatastore()
//        query.getObjectInBackground(withId: "rqosV8jixE").continueWith { (task: BFTask!) -> Any? in
//            if task.error != nil{
//                return task
//            }
//            return task
//        }
//
//
//
//
//
//    }
//
//
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        // Do any additional setup after loading the view.
        title = "Account Profile"
       
  
        tabBarItem = UITabBarItem.init(title: title, image: UIImage.icon_user , selectedImage: UIImage.icon_user)
        adapter.dataSource = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = true
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adapter.reloadData(completion: nil)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // If pushing a UIViewController onto the stack, unhide the UINavigationBar
        guard (navigationController?.viewControllers.count ?? 1) > 1 else { return }
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func fetchBusiness(){
        API.shared.fetchBusinesses(filtered: "Starbucks") { (business) in
            //set title name equals business name
            self.title = business[0].name!
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - ListAdapterDataSource
extension BusinessSettingViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let user = User.current() else { return [] }
        return [user]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return AccountSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}



