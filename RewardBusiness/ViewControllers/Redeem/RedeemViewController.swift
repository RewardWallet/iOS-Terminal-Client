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
    
    var points : Double = 0
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapBack))
    }
    
    
    @objc
    func didTapBack(){
        AppRouter.shared.present(.checkout, context: nil, wrap: nil, from: nil, animated: true, completion: nil)
    }
    
    private func didTapEnter(){
        isRedeem = true
        let alertController = UIAlertController(title: "Action Sheet", message: "Please choose one", preferredStyle: .actionSheet)
        let RewardBeamerButton = UIAlertAction(title: "RewardBeamer", style: .default) { (action) in
            print("open RewadBeamer Redeem transaction ")
            
            API.shared.openRedeemTransactionOnRewardBeamer(points: self.points, completion: { (json) in
                if let transactionId = json?["objectId"] as? String {
                    // close transaction inside
                    let alertController = UIAlertController(title: "Success", message: "Openned transaction with id " + transactionId, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        AppRouter.shared.present(.checkout, context: nil, wrap: nil, from: nil, animated: true, completion: nil)
                    })
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "ERROR", message: "Failed to find a RewardBeamer on your network", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
            
            
        }
        
        
        
        let QRCodeButton = UIAlertAction(title: "QRCode Scan", style: .default) { (action) in
            print("open QRCode Redeem transaction")
            
            API.shared.openRedeemTransaction(points: self.points) { (json) in
                if let transactionId = json?["objectId"] as? String {
                    let info = [self.isRedeem, transactionId] as [Any]
                    
                    AppRouter.shared.present(.qrcode, context: info, wrap: PrimaryNavigationController.self, from: self, animated: true, completion: nil)
                }
            }
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel button tapped")
        }
        
        alertController.addAction(RewardBeamerButton)
        alertController.addAction(QRCodeButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
        
        
        
    
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
                points = Double(textField.text?.sanitized() ?? "0") ?? 0
            }
        }
    }
}



