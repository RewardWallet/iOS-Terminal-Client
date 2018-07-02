//
//  UIAlertController+Extensions.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-07-01.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//


import UIKit

extension UIAlertController {
    
    func removeTransparency() {
        view.subviews.last?.subviews.last?.backgroundColor = .white
        view.subviews.last?.subviews.last?.layer.cornerRadius = 16
    }
    
}

