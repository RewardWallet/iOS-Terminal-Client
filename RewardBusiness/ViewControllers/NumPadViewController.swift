//
//  HomeViewController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-05-26.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit
import NumPad

class NumPadViewController: RWViewController{

    var cost: Double = 0
    
    lazy var numPad: NumPad = { [unowned self] in
        let numPad = ConfigureNumPad()
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
        textField.placeholder = "0".currency()
        textField.isEnabled = false
        self.containerView.addSubview(textField)
        return textField
        }()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        // Do any additional setup after loading the view.
        
        let views: [String : Any] = ["textField": textField, "numPad": numPad]
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[textField]-20-|", options: [], metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[numPad]|", options: [], metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[textField(==80)][numPad]-50-|", options: [], metrics: nil, views: views))
        self.containerView.addSubview(numPad)
        
        let title = "Payment"
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
        navigationBar.barTintColor = .primaryColor
        view.addSubview(navigationBar)
        
        //let cancelButton = UIBarButtonItem(image: UIImage.iconClose, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: #selector(NumPadViewController.didTapCancel))
        let navigationItem = UINavigationItem(title: title)
        navigationItem.leftBarButtonItem = cancelButton
        cancelButton.tintColor = UIColor.white
        navigationBar.items = [navigationItem]
    }
    
   

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        numPad.invalidateLayout()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    private func didSavePayment(){
        print(textField.text as! String)
//        guard AppRouter.shared.viewController(for: .inventory, context: textField.text?.sanitized() ?? "0") != nil else{ return }
//        AppRouter.shared.present(.inventory, wrap: nil, from: nil, animated: true, completion: nil)
        
      
        
        
        
        
//        let InventoryItemViewController = self.storyboard?.instantiateViewController(withIdentifier: "InventoryItemViewController") as! InventoryItemViewController
//        InventoryItemViewController.cost = Double(textField.text?.sanitized() ?? "0") ?? 0
//        //self.present(InventoryItemViewController, animated: true, completion: nil)
//        self.navigationController?.pushViewController(InventoryItemViewController, animated: true)
    }
    
    @objc private func didTapCancel(){
         AppRouter.shared.present(.checkout, wrap: nil, from: nil, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
   
}

extension NumPadViewController : NumPadDelegate{
    
    
    func numPad(_ numPad: NumPad, itemTapped item: Item, atPosition position: Position) {
        switch (position.row, position.column) {
        case (3, 0):
            textField.text = nil
        case (3, 2):
            didSavePayment()
        default:
            let item = numPad.item(forPosition: position)!
            let string = textField.text!.sanitized() + item.title!
            if Int(string) == 0 {
                textField.text = nil
            } else {
                textField.text = string.currency()
            }
        }
    }
}

