//
//  TagCollectionViewLayout.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 1. 20..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

class TagCollectionViewLayout: UICollectionViewLayout {
    var delegate: TagCollectionViewLayoutDelegate!
    
    var cellPadding: CGFloat = 3.0
    let inSectionPadding: CGFloat = 8.0
    
    //This is an array to cache the calculated attributes. When you call prepareLayout(), you’ll calculate the attributes for all items and add them to the cache. When the collection view later requests the layout attributes, you can be efficient and query the cache instead of recalculating them every time.
    //private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        guard let collectionView = collectionView else {
            return layoutAttributes
        }
        
        let sectionsCount = collectionView.dataSource!.numberOfSections!(in: collectionView)
        
        // This declares and fills the xOffset array with the x-coordinate for every column based on the column widths. The yOffset array tracks the y-position for every column. You initialize each value in yOffset to 0, since this is the offset of the first item in each column.
        let numberOfColumns:Int = delegate.numberOfColumns(in: collectionView)
        let columnWidth = (contentWidth - 2 * inSectionPadding) / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(inSectionPadding + CGFloat(column) * columnWidth)
        }
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        // This loops through all the items in the sections
        for section in 0..<sectionsCount {
            var column = 0
            /// add header
            layoutAttributes.append(self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: section))!)
            
            let sectionHeight:CGFloat = delegate.collectionView(collectionView: collectionView, heightForSection: section)
            
            yOffset = yOffset.map({ (before) -> CGFloat in
                if let max = yOffset.max() {
                    return max + sectionHeight
                }
                return sectionHeight
            })
            
            let itemsCount = collectionView.numberOfItems(inSection: section)
            
            for item in 0..<itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                
                // This is where you perform the frame calculation. width is the previously calculated cellWidth, with the padding between cells removed. You ask the delegate for the height of the image and the annotation, and calculate the frame height based on those heights and the predefined cellPadding for the top and bottom. You then combine this with the x and y offsets of the current column to create the insetFrame used by the attribute.
                let width = columnWidth - cellPadding * 2
                let annotationHeight = delegate.collectionView(collectionView: collectionView, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                let height = cellPadding + annotationHeight + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                // This creates an instance of UICollectionViewLayoutAttribute, sets its frame using insetFrame and appends the attributes to cache.
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                
                layoutAttributes.append(attributes)
                
                // This creates an instance of UICollectionViewLayoutAttribute, sets its frame using insetFrame and appends the attributes to cache.
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                column = column >= (numberOfColumns - 1) ? 0 : column + 1
            }
        }

        return layoutAttributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionElementKindSectionHeader:
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)

            guard let collectionView = collectionView else {
                return attributes
            }
            
            let section = indexPath.section
            let numberOfColumns = delegate.numberOfColumns(in: collectionView)
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            let width = columnWidth - cellPadding * 2
            var yOffset: CGFloat = 0.0
            
            for formerSection in 0..<section {
                yOffset = yOffset + delegate.collectionView(collectionView: collectionView, heightForSection: formerSection)
                let numberOfRows = Int(ceil(Double(collectionView.numberOfItems(inSection: formerSection)) / Double(numberOfColumns)))
                var heightsForRows:[CGFloat] = []
                for row in 0..<numberOfRows {
                    var heights: [CGFloat] = []
                    for column in 0..<numberOfColumns - 1 {
                        heights.append(delegate.collectionView(collectionView: collectionView, heightForAnnotationAtIndexPath: IndexPath(item: row * numberOfColumns + column, section: formerSection), withWidth: width))
                    }
                    let maxHeight = heights.max() ?? 0
                    heightsForRows.append(maxHeight + cellPadding * 2)
                }
                yOffset = yOffset + heightsForRows.reduce(0, +)
            }
            
            let sectionHeight:CGFloat = delegate.collectionView(collectionView: collectionView, heightForSection: section)
            
            attributes.frame = CGRect(x: 0, y: yOffset, width: collectionView.contentSize.width, height: sectionHeight)
            
            return attributes
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
}

protocol TagCollectionViewLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
    
    func numberOfColumns(in collectionView: UICollectionView) -> Int
    
    func collectionView(collectionView: UICollectionView, heightForSection section: Int) -> CGFloat
}
