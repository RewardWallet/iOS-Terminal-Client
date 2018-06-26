//
//  NavigationControllers.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-06-21.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

//
//  NavigationControllers.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

final class PrimaryNavigationController: RWNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.apply(Stylesheet.NavigationBars.primary)
    }
    
}

final class InversePrimaryNavigationController: RWNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.apply(Stylesheet.NavigationBars.inversePrimary)
    }
    
}

final class PlainNavigationController: RWNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = .secondaryColor
        navigationBar.barTintColor = .white
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
        if #available(iOS 11.0, *) {
            navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.darkGray]
        } else {
            // Fallback on earlier versions
        }
    }
    
}

