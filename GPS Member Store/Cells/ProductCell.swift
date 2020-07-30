//
//  ProductCell.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/28.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class ProductCell: UITableViewCell {
    var mainImage : UIImage?
    var name : String?
    
    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "img_holder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var nameView : UITextView = {
        var textView = UITextView()
        textView.sizeToFit()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textView.textColor = .black
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        textView.clipsToBounds = true;
        return textView
    }()

    var arrow : UIImageView = {
        var imageView = UIImageView()
        imageView.clipsToBounds = true;
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: " arw_right_sm_grey")
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier : reuseIdentifier)
        self.addSubview(mainImageView)
        self.addSubview(nameView)
        self.addSubview(arrow)

    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        if let image = mainImage {
            mainImageView.image = image
        }
        if let name = name {
            nameView.text = name
        }
        
        mainImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true

        nameView.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor, constant: 8).isActive = true
        nameView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44).isActive = true
//        nameView.heightAnchor.constraint(equalToConstant: 25).isActive = true
                
        arrow.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
