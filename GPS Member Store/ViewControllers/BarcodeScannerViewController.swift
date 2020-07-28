//
//  BarcodeScannerViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/23.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import AVFoundation
import UIKit

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    lazy var captureBracket : UIImageView = {
        var imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "barcode_capture")
        return imageView
    }()
    
    var redLine : UIView = {
        var view = UIView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
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
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.frame = view.layer.bounds
        
        previewLayer.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height - UIScreen.main.bounds.width)/2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        //        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureBracket.frame = CGRect(x: (previewLayer.frame.width - 271)/2, y: (previewLayer.frame.height - 183)/2, width: 271, height: 183)
        previewLayer.addSublayer(captureBracket.layer)
        
        redLine.frame = CGRect(x: 0, y: (previewLayer.frame.height - 2)/2, width: previewLayer.frame.width, height: 2)
        redLine.layer.borderColor = RED.cgColor
        redLine.layer.borderWidth = 2

        previewLayer.addSublayer(redLine.layer)

        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        
        let rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: captureBracket.frame)
        metadataOutput.rectOfInterest = rectOfInterest

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
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            let vc = self.presentingViewController
            dismiss(animated: true) {
                GlobalVariables.showAlert(title: "已掃描到barcode！", message: stringValue, vc: vc)
            }
        }


    }

    func found(code: String) {
        print(code)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
