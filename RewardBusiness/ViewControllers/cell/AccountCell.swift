//
//  AccountCell.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

final class AccountCell: RWCollectionViewCell {
    
    // MARK: - Properties
    
    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = UIColor(white: isHighlighted ? 0.9 : 1, alpha: 1)
        }
    }
    
    // MARK: - Subviews
    
    private let imageView = UIImageView(style: Stylesheet.ImageViews.fitted)
    
    private let textLabel = UILabel(style: Stylesheet.Labels.description)
    
    private let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.grayColor.cgColor
        return layer
    }()
    
    // MARK: - Setup
    
    override func setupView() {
        
        contentView.backgroundColor = .white
        contentView.layer.addSublayer(separator)
        
        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)
        
        imageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 8)
        imageView.anchorAspectRatio()
        
        textLabel.anchorRightOf(imageView, leftConstant: 8, rightConstant: 16)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 8, y: bounds.height - height, width: bounds.width - 16, height: height)
    }
    
}

extension AccountCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let model = viewModel as? AccountCellViewModel else { return }
        imageView.image = model.icon
        textLabel.text = model.text
    }
    
}

