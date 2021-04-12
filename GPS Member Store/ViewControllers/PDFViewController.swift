//
//  PDFViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/28.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit
import PDFKit


class PDFViewController: UIViewController {
//    var pdfView: PDFView!
    var fileUrl : String?
    
    var spinner = UIActivityIndicatorView(style: .gray)
    
    var pdfView : PDFView = {
        var view = PDFView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        return view
    }()
    
    var close : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: " ic_fill_cross_grey"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
    }

    override func viewDidLoad() {
        view.backgroundColor = SNOW
        super.viewDidLoad()
        view.addSubview(pdfView)
        view.addSubview(close)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        setupLayout()
    }
        
    private func setupLayout() {
        if let fileUrl = fileUrl {
            spinner.startAnimating()
            NetworkManager.fetchPDF(urlString: fileUrl) { (data) in
                DispatchQueue.main.async {
                    let pdfDOC = PDFDocument(data: data)
                    //                let pdfDOC = PDFDocument(url: url)
                    self.pdfView.displayMode = .singlePageContinuous
                    self.pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    self.pdfView.displaysAsBook = true
                    self.pdfView.displayDirection = .vertical
                    self.pdfView.document = pdfDOC
                    self.pdfView.autoScales = true
                    self.pdfView.maxScaleFactor = 4.0
                    self.pdfView.minScaleFactor = self.pdfView.scaleFactorForSizeToFit
                    self.spinner.stopAnimating()
                }
            }
        }
        close.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        close.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true


    }
    @objc private func closeButtonTapped(sender: UIButton!) {
        dismiss(animated: true) {
        }
    }

}

class MyViewController:UIViewController{
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get{
            return .portrait
        }
    }
}
