//
//  ProductDetailViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/26.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class ProductDetailViewController: UIViewController {
    var name : String?
    var desc : String?
    var videoUrl : String?
    var pdfUrl : String?
    var imageUrls : [String]?

    var mainScrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
        scrollView.isScrollEnabled = true
//        scrollView.backgroundColor = UIColor .orange
//        scrollView.layer.borderColor = UIColor .black.cgColor
//        scrollView.layer.borderWidth = 3
        return scrollView
    }()
        
    var nameView : UITextView = {
        var textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.textColor = UIColor .black
        textView.textAlignment = .left
        textView.font = UIFont(name: "NotoSansTC-Medium", size: 20)
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        return textView
    }()
        
    var descView : UITextView = {
        var textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.textColor = UIColor(red: 6/255, green: 11/255, blue: 5/255, alpha: 1)
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        return textView
    }()
    
    var pdf : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "ic_pdf"), for: .normal)
        button.setTitle("PDF檔案", for: .normal)
        button.addTarget(self, action: #selector(pdfButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    var video : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "ic_fill_play"), for: .normal)
        button.setTitle("影片檔案", for: .normal)
        button.addTarget(self, action: #selector(videoButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var images : UIButton = {
        var button =  UIButton()
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "ic_camera"), for: .normal)
        button.setTitle("圖片檔案", for: .normal)
        button.addTarget(self, action: #selector(imagesButtonTapped), for: .touchUpInside)
//        button.isHidden = true
        return button
    }()
        
    let contentView = UIView();

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SNOW
        title = "商品"

        self.view.addSubview(mainScrollView)
        
        mainScrollView.addSubview(nameView)
        mainScrollView.addSubview(descView)
        mainScrollView.addSubview(pdf)
        mainScrollView.addSubview(video)
        mainScrollView.addSubview(images)
        setupLayout()
        
    }
    
    private func setupLayout() {
        if let name = name {
            nameView.text = name
        }
        if let desc = desc {
            descView.text = desc
        }
        if pdfUrl != nil {
            pdf.isHidden = false
        }
        if videoUrl != nil {
            video.isHidden = false
        }

        if imageUrls != nil {
            images.isHidden = false
//            if imageUrls!.count > 0 {
//                for case let imageURL in imageUrls! {
//                    mainImageView.downloaded(from: imageURL) {
//                    }
//                }
//            }
        }
        
        mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        nameView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 8).isActive = true
        nameView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nameView.heightAnchor.constraint(equalToConstant: 40).isActive = true
                
        descView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        descView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 20).isActive = true
        descView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28).isActive = true
        
        pdf.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        pdf.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 20).isActive = true
        pdf.widthAnchor.constraint(equalToConstant: 60).isActive = true
        pdf.heightAnchor.constraint(equalToConstant: 60).isActive = true

        video.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        video.topAnchor.constraint(equalTo: pdf.bottomAnchor, constant: 20).isActive = true
        video.widthAnchor.constraint(equalToConstant: 60).isActive = true
        video.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        images.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        images.topAnchor.constraint(equalTo: video.bottomAnchor, constant: 20).isActive = true
        images.widthAnchor.constraint(equalToConstant: 60).isActive = true
        images.heightAnchor.constraint(equalToConstant: 60).isActive = true

    }
    @objc private func pdfButtonTapped() {
        let pdfVC = PDFViewController()
        pdfVC.fileUrl = pdfUrl!
        pdfVC.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(pdfVC, animated: true)
    }
    
    @objc private func videoButtonTapped() {
        let videoURL = URL(string: videoUrl!)!
        let player = AVPlayer(url: videoURL)

        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all

        present(playerViewController, animated: true) {
          player.play()
        }
    }
    
    @objc private func imagesButtonTapped() {
        let imagesVC = ImagesViewController()
        imagesVC.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(imagesVC, animated: true)
    }

}
