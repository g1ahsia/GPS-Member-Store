//
//  ImagesViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/30.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class ImagesViewController: UIViewController, UIScrollViewDelegate {
    var images = [UIImage]()
    let imageView = UIImageView()

    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.borderWidth = 5
        return scrollView
    }()
    
    let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    
    var close : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: " ic_fill_cross_grey"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)

        view.addSubview(mainScrollView)
        images = [#imageLiteral(resourceName: "product-img"), #imageLiteral(resourceName: "001246"), #imageLiteral(resourceName: "item-1")]
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        mainScrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        let imageScrollView = UIScrollView()
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 10.0

        mainScrollView.addSubview(imageScrollView)

        imageScrollView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor).isActive = true
        imageScrollView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        imageScrollView.rightAnchor.constraint(equalTo: mainScrollView.rightAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = images[0]

        imageScrollView.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: imageScrollView.leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: imageScrollView.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageScrollView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor).isActive = true

        
        imageScrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(images.count)

        view.addSubview(close)

        close.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        close.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true


    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }


    @objc func rotated() {
        if UIDevice.current.orientation == .faceDown {
            // it's face down
            mainScrollView.contentSize.width = view.safeAreaLayoutGuide.layoutFrame.size.height * CGFloat(images.count)
        }

        else if UIDevice.current.orientation.isLandscape {
//            let window = UIApplication.shared.keyWindow
            

            print("Landscape actual height \(view.safeAreaLayoutGuide.layoutFrame.size.height)")
            mainScrollView.contentSize.width = view.safeAreaLayoutGuide.layoutFrame.size.width * CGFloat(images.count)

        } else {
            print("Portrait actual height \(view.safeAreaLayoutGuide.layoutFrame.size.height)")
            mainScrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(images.count)
        }
    }
    
    @objc private func closeButtonTapped(sender: UIButton!) {
        dismiss(animated: true) {
        }
    }


}
