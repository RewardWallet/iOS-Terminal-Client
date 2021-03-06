//
//  InventoryItemViewController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-06-04.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit
import NumPad
import Parse

class InventoryItemViewController: UIViewController {
    
    var cost: Double = 0
    var count: Int = 0
    var isRedeem: Bool = false

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
        print("aaaa", cost, " ", count)
        // Do any additional setup after loading the view.
        view.backgroundColor = .backgroundColor
        
        let views: [String : Any] = ["textField": textField, "numPad": numPad]
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[textField]-20-|", options: [], metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[numPad]|", options: [], metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[textField(==80)][numPad]-50-|", options: [], metrics: nil, views: views))
        self.containerView.addSubview(numPad)
        
        title = "Total Inventory"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapBack))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func didTapEnter(){
        //save the total amount total and the total item
        //open transaction
        let alertController = UIAlertController(title: "Action Sheet", message: "Please choose one", preferredStyle: .actionSheet)
        let RewardBeamerButton = UIAlertAction(title: "RewardBeamer", style: .default) { (action) in
            print("open RewadBeamer transaction ")
            
//            API.shared.openTransactionOnRewardBeamer(amount: self.cost, itemCount: self.count, completion: { (result ) in
//                if (result != nil) {
//                    print("transaction success")
//                    AppRouter.shared.present(.checkout, wrap: PrimaryNavigationController.self, from: self, animated: true, completion: nil)
//                }else{
//                    print("transaction fail")
//                }
//            })
            
        }
        let QRCodeButton = UIAlertAction(title: "QRCode Scan", style: .default) { (action) in
            print("open QRCode transaction")
            
            print("counts: ",self.count)
            
            API.shared.openTransaction(amount: self.cost, itemCount: self.count) { (json) in
                if let transactionId = json?["objectId"] as? String {
                    let info = [self.isRedeem, transactionId] as [Any]
                    guard let viewController = AppRouter.shared.viewController(for: .qrcode, context: info) else{ return }
                    AppRouter.shared.present(viewController, wrap: PrimaryNavigationController.self, from: self, animated: true, completion: nil)
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
        
    @objc
    func didTapBack(){
        AppRouter.shared.present(.numpad, context: nil, wrap: PrimaryNavigationController.self, from: nil, animated: true, completion: nil)
    }
        
        
        
//        let QRScanViewController = self.storyboard?.instantiateViewController(withIdentifier: "QRScanViewController") as! QRScanViewController
//        QRScanViewController.cost = cost
//        QRScanViewController.count = Int(textField.text?.sanitized() ?? "0") ?? 0
//        //self.present(InventoryItemViewController, animated: true, completion: nil)
//        self.navigationController?.pushViewController(QRScanViewController, animated: true)
  
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension InventoryItemViewController : NumPadDelegate{
    
    
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
                count = Int(textField.text?.sanitized() ?? "0") ?? 0
            }
        }
    }
}


