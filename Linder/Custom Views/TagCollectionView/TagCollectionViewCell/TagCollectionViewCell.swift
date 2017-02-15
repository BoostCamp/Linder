//
//  TagCollectionViewCell.swift
//  Linder
//
//  Created by 박종훈 on 2017. 1. 17..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = 12.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.ldPuple.cgColor
        layer.masksToBounds = true
        
        selectedBackgroundView = UIView(frame: layer.frame)
        selectedBackgroundView?.backgroundColor = UIColor.ldPuple
    }
    
    func setSelected() {
        //isSelected = true
        tagLabel.textColor = UIColor.white
        titleLabel.textColor = UIColor.white
    }
    
    func setDeselect() {
        //isSelected = false
        tagLabel.textColor = UIColor.ldPuple
        titleLabel.textColor = UIColor.ldPuple
    }
    
    
}
