//
//  ProductDetailViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/26.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

enum MerchandiseType {
    case Good
    case Gift
}


class ProductDetailViewController: UIViewController {
    var mainImage : UIImage?
    var name : String?
    var remark : String?
    var price : String?
    var desc : String?
    var imageUrls : [String]?
    var merchandiseType : MerchandiseType?


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

    var mainImageView : UIImageView = {
       var imageView = UIImageView()
        imageView.layer.cornerRadius = 16;
        imageView.clipsToBounds = true;
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = UIColor .green
        return imageView
    }()
        
    var nameView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
//        textView.backgroundColor = UIColor .blue
        textView.textColor = UIColor .black
        textView.textAlignment = .center
        textView.font = UIFont(name: "NotoSansTC-Medium", size: 28)
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        return textView
    }()
    
    var remarkView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
//        textView.backgroundColor = UIColor .red
        textView.textColor = PIGMENT_GREEN
        textView.textAlignment = .center
        textView.font = UIFont(name: "NotoSansTC-Bold", size: 15)
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        return textView
    }()
    
    var descView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.sizeToFit()
        textView.isScrollEnabled = false
//        textView.backgroundColor = UIColor .red
        textView.textColor = UIColor(red: 6/255, green: 11/255, blue: 5/255, alpha: 1)
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        return textView
    }()


    var priceLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Medium", size: 22)
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    var use : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("立刻兌換", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(useButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let contentView = UIView();

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SNOW
        title = "商品"

        self.view.addSubview(mainScrollView)
        
//        contentView.backgroundColor = .red
//        mainScrollView.addSubview(contentView)
        mainScrollView.addSubview(mainImageView)
        mainScrollView.addSubview(nameView)
        mainScrollView.addSubview(remarkView)
        mainScrollView.addSubview(priceLabel)
        mainScrollView.addSubview(descView)
        mainScrollView.addSubview(use)

        setupLayout()

    }
    
    private func setupLayout() {
        if let image = mainImage {
            mainImageView.image = image
        }
        if let name = name {
            nameView.text = name
        }
        if let remark = remark {
            remarkView.text = remark
        }
        if let price = price {
            priceLabel.text = price
        }
        if let desc = desc {
            descView.text = desc
        }
        if imageUrls != nil {
            if imageUrls!.count > 0 {
                for case let imageURL in imageUrls! {
                    mainImageView.downloaded(from: imageURL) {
                    }
                }
            }
        }
        
        if let type = merchandiseType {
            switch type {
                case MerchandiseType.Good:
                    use.isHidden = true
                    break
                case MerchandiseType.Gift:
                    use.isHidden = false
                    break
            }
        }
        mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        nameView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 8).isActive = true
        nameView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nameView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        remarkView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        remarkView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 46).isActive = true
        remarkView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        remarkView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        mainImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36).isActive = true
        mainImageView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 76).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36).isActive = true
        mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor).isActive = true

        priceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36).isActive = true
        priceLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 20).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        descView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        descView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20).isActive = true
        descView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28).isActive = true
        
        use.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        use.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 40).isActive = true
        use.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        use.heightAnchor.constraint(equalToConstant: 44).isActive = true
        use.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -60).isActive = true

//        contentView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor).isActive = true
//        contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
//        contentView.rightAnchor.constraint(equalTo: mainScrollView.rightAnchor).isActive = true
//        contentView.heightAnchor.constraint(equalToConstant: 900).isActive = true

    }
    @objc private func addButtonTapped() { }
    
    @objc private func useButtonTapped(sender: UIButton!) {
        GlobalVariables.showAlertWithOptions(title: "兌換商品", message: "立即兌換\(name)", confirmString: "兌換", vc: self) {
            print("已兌換")
        }
    }
}
