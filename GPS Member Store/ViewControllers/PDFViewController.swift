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
        super.viewDidLoad()
        
        view.addSubview(pdfView)
        view.addSubview(close)

        setupLayout()
    }
        
    private func setupLayout() {
        if let url = fileUrl {
            guard let url = URL(string: url) else {return}
            do{
//                let data = try Data(contentsOf: url)
//                let pdfDOC = PDFDocument(data: data)
                let pdfDOC = PDFDocument(url: url)
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                pdfView.displaysAsBook = true
                pdfView.displayDirection = .vertical
                pdfView.document = pdfDOC
                pdfView.autoScales = true
                pdfView.maxScaleFactor = 4.0
                pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
            }catch let err{
                print(err.localizedDescription)
            }
        }
        close.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        close.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true

//        pdfView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        pdfView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

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
