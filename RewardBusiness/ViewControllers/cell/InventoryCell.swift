//
//  InventoryCell.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-06-27.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit
import Kingfisher

class InventoryCell: UICollectionViewCell {
    @IBOutlet weak var InventoryName: UILabel!
    
    @IBOutlet weak var InventoryImage: UIImageView!
    @IBOutlet weak var UnitCost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView(){
        backgroundColor = .primaryColor
        layer.cornerRadius = 16
        clipsToBounds = true
        
    }

    func setInventoryName(text: String?){
        self.InventoryName.text = text
    }
    
    func setInventoryImage(image: Resource?){
        self.InventoryImage.kf.indicatorType = .activity
        self.InventoryImage.kf.setImage(with: image)
    }
    
    func setCost(number: NSNumber?){
        self.UnitCost.text = number?.doubleValue.toDollars()
    }
}
