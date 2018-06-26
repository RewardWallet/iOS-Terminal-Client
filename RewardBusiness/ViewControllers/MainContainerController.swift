//
//  MainContainerController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/20/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import DynamicTabBarController

class MainContainerController: DynamicTabBarController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "RewardWallet"
        view.backgroundColor = .backgroundColor
        tabBar.activeTintColor = .secondaryColor
        
        tabBar.layer.shadowRadius = 3
        tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBar.layer.shadowOpacity = 0.2
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        
        //        let coinItem: UIBarButtonItem = {
        //            let itemWidth: CGFloat = 40
        //            let itemHeight: CGFloat = 40
        //            let contentView = UIView(frame: CGRect(x: 0, y: 0, width: itemWidth, height: itemHeight))
        //            let button = UIButton(frame: CGRect(x: 0, y: 5, width: itemHeight - 10, height: itemHeight - 10))
        //            button.setImage(.coin, for: .normal)
        //            button.imageView?.contentMode = .scaleAspectFit
        //            button.addTarget(self, action: #selector(didTapHelp), for: .touchUpInside)
        //            contentView.addSubview(button)
        //            return UIBarButtonItem(customView: contentView)
        //        }()
        //        navigationItem.leftBarButtonItem = coinItem
        //
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
        //                                                            target: nil,
        //                                                            action: nil)
    }
    
    @objc
    func didTapHelp() {
        
    }
}

