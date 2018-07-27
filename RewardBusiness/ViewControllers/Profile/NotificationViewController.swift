//
//  NotificationViewController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-07-17.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit
import Former
import Parse
import AlertHUDKit

class NotificationViewController: RWViewController {

    private let titleLabel = UILabel(style: Stylesheet.Labels.title) {
        $0.text = "Notification Message"
        $0.textAlignment = .left
    }
    
    private let subtitleLabel = UILabel(style: Stylesheet.Labels.subtitle) {
        $0.text = "Please type the messgae and click send"
        $0.textAlignment = .left
    }
    
    let textFieldMsg = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    

    private lazy var SendButton = RippleButton(style: Stylesheet.Buttons.primary) {
        $0.setTitle("SEND", for: .normal)
        $0.addTarget(self,
                     action: #selector(NotificationViewController.didTapSend),
                     for: .touchUpInside)
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        title = "Notification"

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        textFieldMsg.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView() {
        
      
        textFieldMsg.placeholder = "Enter text here"
        textFieldMsg.borderStyle = UITextBorderStyle.roundedRect
        textFieldMsg.autocorrectionType = UITextAutocorrectionType.yes
        textFieldMsg.keyboardType = UIKeyboardType.default
        textFieldMsg.textAlignment = NSTextAlignment.natural
        textFieldMsg.contentVerticalAlignment = UIControlContentVerticalAlignment.top
        textFieldMsg.returnKeyType = UIReturnKeyType.done
        textFieldMsg.clearButtonMode = UITextFieldViewMode.whileEditing
 
        
        [titleLabel, subtitleLabel, textFieldMsg, SendButton].forEach { view.addSubview($0)}
        
        titleLabel.anchor(view.layoutMarginsGuide.topAnchor, left: view.layoutMarginsGuide.leftAnchor, right: view.layoutMarginsGuide.rightAnchor, topConstant: 50, leftConstant: 12, rightConstant: 12, heightConstant: 40)
        
        subtitleLabel.anchorBelow(titleLabel, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: 30)
        
        textFieldMsg.anchor(titleLabel.bottomAnchor, left: view.layoutMarginsGuide.leftAnchor, bottom: nil, right: view.layoutMarginsGuide.rightAnchor, topConstant: 30, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 300)
        
        SendButton.anchor(textFieldMsg.bottomAnchor, left: view.layoutMarginsGuide.leftAnchor, bottom: nil, right: view.layoutMarginsGuide.rightAnchor, topConstant: 10, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 70)
    }
    
    
    
    @objc
    func didTapSend(){
        print("message: ", textFieldMsg.text)
        
        if (textFieldMsg.text == ""){
            
            self.handleError("message is empty")
            
        }else{
            
            PushNotication.shared.sendNotificationToCustomers(message: textFieldMsg.text!)
            self.handleSuccess("Notification Sent")
            
        }
        self.navigationController?.popViewController(animated: true)
    }

    override func handleError(_ error: String?) {
        var error = error ?? "Unknown Error"
        if error == "The data couldn’t be read because it isn’t in the correct format." {
            error = "The server could not be reached"
        }
        print(error)
        Ping(text: error, style: .danger).show(animated: true, duration: 3)
    }
    
    override func handleSuccess(_ message: String?) {
        let message = message ?? "Success"
        print(message)
        Ping(text: message, style: .info).show(animated: true, duration: 3)
    }
    

}

extension NotificationViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}


