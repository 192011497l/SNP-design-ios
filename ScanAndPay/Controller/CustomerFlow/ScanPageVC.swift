//
//  ScanPageVC.swift
//  ScanAndPay
//
//  Created by SAIL on 31/01/24.
//

import UIKit
import AVFoundation

class ScanPageVC: BasicVC, AVCaptureMetadataOutputObjectsDelegate {
   
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    // Properties
    var captureSession: AVCaptureSession!
    var scannerOverlayPreviewLayer: ScannerOverlayPreviewLayer!
    var scanData: String = ""
    var formData = [String: String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add actions to buttons
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonAction), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(cartButtonAction), for: .touchUpInside)
        retakeButton.addTarget(self, action: #selector(retakeButtonAction), for: .touchUpInside)

        // Check for camera permission
        AVCaptureDevice.requestAccess(for: .video) { success in
            if success {
                // Permission granted, setup the camera
                DispatchQueue.main.async {
                    self.setupCamera()
                }
            } else {
                self.showPermissionAlert()
            }
        }
    }
    
    // MARK: - Button Actions
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func cartButtonAction() {
        // Check if the parent view controller is TabBarVC2
        guard let tabBarVC2 = self.tabBarController as? TabBarVC2 else {
            print("Parent view controller is not TabBarVC2")
            return
        }

        // Set the selected tab to the one containing CartPageVC
        tabBarVC2.selectedIndex = 2 // Index of CartPageVC in TabBarVC2's viewControllers

        // If CartPageVC is not already visible, you may want to push it onto the navigation stack
        if let cartPageVC = tabBarVC2.viewControllers?[2] as? CartPageVC {
            if let navigationController = tabBarVC2.selectedViewController as? UINavigationController {
                navigationController.pushViewController(cartPageVC, animated: true)
            }
        }
    }


    @objc func addToCartButtonAction() {
        // Check if the capture session is running
        if captureSession.isRunning {
            // If running, show an alert
            let alert = UIAlertController(title: "Camera is still active", message: "Please Scan the QR Code", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let components = scanData.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        for component in components {
            let keyValue = component.components(separatedBy: ":")
            if keyValue.count == 2 {
                let key = keyValue[0].trimmingCharacters(in: .whitespaces)
                let value = keyValue[1].trimmingCharacters(in: .whitespaces)
                formData[key] = value
            }
        }
        print(formData) 
        print("scanData --> \(scanData)")
        postAPI(formData: formData)
    }

    
    @objc func retakeButtonAction() {
        startCaptureSession()
    }
    
    // MARK: - Helper Methods
    
    func startCaptureSession() {
        if captureSession?.isRunning == false {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first,
           let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
           let stringValue = readableObject.stringValue {
            scanData = stringValue
            print(stringValue)
            captureSession.stopRunning()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Camera Setup
    
    func setupCamera() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("No video capture device available")
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                fatalError("Could not add video input to the session")
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                fatalError("Could not add metadata output to the session")
            }
            
            // Set up scanner overlay preview layer
            scannerOverlayPreviewLayer = ScannerOverlayPreviewLayer(session: captureSession)
            scannerOverlayPreviewLayer.frame = self.backgroundView.bounds
            scannerOverlayPreviewLayer.backgroundColor = UIColor.clear.cgColor
            scannerOverlayPreviewLayer.maskSize = CGSize(width: 250, height: 250)
            scannerOverlayPreviewLayer.videoGravity = .resizeAspectFill
            self.backgroundView.layer.addSublayer(scannerOverlayPreviewLayer)
            metadataOutput.rectOfInterest = scannerOverlayPreviewLayer.rectOfInterest
            startCaptureSession()
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func showPermissionAlert() {
        let alert = UIAlertController(title: "Camera Permission Denied", message: "Please enable camera access in Settings to use this feature.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
extension ScanPageVC {
    func postAPI(formData : [String: String]){
        let apiURL = APIList().urlString(url:.AddToCart)
        print(apiURL)
        APIHandler().postAPIValues(type: AddOfferModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [self] in
                    if data.status{
                        showAlert(title: "Added Successful", message: data.message, okActionHandler: {self.startCaptureSession()})
                    }
                    else{
                        showAlert(title: "Error", message: data.message, okActionHandler: {})
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("error ---> \(error)")
                    self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                }
            }
        }
    }
}
