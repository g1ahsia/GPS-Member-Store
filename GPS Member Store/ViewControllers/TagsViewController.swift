//
//  TagsViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/31.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class TagsViewController: UIViewController, UITextViewDelegate {
    var tagsString : String?
    var tags = [String]()
    var lastWord = ""
    var kbSize = CGSize(width: 0.0, height: 0.0)

    lazy var descView : UITextView = {
        var textView = UITextView()
        textView.sizeToFit()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textView.textColor = .black
        textView.delegate = self
        textView.clipsToBounds = false
//        textView.textContainerInset = .zero; // fix the silly UITextView bug
//        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
//        textView.isScrollEnabled = false
        return textView
    }()
    
    lazy var tagTableView : UITableView = {
        var tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tags")
        tableView.isHidden = true
        tableView.layer.borderColor = UIColor .red.cgColor
        tableView.layer.borderWidth = 1
        return tableView
    }()

    
    var save : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("儲存", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

        title = "編輯標籤"
        tags = ["#心臟病", "#高血壓", "#中風"]
        view.backgroundColor = SNOW
        view.addSubview(descView)
        view.addSubview(save)
        view.addSubview(tagTableView)
        setupLayout()
    }
    
    private func setupLayout() {
        if let tagsString = tagsString {
            descView.text = tagsString
        }
        descView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        descView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        descView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        descView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        save.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        save.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 30).isActive = true
        save.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        save.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
//        tagTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
//        tagTableView.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 30).isActive = true
//        tagTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
//        tagTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    @objc private func saveButtonTapped(sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchAndReload), object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // Change `0.05` to the desired number of seconds.
            self.searchAndReload()
        }
        let descString = textView.text.replacingOccurrences(of: "\n", with: "")
        let words = descString.components(separatedBy: " ")
        lastWord = words[words.count - 1]
    }
    
    @objc func searchAndReload() {
        // TextView
        let textViewOrigin = self.view.convert(descView.frame, from: self.view).origin
        
        // Cursor
        let textViewCursor = descView.caretRect(for: descView.selectedTextRange!.start).origin
        let cursorPoint = CGPoint(x: textViewCursor.x + textViewOrigin.x, y: textViewCursor.y)
        
        let keyboardTop = self.view.frame.size.height - kbSize.height

        tagTableView.frame = CGRect(x: 0, y: view.safeAreaLayoutGuide.layoutFrame.origin.y + cursorPoint.y + 25, width: UIScreen.main.bounds.width, height: keyboardTop - (view.safeAreaLayoutGuide.layoutFrame.origin.y + cursorPoint.y + 25) )
        if (lastWord.count != 0 &&
            lastWord.prefix(1) == "#") {
            tagTableView.isHidden = false
        }
        else {
            tagTableView.isHidden = true
        }
    }
    @objc func keyboardWillShow(notification:NSNotification){

        print("keyboardWillShow")

        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        kbSize = keyboardFrame.size
        
    }

    @objc func keyboardWillHide(notification:NSNotification){
        print("keyboardWillHide")

    }

}

extension TagsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tags", for: indexPath)
        cell.textLabel?.text = tags[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        descView.text = descView.text + tags[indexPath.row].suffix(tags.count) + " "
        tagTableView.isHidden = true
    }
}
