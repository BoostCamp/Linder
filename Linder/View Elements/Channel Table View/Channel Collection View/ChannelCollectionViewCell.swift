//
//  ChannelCollectionViewCell.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 1. 20..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit
import Nuke

class ChannelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var maskingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //var thumbnail: UIImage?
    
    static let cornerRadius: CGFloat = 8.0
    static let borderWidth: CGFloat = 0.5
    static let borderColor = UIColor.black.cgColor
    
    var channel: Channel = Channel() {
        didSet {
            self.title.text = channel.title
            
            if let url =  channel.thumbnailURL {
                Nuke.loadImage(with: url, into: self.thumbnailView!)
                activityIndicator.stopAnimating()
            }
//            else {
//                // TODO : Defalt Event Background Asset needed
//                self.thumbnailView.image = #imageLiteral(resourceName: "channel")
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnailView.layer.cornerRadius = ChannelCollectionViewCell.cornerRadius
        thumbnailView.layer.borderWidth = ChannelCollectionViewCell.borderWidth
        thumbnailView.layer.borderColor = ChannelCollectionViewCell.borderColor
        thumbnailView.layer.masksToBounds = true
        
        maskingView.layer.cornerRadius = ChannelCollectionViewCell.cornerRadius
        maskingView.isHidden = true
        
        checkImage.image = #imageLiteral(resourceName: "check")
        checkImage.isHidden = true
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func setSelected() {
//        if thumbnail == nil {
//            thumbnail = thumbnailView.image
//        }
//        thumbnailView.image = maskImage(thumbnail!)
        maskingView.isHidden = false
        checkImage.isHidden = false
    }
    
    func setDeSelected () -> Void {
//        thumbnailView.image = thumbnail
        maskingView.isHidden = true
        checkImage.isHidden = true
    }
//
//    func maskImage(_ image: UIImage) -> UIImage{
//        let rect = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
//        let c : CGContext = UIGraphicsGetCurrentContext()!
//        image.draw(in: rect)
//        c.setFillColor(UIColor.black.withAlphaComponent(0.5).cgColor)
//        c.setBlendMode(CGBlendMode.sourceAtop)
//        c.fill(rect)
//        return UIGraphicsGetImageFromCurrentImageContext()!
//    }
}
