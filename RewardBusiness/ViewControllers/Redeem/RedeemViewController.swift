//
//  RedeemViewController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-07-12.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit
import Parse
import NumPad

class RedeemViewController : UIViewController {
    
    var points : Int = 0
    var isRedeem : Bool = false
    
    lazy var numPad: NumPad = { [unowned self] in
        let numPad = ConfigureItemPad()
        numPad.delegate = self
        numPad.translatesAutoresizingMaskIntoConstraints = false
        numPad.backgroundColor = self.borderColor
        self.containerView.addSubview(numPad)
        return numPad
        }()
    
    
    
    let borderColor = UIColor(white: 0.9, alpha: 1)
    
    lazy var containerView: UIView = { [unowned self] in
        let containerView = UIView()
        containerView.layer.borderColor = self.borderColor.cgColor
        containerView.layer.borderWidth = 1
        self.view.addSubview(containerView)
        containerView.constrainToEdges()
        return containerView
        }()
    
    lazy var textField: UITextField = { [unowned self] in
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        textField.textColor = UIColor(white: 0.3, alpha: 1)
        textField.font = .systemFont(ofSize: 40)
        textField.placeholder = "0"
        textField.isEnabled = false
        self.containerView.addSubview(textField)
        return textField
        }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .backgroundColor
        
        let views: [String : Any] = ["textField": textField, "numPad": numPad]
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[textField]-20-|", options: [], metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[numPad]|", options: [], metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[textField(==80)][numPad]-50-|", options: [], metrics: nil, views: views))
        self.containerView.addSubview(numPad)
        
        title = "Redeem Points"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(didTapBack))
    }
    
    
    @objc
    func didTapBack(){
        AppRouter.shared.present(.checkout, context: nil, wrap: nil, from: nil, animated: true, completion: nil)
    }
    
    private func didTapEnter(){
        isRedeem = true
        
        let Openparams: [AnyHashable: Any] = ["points": points, "businessId": User.current()?.business?.objectId]
        PFCloud.callFunction(inBackground: "openRedeemTransaction", withParameters: Openparams) { (response, error) in
            let json = response as? [String:Any]
            if let transactionId = json?["objectId"] as? String {
                let info = [self.isRedeem, transactionId] as [Any]
                
                AppRouter.shared.present(.qrcode, context: info, wrap: PrimaryNavigationController.self, from: self, animated: true, completion: nil)
            }
            
        }
    }
    
}



extension RedeemViewController : NumPadDelegate{
    
    
    func numPad(_ numPad: NumPad, itemTapped item: Item, atPosition position: Position) {
        switch (position.row, position.column) {
        case (3, 0):
            textField.text = nil
        case (3, 2):
            didTapEnter()
        default:
            let item = numPad.item(forPosition: position)!
            let string = textField.text!.sanitized() + item.title!
            if Int(string) == 0 {
                textField.text = nil
            } else {
                textField.text = string.sanitized()
                points = Int(textField.text?.sanitized() ?? "0") ?? 0
            }
        }
    }
}



