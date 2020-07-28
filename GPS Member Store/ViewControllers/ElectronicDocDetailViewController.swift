//
//  ElectronicDocDetailViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/28.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit
import PDFKit


class ElectronicDocDetailViewController: UIViewController {
//    var pdfView: PDFView!
    var fileUrl : String?

    var pdfView : PDFView = {
        var view = PDFView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.borderWidth = 5
//        view.layer.borderColor = RED.cgColor
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pdfView)

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
        
//        pdfView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        pdfView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true


    }

}
