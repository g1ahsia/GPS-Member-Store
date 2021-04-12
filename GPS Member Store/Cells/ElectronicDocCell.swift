
import Foundation
import UIKit
import PDFKit

class ElectronicDocCell: UITableViewCell {
    var fileUrl : String?
    var createdDate : String?
        
    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 5;
        imageView.clipsToBounds = true;
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var createdDateLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Bold", size: 13)
        textLabel.textColor = .black
        textLabel.clipsToBounds = true;
        return textLabel
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
        self.backgroundColor = .clear

        self.addSubview(mainImageView)
        self.addSubview(createdDateLabel)
        self.addSubview(arrow)

    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        if let fileUrl = fileUrl {
            
            let url = URL(string: fileUrl)
            DispatchQueue.global(qos: .background).async {
//                print("This is run on the background queue")
                let thumbnail = drawPDFfromURL(url: url!)
                DispatchQueue.main.async {
//                    print("This is run on the main queue, after the previous code in outer block")
                    self.mainImageView.image = thumbnail
                }
            }

        }
        if let createdDate = createdDate {
            createdDateLabel.text = createdDate
        }
        
        mainImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true

        createdDateLabel.leftAnchor.constraint(equalTo: mainImageView.rightAnchor, constant: 8).isActive = true
        createdDateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        createdDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44).isActive = true
        createdDateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
                
        arrow.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


func drawPDFfromURL(url: URL) -> UIImage? {
    print("start drawing")
    guard let document = CGPDFDocument(url as CFURL) else { return nil }
    guard let page = document.page(at: 1) else { return nil }

    let pageRect = page.getBoxRect(.mediaBox)
    let renderer = UIGraphicsImageRenderer(size: pageRect.size)
    let img = renderer.image { ctx in
        UIColor.white.set()
        ctx.fill(pageRect)

        ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
        ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

        ctx.cgContext.drawPDFPage(page)
    }
    print("end drawing")

    return img
}
