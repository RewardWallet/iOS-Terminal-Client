//
//  InventoryCell.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-06-27.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit

class InventoryCell: UICollectionViewCell {
    @IBOutlet weak var InventoryName: UILabel!
    
    @IBOutlet weak var InventoryImage: UIImageView!
    @IBOutlet weak var UnitCost: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    func setupView(){
        backgroundColor = .primaryColor
    }
    

    
    func setInventoryName(text: String){
        self.InventoryName.text = text
    }
    
    func setInventoryImage(image: UIImage){
        self.InventoryImage.image = image
    }
    
    func setCost(text: String){
        self.UnitCost.text = text
    }
}
