//
//  ChannelCollectionViewLayout.swift
//  Linder
//
//  Created by 박종훈 on 2017. 1. 25..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

let channelCollectionViewCellWidth: CGFloat = 50.0
let channelCollectionViewCellHeight: CGFloat = 75.0

class ChannelCollectionViewLayout: UICollectionViewFlowLayout {
    
    let interCellSpacing: CGFloat = 10.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        itemSize = CGSize(width: channelCollectionViewCellWidth, height: channelCollectionViewCellHeight)
        scrollDirection = .horizontal
        minimumInteritemSpacing = interCellSpacing
        sectionHeadersPinToVisibleBounds = true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard var oldAttributesArray = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        if oldAttributesArray == [] {
            return nil
        }
        var newAttributesArray = [UICollectionViewLayoutAttributes]()
        newAttributesArray.append(oldAttributesArray[0].copy() as! UICollectionViewLayoutAttributes)
        
        for item in 1..<oldAttributesArray.count {
            let currentAttributes: UICollectionViewLayoutAttributes = oldAttributesArray[item].copy() as! UICollectionViewLayoutAttributes
            let previousAttributes = newAttributesArray[item - 1]
            
            let xOrigin = previousAttributes.frame.maxX

            var frame = currentAttributes.frame
            frame.origin.x = xOrigin + interCellSpacing
            currentAttributes.frame = frame
            newAttributesArray.append(currentAttributes)
        }
        return newAttributesArray
    }

}
