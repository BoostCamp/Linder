//
//  Extensions.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 7..
//  Copyright © 2017년 Linder. All rights reserved.
//


import UIKit
import EventKit

extension UIImage {
    func resize(newHeight: CGFloat) -> UIImage? {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
}

extension String {
    init?(date: Date) {
        // set basic formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP") // 2001/01/02
        
        //Get Date String
        let DateString = formatter.string(from: date)
        
        //Return Date String
        self = DateString
    }
    
    func toDateTime() -> Date?
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP") // 2001/01/02
        //Parse into Date
        let dateFromString = formatter.date(from: self)
        
        //Return Parsed Date
        return dateFromString
    }
    
    func toDateTime(withDateFormatter formatter:DateFormatter) -> Date?
    {
        //Parse into Date
        let dateFromString = formatter.date(from: self)
    
        //Return Parsed Date
        return dateFromString
    }
}

extension Date {
    init?(string: String) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")  // 2001/01/02
        //Parse into Date
        if let dateFromString = formatter.date(from: string) {
            self = dateFromString
        } else {
            return nil
        }
    }
    
    func toDateString() -> String
    {
        // set basic formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP") // 2001/01/02
        
        //Get Date String
        let DateString = formatter.string(from: self)
        
        //Return Date String
        return DateString
    }
    
    func toDateString(_ formatter:DateFormatter) -> String
    {
        //Get Date String
        let DateString = formatter.string(from: self)
        
        //Return Date String
        return DateString
    }
}
