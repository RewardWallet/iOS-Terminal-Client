//
//  SplashScreenView.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

final class SplashScreenView: UIView {
    
    // MARK: - Properties
    
    lazy var gradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.colors = [.primaryColor, .secondaryColor]
        addSubview(gradientView)
        return gradientView
    }()
    
    private let scale: CGFloat = 30
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        sendSubview(toBack: gradientView)
        gradientView.frame = CGRect(x: 0, y: scale,
                                    width: bounds.width, height: bounds.height - scale)
    }
    
    // Draws a rectangle with a triangular inset at the top mid x
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.midX - scale, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.midX, y: rect.minY + scale))
        context.addLine(to: CGPoint(x: rect.midX + scale, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.minY, y: rect.maxY))
        context.closePath()
        context.setFillColor(UIColor.primaryColor.cgColor)
        context.fillPath()
    }
}


