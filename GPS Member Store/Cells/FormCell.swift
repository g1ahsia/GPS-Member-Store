//
//  FormCell.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/7.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class FormCell: UITableViewCell {
    var field : String?
    var placeholder : String?
    var fieldType : FieldType?
    
    var fieldLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.sizeToFit()
        textLabel.textColor = BLACKAlpha40
        return textLabel
    }()
    
    var answerField : UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textField.textAlignment = .left
        textField.autocapitalizationType = .none;
        textField.returnKeyType = .done
        return textField
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier : reuseIdentifier)
        self.addSubview(fieldLabel)
        self.addSubview(answerField)
        answerField.delegate = self
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        
        if let field = field {
            fieldLabel.text = field
        }
        
        if let placeholder = placeholder {
            answerField.placeholder = placeholder
        }
        if let type = fieldType {
            switch type {
            case FieldType.Text:
                break
            case FieldType.Password:
                answerField.isSecureTextEntry = true
                break
            case FieldType.Selection:
                answerField.isUserInteractionEnabled = false
                break
            case FieldType.Number:
                answerField.keyboardType = .numberPad
                break
            case FieldType.Email:
                answerField.keyboardType = .emailAddress
                break
            default:
                break
            }
        }

        fieldLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        fieldLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        fieldLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        answerField.leftAnchor.constraint(equalTo: fieldLabel.rightAnchor, constant: 16).isActive = true
        answerField.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        answerField.widthAnchor.constraint(equalToConstant: 180).isActive = true
        answerField.heightAnchor.constraint(equalToConstant: 20).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FormCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        return true
    }
}
