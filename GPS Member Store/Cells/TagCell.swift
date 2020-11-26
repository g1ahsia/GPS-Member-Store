//
//  TagCell.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/27.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class TagCell: UITableViewCell {
    var name : String?

    var nameLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 17)
        textLabel.textColor = MYTLE
        textLabel.clipsToBounds = true;
        return textLabel
    }()

    var checkMarkImageView : UIImageView = {
       var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15;
        imageView.clipsToBounds = true;
        imageView.image = #imageLiteral(resourceName: " ic_fill_check")
        return imageView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier : reuseIdentifier)
        self.backgroundColor = .clear

        self.addSubview(nameLabel)
        self.addSubview(checkMarkImageView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super .setSelected(selected, animated: animated)
        if (selected) {
            checkMarkImageView.isHidden = false
            nameLabel.textColor = ATLANTIS_GREEN
        }
        else {
            checkMarkImageView.isHidden = true
            nameLabel.textColor = MYTLE
        }

    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        
        if let name = name {
            nameLabel.text = name
        }
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        checkMarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkMarkImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        checkMarkImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkMarkImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
                
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

