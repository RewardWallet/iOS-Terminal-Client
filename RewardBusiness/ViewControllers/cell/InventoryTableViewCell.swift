//
//  InventoryTableViewCell.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-07-05.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit
import Former

class InventoryTableViewCell: FormCell, StepperFormableRow{

    // MARK: Public
    
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var subtitleLabel: UILabel!
    public private(set) weak var displayLabel: UILabel!
    public private(set) weak var stepper: UIStepper!
    
    public func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    public func formSubtitleLabel() -> UILabel?{
        return subtitleLabel
    }
    
    public func formDisplayLabel() -> UILabel? {
        return displayLabel
    }
    
    public func formStepper() -> UIStepper {
        return stepper
    }
    
    open override func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, at: 0)
        self.titleLabel = titleLabel
        
        
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        contentView.insertSubview(subtitleLabel, at: 0)
        self.subtitleLabel = subtitleLabel
        
        let displayLabel = UILabel()
        displayLabel.textColor = .lightGray
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(displayLabel, at: 0)
        self.displayLabel = displayLabel
        
        let stepper = UIStepper()
        accessoryView = stepper
        self.stepper = stepper
        
        let constraints = [
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[title]-0-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[subtitle]-0-|",
                options: [],
                metrics: nil,
                views: ["subtitle": subtitleLabel]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[display]-0-|",
                options: [],
                metrics: nil,
                views: ["display": displayLabel]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-15-[title]-10-[subtitle]-(>=0)-[display]-5-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "subtitle": subtitleLabel, "display": displayLabel]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
    
    
}

