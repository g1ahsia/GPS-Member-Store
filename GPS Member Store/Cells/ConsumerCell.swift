//
//  ConsumerCell.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/28.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class ConsumerCell: UITableViewCell {
    var name : String?
    var mobilePhone : String?
        
    var lastNameBackground : UIView = {
        var view = UIView()
        view.backgroundColor = SHUTTLE_GREY
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var lastNameLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 20)
        textLabel.textColor = .white
        textLabel.clipsToBounds = true
        return textLabel
    }()
    
    var nameLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 17)
        textLabel.textColor = .black
        textLabel.clipsToBounds = true
        return textLabel
    }()

    var mobilePhoneLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.textColor = .black
        textLabel.clipsToBounds = true
        return textLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier : reuseIdentifier)
        
        self.addSubview(lastNameBackground)
        lastNameBackground.addSubview(lastNameLabel)
        self.addSubview(nameLabel)
        self.addSubview(mobilePhoneLabel)
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        if let name = name {
            nameLabel.text = name
            lastNameLabel.text = String(name.prefix(1))
        }
        if let mobilePhone = mobilePhone {
            mobilePhoneLabel.text = mobilePhone
        }
        
        lastNameBackground.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lastNameBackground.widthAnchor.constraint(equalToConstant: 40).isActive = true
        lastNameBackground.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lastNameBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        
        lastNameLabel.centerYAnchor.constraint(equalTo: lastNameBackground.centerYAnchor).isActive = true
        lastNameLabel.centerXAnchor.constraint(equalTo: lastNameBackground.centerXAnchor).isActive = true
        lastNameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true

        nameLabel.leftAnchor.constraint(equalTo: self.lastNameBackground.rightAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        mobilePhoneLabel.leftAnchor.constraint(equalTo: self.lastNameBackground.rightAnchor, constant: 10).isActive = true
        mobilePhoneLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 36).isActive = true
        mobilePhoneLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44).isActive = true
        mobilePhoneLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

