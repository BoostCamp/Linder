//
//  ChannelCollectionViewCell.swift
//  Pastel
//
//  Created by 박종훈 on 2017. 1. 20..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

class ChannelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var thumbnail: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnailView.layer.cornerRadius = 8.0
        thumbnailView.layer.borderWidth = 0.5
        thumbnailView.layer.borderColor = UIColor.black.cgColor
        thumbnailView.layer.masksToBounds = true
        
        checkImage.image = #imageLiteral(resourceName: "check")
        checkImage.isHidden = true
    }
    
    func setSelected() {
        if thumbnail == nil {
            thumbnail = thumbnailView.image
        }
        thumbnailView.image = maskImage(thumbnail!)
        checkImage.isHidden = false
    }
    
    func setDeSelected () -> Void {
        thumbnailView.image = thumbnail
        checkImage.isHidden = true
    }

    func maskImage(_ image: UIImage) -> UIImage{
        let rect = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        let c : CGContext = UIGraphicsGetCurrentContext()!
        image.draw(in: rect)
        c.setFillColor(UIColor.black.withAlphaComponent(0.5).cgColor)
        c.setBlendMode(CGBlendMode.sourceAtop)
        c.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
