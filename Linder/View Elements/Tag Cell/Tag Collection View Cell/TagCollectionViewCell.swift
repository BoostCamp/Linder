//
//  TagCollectionViewCell.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 1. 17..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var _cornerRadius: CGFloat = 12.0
    private var _borderWidth: CGFloat = 1.0
    private var _borderColor = UIColor.ldPuple
    
    var cornerRadius: CGFloat {
        get {
            return _cornerRadius
        }
        set (new) {
            self.layer.cornerRadius = new
            self._cornerRadius = new
        }
    }
    var borderWidth: CGFloat {
        get {
            return _borderWidth
        }
        set (new) {
            self.layer.borderWidth = new
            self._borderWidth = new
        }
    }
    var borderColor: UIColor {
        get {
            return _borderColor
        }
        set (new) {
            self.layer.borderColor = new.cgColor
            self._borderColor = new
        }
    }
    var textColor: UIColor {
        get {
            return self.titleLabel.textColor
        }
        set (new) {
            self.tagLabel.textColor = new
            self.titleLabel.textColor = new
        }
    }
    
    var textFontSize: CGFloat {
        get {
            return self.titleLabel.font.pointSize
        }
        set (new) {
            self.tagLabel.font.withSize(new)
            self.titleLabel.font.withSize(new)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
        
        selectedBackgroundView = UIView(frame: layer.frame)
        selectedBackgroundView?.backgroundColor = UIColor.ldPuple
    }
    
    func setLabelSelected(_ isSelecting: Bool) {
        
    }
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            let color = isSelected ? UIColor.white : UIColor.ldPuple
            tagLabel.textColor = color
            titleLabel.textColor = color
        }
    }
    
    
}
