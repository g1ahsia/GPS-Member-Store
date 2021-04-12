//
//  FunctionCell.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/8/10.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit
import BadgeSwift

class FunctionCell: UICollectionViewCell {
    var mainImage : UIImage?
    var name : String?
    var badgeNum : Int?
    
    var mainImageBackground : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 232/255, green: 236/255, blue: 238/255, alpha: 1)
        view.layer.cornerRadius = 8
        return view
    }()
        
    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var nameView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "NotoSansTC-Medium", size: 15)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        textView.clipsToBounds = true;
        return textView
    }()
    
    var badge = BadgeSwift()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainImageBackground)
        mainImageBackground.addSubview(mainImageView)
        self.addSubview(nameView)
        
        badge.frame = CGRect(x: self.contentView.frame.width - 9, y: -9, width: 18, height: 18)
        self.addSubview(badge)
        self.contentView.clipsToBounds = false
        badge.textColor = .white
        badge.font = UIFont.boldSystemFont(ofSize: 12)
        badge.isHidden = true
    }

    override func layoutSubviews() {
        super .layoutSubviews()
        if let image = mainImage {
            mainImageView.image = image
        }
        if let name = name {
            nameView.text = name
        }
        if let badgeNum = badgeNum {
            if (badgeNum > 0) {
                badge.text = String(badgeNum)
                badge.isHidden = false
            }
            else {
                badge.isHidden = true
            }
        }
        
        mainImageBackground.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mainImageBackground.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 80) / 3).isActive = true
        mainImageBackground.heightAnchor.constraint(equalTo: mainImageBackground.widthAnchor).isActive = true
        mainImageBackground.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        mainImageView.centerXAnchor.constraint(equalTo: mainImageBackground.centerXAnchor).isActive = true
        mainImageView.centerYAnchor.constraint(equalTo: mainImageBackground.centerYAnchor).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 80) / 3 - 20).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 80) / 3 - 20).isActive = true

        nameView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameView.topAnchor.constraint(equalTo: self.mainImageBackground.bottomAnchor, constant: 5).isActive = true
        nameView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

