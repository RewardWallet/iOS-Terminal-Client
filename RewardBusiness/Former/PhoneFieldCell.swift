//
//  PhoneFieldCell.swift
//  UserClient
//
//  Created by Nathan Tannar on 1/2/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Former
import PhoneNumberKit

final class PhoneFieldCell: UITableViewCell, TextFieldFormableRow {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: PhoneNumberTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColor.black
        textField.textColor = UIColor.black
    }
    
    func formTextField() -> UITextField {
        return textField
    }
    
    func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    func updateWithRowFormer(_ rowFormer: RowFormer) {}
}
