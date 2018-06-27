//
//  SignUpViewController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-06-26.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//


import UIKit
import M13Checkbox

final class SignUpViewController: RWViewController {
    
    // MARK: - Properties
    
    private var registerButtonBottomAnchor: NSLayoutConstraint?
    private var titleLabelTopAnchor: NSLayoutConstraint?
    private var keyboardIsHidden: Bool = true
    
    // MARK: - Subviews
    
    private let titleLabel = UILabel(style: Stylesheet.Labels.title) {
        $0.text = "New to RewardBusiness?"
        $0.textAlignment = .left
        $0.font = Stylesheet.titleFont.withSize(24)
    }
    
    private let subtitleLabel = UILabel(style: Stylesheet.Labels.subtitle) {
        $0.text = "We are happy to have you join us"
        $0.textAlignment = .left
        $0.font = Stylesheet.subtitleFont.withSize(18)
    }
    
    private let emailField = UIAnimatedTextField(style: Stylesheet.TextFields.email)
    private let emailIconView = UIImageView(style: Stylesheet.ImageViews.fitted) {
        $0.image = UIImage.iconEmail
    }
    
    private let nameField = UIAnimatedTextField(style: Stylesheet.TextFields.primary) {
        $0.placeholder = "First and Last Name"
    }
    private let nameIconView = UIImageView(style: Stylesheet.ImageViews.fitted) {
        $0.image = UIImage.iconPerson
    }
    
    private let phoneField = UIAnimatedPhoneNumberTextField(style: Stylesheet.TextFields.phone)
    private let phoneIconView = UIImageView(style: Stylesheet.ImageViews.fitted) {
        $0.image = UIImage.iconPhone
    }
    
    private let passwordField = UIAnimatedTextField(style: Stylesheet.TextFields.password)
    private let passwordIconView = UIImageView(style: Stylesheet.ImageViews.fitted) {
        $0.image = UIImage.iconLock
    }
    
    private let confirmPasswordField = UIAnimatedTextField(style: Stylesheet.TextFields.password) {
        $0.placeholder = "Verify Password"
    }
    private let confirmPasswordIconView = UIImageView(style: Stylesheet.ImageViews.fitted) {
        $0.image = UIImage.iconCheckLock
    }
    
    private let subscribeButton = UIButton(style: Stylesheet.Buttons.regular) {
        $0.setTitle("Keep Me Updated", for: .normal)
        $0.titleLabel?.font = Stylesheet.subheaderFont
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self,
                     action: #selector(SignUpViewController.didTapSubscribe(sender:)),
                     for: .touchUpInside)
    }
    
    private lazy var subscribeCheckbox: M13Checkbox = {
        let checkbox = M13Checkbox()
        checkbox.addTarget(self,
                           action: #selector(SignUpViewController.didTapSubscribe(sender:)),
                           for: .valueChanged)
        return checkbox
    }()
    
    private lazy var closeButton = UIButton(style: Stylesheet.Buttons.close) {
        $0.addTarget(self,
                     action: #selector(SignUpViewController.dismissViewController),
                     for: .touchUpInside)
    }
    
    private lazy var termsButton = UIButton(style: Stylesheet.Buttons.termsAndConditions) {
        $0.addTarget(self,
                     action: #selector(SignUpViewController.didTapTermsButton),
                     for: .touchUpInside)
    }
    
    private lazy var registerButton = RippleButton(style: Stylesheet.Buttons.primary) {
        $0.setTitle("REGISTER", for: .normal)
        $0.addTarget(self,
                     action: #selector(SignUpViewController.didTapRegister),
                     for: .touchUpInside)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
            emailField.text = "mbin@sfu.ca"
            passwordField.text = "oyLf387LTN"
            confirmPasswordField.text = "oyLf387LTN"
        #endif
        
        setupView()
        registerObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController?.viewControllers.first != self {
            closeButton.isHidden = true
        } else {
            navigationController?.setNavigationBarHidden(true, animated: animated)
            titleLabelTopAnchor?.constant = titleLabelDefaultAnchorTopConstant()
            view.layoutIfNeeded()
        }
    }
    
    private func titleLabelDefaultAnchorTopConstant() -> CGFloat {
        if navigationController?.viewControllers.first == self {
            return 54
        } else {
            return 12
        }
    }
    
    // MARK: - Setup
    
    private func setupView() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)
        
        [closeButton, titleLabel, subtitleLabel, emailField, emailIconView, nameField, nameIconView, phoneField, phoneIconView, passwordField, passwordIconView, confirmPasswordField, confirmPasswordIconView, subscribeCheckbox, subscribeButton, termsButton, registerButton].forEach { view.addSubview($0) }
        
        closeButton.anchor(view.layoutMarginsGuide.topAnchor, left: view.layoutMarginsGuide.leftAnchor, topConstant: 6, leftConstant: 6, widthConstant: 36, heightConstant: 36)
        
        titleLabelTopAnchor = titleLabel.anchor(view.layoutMarginsGuide.topAnchor, left: view.layoutMarginsGuide.leftAnchor, right: view.layoutMarginsGuide.rightAnchor, topConstant: 12, leftConstant: 12, rightConstant: 12, heightConstant: 25).first
        
        subtitleLabel.anchorBelow(titleLabel, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: 25)
        
        var lastView: UIView = subtitleLabel
        for subview in [emailField, emailIconView, nameField, nameIconView, phoneField, phoneIconView, passwordField, passwordIconView, confirmPasswordField, confirmPasswordIconView] {
            if subview is UIImageView {
                subview.anchorLeftOf(lastView, topConstant: 14, rightConstant: 8)
                subview.anchorAspectRatio()
            } else if subview is UITextField {
                let leftConstant: CGFloat = lastView == subtitleLabel ? (30 + 8) : 0
                subview.anchorBelow(lastView, topConstant: 12, leftConstant: leftConstant, heightConstant: 44)
                lastView = subview
            }
        }
        
        subscribeCheckbox.anchor(lastView.bottomAnchor, left: view.layoutMarginsGuide.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 12, widthConstant: 30, heightConstant: 30)
        subscribeButton.anchorRightOf(subscribeCheckbox, right: view.layoutMarginsGuide.rightAnchor, leftConstant: 8)
        
        termsButton.anchorAbove(registerButton, heightConstant: 30)
        
        registerButtonBottomAnchor = registerButton.anchor(left: view.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.rightAnchor, heightConstant: 44)[1]
        
        // Keep space below login button red when raised with the keyboard
        let spacingRedView = UIView()
        spacingRedView.backgroundColor = .primaryColor
        view.addSubview(spacingRedView)
        spacingRedView.anchor(registerButton.bottomAnchor, left: registerButton.leftAnchor, bottom: view.bottomAnchor, right: registerButton.rightAnchor)
        
    }
    
    private func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame(notification:)), name: .UIKeyboardDidChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - User Actions
    
    @objc
    private func didTapView() {
        view.endEditing(true)
    }
    
    @objc
    private func didTapTermsButton() {
//        AppRouter.shared.present(.termsOfService, wrap: PrimaryNavigationController.self, from: self, animated: true, completion: nil)
    }
    
    @objc
    private func didTapSubscribe(sender: Any?) {
        
        if (sender as? UIButton) == subscribeButton {
            let isChecked = subscribeCheckbox.checkState == .checked
            let newState: M13Checkbox.CheckState = isChecked ? .unchecked : .checked
            subscribeCheckbox.setCheckState(newState, animated: true)
        }
    }
    
    @objc
    private func didTapRegister() {
        
        guard let email = emailField.text, let password = passwordField.text, let verifyPassword = confirmPasswordField.text else { return }
        
        guard email.isValidEmail else {
            return handleError("Invalid email")
        }
        
        guard password == verifyPassword else {
            return handleError("Passwords do not match")
        }
        
        API.shared.showProgressHUD(ignoreUserInteraction: true)
        Business.signUpInBackground(email: email, password: password) { [weak self] (success, error) in
            API.shared.dismissProgressHUD()
            guard success else {
                self?.handleError(error?.localizedDescription)
                return
            }
            let business = Business()
                
                business.name = self?.nameField.text
                business.fullname_lower = self?.nameField.text?.lowercased()
                business.saveEventually()
        
            AppRouter.shared.present(.numpad, wrap: nil, from: nil, animated: true, completion: nil)
        }
    }
    
    // MARK: - Keyboard Observer
    
    @objc
    private func keyboardDidChangeFrame(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, !keyboardIsHidden, let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            guard let constant = self.registerButtonBottomAnchor?.constant else { return }
            guard keyboardSize.height <= constant else { return }
            UIView.animate(withDuration: TimeInterval(truncating: duration), animations: { () -> Void in
                self.registerButtonBottomAnchor?.constant = -keyboardSize.height + self.view.layoutMargins.bottom
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        keyboardIsHidden = false
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            UIView.animate(withDuration: TimeInterval(truncating: duration), animations: { () -> Void in
                self.registerButtonBottomAnchor?.constant = -keyboardSize.height + self.view.layoutMargins.bottom
                self.titleLabelTopAnchor?.constant = -50
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        keyboardIsHidden = true
        if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            UIView.animate(withDuration: TimeInterval(truncating: duration), animations: { () -> Void in
                self.registerButtonBottomAnchor?.constant = 0
                self.titleLabelTopAnchor?.constant = self.titleLabelDefaultAnchorTopConstant()
                self.view.layoutIfNeeded()
            })
        }
    }
    
}

