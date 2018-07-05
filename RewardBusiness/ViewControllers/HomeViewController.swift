//
//  ViewController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-06-26.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: RWViewController {

    //fileprivate var fetchedbusiness = [Business] = []

    
    private var PaymentButtonAnchor: NSLayoutConstraint?
    private var RedeemButtonAnchor: NSLayoutConstraint?
    
    private let titleLabel = UILabel(style: Stylesheet.Labels.title) {
        $0.text = "Hello RewardBusiness"
        $0.textAlignment = .left
    }
    
    private let subtitleLabel = UILabel(style: Stylesheet.Labels.subtitle) {
        $0.text = "Please choose the right option to continue"
        $0.textAlignment = .left
    }
    
    
    private lazy var PaymentButton = RippleButton(style: Stylesheet.Buttons.primary) {
        $0.setTitle("PAYMENT", for: .normal)
        $0.addTarget(self,
                     action: #selector(HomeViewController.didTapPayment),
                     for: .touchUpInside)
    }
    
    private lazy var RedeemButton = RippleButton(style: Stylesheet.Buttons.primary) {
        $0.setTitle("REDEEM", for: .normal)
        $0.addTarget(self,
                     action: #selector(HomeViewController.didTapRedeem),
                     for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        // Do any additional setup after loading the view.
        title = "Checkout"
        tabBarItem = UITabBarItem.init(title: title, image: UIImage.icon_wallet, selectedImage: UIImage.icon_wallet)
        //fetchBusiness()
        setupView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup
    private func setupView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)
       
        [titleLabel, subtitleLabel, PaymentButton, RedeemButton].forEach { view.addSubview($0)}

        titleLabel.anchor(view.layoutMarginsGuide.topAnchor, left: view.layoutMarginsGuide.leftAnchor, right: view.layoutMarginsGuide.rightAnchor, topConstant: 50, leftConstant: 12, rightConstant: 12, heightConstant: 40)
        
        subtitleLabel.anchorBelow(titleLabel, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: 30)
        
        PaymentButton.anchor(titleLabel.bottomAnchor, left: view.layoutMarginsGuide.leftAnchor, bottom: nil, right: view.layoutMarginsGuide.rightAnchor, topConstant: 75, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 100)
        RedeemButton.anchorBelow(PaymentButton, bottom: nil, topConstant: 25, bottomConstant:0, heightConstant:100)
        
//        PaymentButtomAnchor = PaymentButtom.anchor(left: view.leftAnchor, bottom: view.layoutMarginsGuide.topAnchor, right: view.rightAnchor, heightConstant: 44)[1]
//
//        RedeemButtomAnchor = RedeemButtom.anchor(left: view.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.rightAnchor, heightConstant: 44)[1]
    }
    
    @objc
    private func didTapView() {
        view.endEditing(true)
    }
    
    
    @objc
    private func didTapPayment() {
        
            AppRouter.shared.present(.numpad, wrap: nil, from: nil, animated: true, completion: nil)
            
    }
    @objc
    private func didTapRedeem() {
        
//        AppRouter.shared.present(.redeem, wrap: nil, from: nil, animated: true, completion: nil)
        
    }
    
//    func fetchBusiness(){
//
//        API.shared.fetchBusinesses(filtered: "Starbucks") { [weak self] in
//            if business[0].name! == "Startbucks"{
//                self.titleLabel.text = business[0].name
//            }else{
//                self.titleLabel.text = "RewardBusiness"
//            }
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
