//
//  QRScanViewController.swift
//  RewardBusiness
//
//  Created by MOLLY BIN on 2018-05-26.
//  Copyright © 2018 MOLLY BIN. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import Parse

class QRScanViewController: RWViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let systemSoundId : SystemSoundID = 1016
    var businessId : String = ""
    var userId : String = ""
    var transactionId: String = ""
    var cost: Double = 0
    var count: Int = 0
    var isRedeem: Bool = false
    

    
    @IBOutlet weak var infoLbi: UILabel!
    
    let codeFrame:UIView = {
        let codeFrame = UIView()
        codeFrame.layer.borderColor = UIColor.red.cgColor
        codeFrame.layer.borderWidth = 1.5
        codeFrame.frame = CGRect.zero
        codeFrame.translatesAutoresizingMaskIntoConstraints = false
        return codeFrame
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("transactionIddddd", transactionId)
        view.backgroundColor = .backgroundColor
        navigationItem.title = "QRCode Scan"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(goBacktoHome))
                
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        //view.bringSubview(toFront: infoLbi)

        captureSession.startRunning()
    }
    
    @objc
    func goBacktoHome(){
        
        
        //close the transaction
        if isRedeem == true {
            
            let Closeparams: [AnyHashable: Any] = ["transactionId": transactionId, "userId": self.userId]
            PFCloud.callFunction(inBackground: "closeRedeemTransaction", withParameters: Closeparams) { (response, error) in
                let json = response as? [String:Any]
                let pointsAdded = json?["pointsRedeemed"]
                print(pointsAdded)
            }
        }else {
            let Closeparams: [AnyHashable: Any] = ["transactionId": transactionId, "userId": self.userId]
            PFCloud.callFunction(inBackground: "closeTransaction", withParameters: Closeparams) { (response, error) in
                let json = response as? [String:Any]
                let pointsAdded = json?["pointsAdded"]
                print(pointsAdded)
            }
           AppRouter.shared.present(.checkout, wrap: nil, from: nil, animated: true, completion: nil)
        }
    }
    
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        captureSession.stopRunning()
//
//        if let metadataObject = metadataObjects.first {
//            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
//            guard let stringValue = readableObject.stringValue else { return }
//            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//            found(code: stringValue)
//        }
//
//        dismiss(animated: true)
        if metadataObjects.count == 0{
            print("no objects returned")
            return
        
        }
        
        let metaDataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        guard let StringCodeValue = metaDataObject.stringValue else {
            return
        }
        captureSession.stopRunning()
        let StringCodeParsed = StringCodeValue.components(separatedBy: "-")
        businessId = StringCodeParsed[0]
        userId = StringCodeParsed[1]
        
        view.addSubview(codeFrame)
        
        //transformedMetaDataObject returns layer coordinates/height/width from visual properties
        guard let metaDataCoordinates = previewLayer?.transformedMetadataObject(for: metaDataObject) else {
            return
        }
        
        //Those coordinates are assigned to our codeFrame
        codeFrame.frame = metaDataCoordinates.bounds
        AudioServicesPlayAlertSound(systemSoundId)
        //infoLbi.text = StringCodeValue
        
        let Openparams: [AnyHashable: Any] = ["businessId": businessId, "amount": cost, "itemCount": count]
        PFCloud.callFunction(inBackground: "openTransaction", withParameters: Openparams) { (response, error) in
            let json = response as? [String:Any]
            if let transactionId = json?["objectId"] {
            
                let Closeparams: [AnyHashable: Any] = ["transactionId": transactionId, "userId": self.userId]
                PFCloud.callFunction(inBackground: "closeTransaction", withParameters: Closeparams) { (response, error) in
                    let json = response as? [String:Any]
                    let pointsAdded = json?["pointsAdded"]
                    print(pointsAdded)
                }
            }
            
        }

        found(code: StringCodeValue)
//        if let url = URL(string: StringCodeValue) {
//            performSegue(withIdentifier: "segToDetailsVC", sender: self)
//            captureSession?.stopRunning()
//        }
//        if Transaction().transactionId == transactionId{
//            print("transactionId matched")
//            if let url = URL(string: StringCodeValue) {
//                performSegue(withIdentifier: "segToDetailsVC", sender: self)
//                captureSession?.stopRunning()
//            }
//
//        }else{
//            print("transactionId is not matched")
//        }
//
        
    }
    
    func found(code: String) {
        print("QR Code scan successfully")
        let alert = UIAlertController(title: "QR Code", message: "Found", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if let nextVC = segue.destination as? QRCodeDetailsViewController{
//            nextVC.scannedCode = infoLbi.text
//        }
//    }
   

}
