//
//  RequestCell.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/29.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class RequestCell: UITableViewCell {
    var mainImage : UIImage?
    var sender : String?
    var type : Int?
    var message : String?
    var updatedDate : String?
        
    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var senderLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 13)
        textLabel.textColor = .black
        textLabel.clipsToBounds = true
        return textLabel
    }()
    
    var subjectLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        textLabel.textColor = .black
        textLabel.clipsToBounds = true
        return textLabel
    }()

    var messageLabel: UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.textColor = .black
        textLabel.clipsToBounds = true
        return textLabel
    }()
    
    var icon : UIImageView = {
        var imageView = UIImageView()
        imageView.clipsToBounds = true;
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: " arw_right_sm_grey")
        return imageView
    }()
    
    var dateLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.textAlignment = .right
        return textLabel
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier : reuseIdentifier)
        
        self.contentView.addSubview(mainImageView)
        self.contentView.addSubview(senderLabel)
        self.contentView.addSubview(subjectLabel)
        self.contentView.addSubview(messageLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(icon)

    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        if let image = mainImage {
            mainImageView.image = image
        }
        if let sender = sender {
            senderLabel.text = sender
        }
        if let type = type {
            subjectLabel.text = REQUEST_SUBJECTS[type]
            if (type == 0) {
                icon.image = #imageLiteral(resourceName: " ic_package_out_grey")
            }
            else {
                icon.image = #imageLiteral(resourceName: " ic_package_in")
            }
        }
        if let message = message {
            messageLabel.text = message
        }

        if let date = updatedDate {
            dateLabel.text = date
        }

        mainImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true

        senderLabel.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor, constant: 8).isActive = true
        senderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 21).isActive = true
        senderLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44).isActive = true
        senderLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        subjectLabel.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor, constant: 8).isActive = true
        subjectLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 43).isActive = true
        subjectLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44).isActive = true
        subjectLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true

        messageLabel.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor, constant: 8).isActive = true
        messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 69).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
