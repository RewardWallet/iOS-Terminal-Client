//
//  WelcomeViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 2/28/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

fileprivate let kInitialAnchorConstant: CGFloat = -30
fileprivate let kFinalAnchorConstant: CGFloat = 200
fileprivate let kFlipFromRightAnimation: String = "flipFromRight"

class WelcomeViewController: RWViewController {
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    let titleLabel = UILabel(style: Stylesheet.Labels.title) {
        $0.text = "RewardBusiness"
    }
    
    let subtitleLabel = UILabel(style: Stylesheet.Labels.subtitle) {
        $0.text = "A Merchant Control program for small businesses"
    }
    
    let logoImageView = UIImageView(style: Stylesheet.ImageViews.fitted) {
        $0.image = .coin
    }
    
    lazy var loginButton = UIButton(style: Stylesheet.Buttons.roundedWhite) {
        $0.setTitle("Login", for: .normal)
        $0.addTarget(self,
                     action: #selector(WelcomeViewController.didTapLogin),
                     for: .touchUpInside)
    }
    
    lazy var signUpButton: UIButton = { [weak self] in
        let button = UIButton()
        let normalTitle = NSMutableAttributedString().normal("Don't have an account? ", font: .systemFont(ofSize: 14), color: .white).bold("Sign up here", size: 14, color: .white)
        let highlightedTitle = NSMutableAttributedString().normal("Don't have an account? ", font: .systemFont(ofSize: 14), color: UIColor.white.withAlphaComponent(0.3)).bold("Sign up here", size: 14, color: UIColor.white.withAlphaComponent(0.3))
        button.setAttributedTitle(normalTitle, for: .normal)
        button.setAttributedTitle(highlightedTitle, for: .highlighted)
        button.addTarget(self,
                         action: #selector(WelcomeViewController.didTapSignUp),
                         for: .touchUpInside)
        return button
        }()
    
    let backgroundView = SplashScreenView()
    
    private var backgroundViewTopAnchor: NSLayoutConstraint?
    private var hasAnimatedFirstLaunch: Bool = false
    private var hasAnimatedLaunch: Bool = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(backgroundView)
        view.addSubview(logoImageView)
        backgroundView.addSubview(loginButton)
        backgroundView.addSubview(signUpButton)
        
        backgroundViewTopAnchor = backgroundView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: kInitialAnchorConstant).first
        
        titleLabel.anchor(left: view.layoutMarginsGuide.leftAnchor, bottom: subtitleLabel.topAnchor, right: view.layoutMarginsGuide.rightAnchor, leftConstant: 24, bottomConstant: 10, rightConstant: 24, heightConstant: 40)
        subtitleLabel.anchor(left: titleLabel.leftAnchor, bottom: backgroundView.topAnchor, right: titleLabel.rightAnchor, bottomConstant: 40, heightConstant: 20)
        
        logoImageView.anchorCenterToSuperview()
        logoImageView.anchor(widthConstant: 150, heightConstant: 150)
        
        loginButton.anchorCenterXToSuperview()
        loginButton.anchor(bottom: signUpButton.topAnchor, bottomConstant: 10, widthConstant: 200, heightConstant: 44)
        
        signUpButton.anchorCenterXToSuperview()
        signUpButton.anchor(bottom: backgroundView.bottomAnchor, bottomConstant: 40, heightConstant: 20)
        
        // Prep Animation
        logoImageView.alpha = hasAnimatedLaunch ? 1 : 0
        loginButton.alpha = hasAnimatedLaunch ? 1 : 0
        signUpButton.alpha = hasAnimatedLaunch ? 1 : 0
        backgroundView.gradientView.alpha = hasAnimatedLaunch ? 1 : 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animate Launch
        guard !hasAnimatedLaunch else { return }
        maximizeBackgroundView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Animate Launch
        guard !hasAnimatedLaunch, hasAnimatedFirstLaunch else { return }
        maximizeBackgroundView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unanimate Launch
        guard hasAnimatedLaunch else { return }
        minimizeBackgroundView()
    }
    
    // MARK: - Animations
    
    private func maximizeBackgroundView() {
        logoImageView.isHidden = false
        UIView.animate(withDuration: 1, delay: 0.3, options: [], animations: {
            // Alpha animation shouldn't be done in a spring animation
            self.loginButton.alpha = 1
            self.signUpButton.alpha = 1
            self.logoImageView.alpha = 1
            self.backgroundView.gradientView.alpha = 1
        })
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
            self.backgroundViewTopAnchor?.constant = kFinalAnchorConstant
            self.view.layoutIfNeeded()
        }) { success in
            self.hasAnimatedLaunch = success
            self.hasAnimatedFirstLaunch = success
            self.beginCoinAnimation()
        }
    }
    
    private func minimizeBackgroundView() {
        logoImageView.layer.removeAnimation(forKey: kFlipFromRightAnimation)
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            // Alpha animation shouldn't be done in a spring animation
            self.loginButton.alpha = 0
            self.signUpButton.alpha = 0
            self.logoImageView.alpha = 0
            self.backgroundView.gradientView.alpha = 0
        })
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
            self.backgroundViewTopAnchor?.constant = kInitialAnchorConstant
            self.view.layoutIfNeeded()
        }) { success in
            self.hasAnimatedLaunch = !success
        }
    }
    
    private func beginCoinAnimation() {
        let transition = CATransition()
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = "flip"
        transition.subtype = "fromRight"
        transition.duration = 2
        transition.repeatCount = .infinity
        logoImageView.layer.add(transition, forKey: kFlipFromRightAnimation)
    }
    
    // MARK: - User Actions
    
    
    @objc
    func didTapLogin() {
        
        AppRouter.shared.present(.login, wrap: InversePrimaryNavigationController.self,
                                 from: self, animated: true, completion: nil)
    }
    
    @objc
    func didTapSignUp() {
        
        AppRouter.shared.present(.signup, wrap: InversePrimaryNavigationController.self,
                                 from: self, animated: true, completion: nil)
    }
    
}

