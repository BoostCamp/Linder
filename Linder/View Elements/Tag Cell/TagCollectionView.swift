//
//  TagCollectionView.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 1. 18..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

class TagCollectionView: UICollectionView {
    //var numberOfColumns: Int = 4
    var preferredCellWidth: CGFloat = 100
    var SectionHeight: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let layout = collectionViewLayout as? TagCollectionViewLayout {
            layout.delegate = self
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
    */
}

extension TagCollectionView :  TagCollectionViewLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        return 25
    }
    
    func numberOfColumns(in collectionView: UICollectionView) -> Int {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width //화면 너비
        
        return Int(round(width / preferredCellWidth)) - 1
    }
    
    func collectionView(collectionView: UICollectionView, heightForSection: Int) -> CGFloat {
        return SectionHeight
    }
}
