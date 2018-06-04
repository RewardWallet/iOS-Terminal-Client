//
//  QRCodeDetailsViewController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-06-04.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit

class QRCodeDetailsViewController: UIViewController {

    var scannedCode: String!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(scannedCode)
        
        let url = URL(string: scannedCode)
        let requestObj = URLRequest(url:url!)
        webView.loadRequest(requestObj)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
