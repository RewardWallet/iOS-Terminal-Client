//
//  AccountHeaderViewCell.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-07-01.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//


import UIKit
import IGListKit
import Kingfisher

final class AccountHeaderViewCell: RWCollectionReusableView {
    
    // MARK: - Subviews
    
    private let backgroundImageView = UIImageView(style: Stylesheet.ImageViews.filled) {
        $0.clipsToBounds = true
        $0.backgroundColor = .primaryColor
    }
    
    private let backgroundImageViewOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryColor
        return view
    }()
    
    private let profileImageView = UIImageView(style: Stylesheet.ImageViews.roundedSquare) {
        $0.layer.cornerRadius = 50
        $0.layer.borderWidth = 4
        $0.layer.borderColor = UIColor.white.cgColor
        $0.backgroundColor = UIColor.primaryColor.darker()
    }
    
    private let nameLabel = UILabel(style: Stylesheet.Labels.header) {
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    private let memberDateLabel = UILabel(style: Stylesheet.Labels.caption) {
        $0.textAlignment = .center
        $0.textColor = UIColor.white.darker(by: 3)
    }
    
    override func setupView() {
        
        backgroundColor = .primaryColor
        apply(Stylesheet.Views.lightlyShadowed)
        
        addSubview(backgroundImageView)
        addSubview(backgroundImageViewOverlay)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(memberDateLabel)
        
        backgroundImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        backgroundImageViewOverlay.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        profileImageView.anchorCenterXToSuperview()
        profileImageView.anchor(bottom: bottomAnchor, bottomConstant: 50, widthConstant: 100, heightConstant: 100)
        
        nameLabel.anchor(profileImageView.bottomAnchor, left: leftAnchor, bottom: memberDateLabel.topAnchor, right: rightAnchor, topConstant: 6, leftConstant: 12, bottomConstant: 2, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        memberDateLabel.anchorBelow(nameLabel, bottom: bottomAnchor, topConstant: 2, bottomConstant: 8)
        nameLabel.anchorHeightToItem(memberDateLabel)
    }
    
    // MARK: - Stretchy Scale API
    
    func stretchImageView(to scale: CGFloat, offsetBy offset: CGFloat) {
        let translation = offset/2
        backgroundImageView.transform = CGAffineTransform(translationX: 0, y: translation).scaledBy(x: scale, y: scale)
        backgroundImageViewOverlay.transform = CGAffineTransform(translationX: 0, y: translation).scaledBy(x: scale, y: scale)
        let alpha = sqrt(1 - abs(offset / bounds.height / 3))
        backgroundImageViewOverlay.alpha = alpha < 1 ? alpha : 1
    }
    
}

extension AccountHeaderViewCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let user = viewModel as? User else { return }
        nameLabel.text = user.business?.name ?? user.business?.username

        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: user.business?.image)
        backgroundImageView.kf.setImage(with: user.business?.image)
    }
    
}

