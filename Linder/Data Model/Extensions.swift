//
//  Extensions.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 1. 31..
//  Copyright © 2017년 Hidden Track. All rights reserved.
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
        
        self.init(date: date, formatter: formatter)
    }
    
    init?(date: Date, formatter: DateFormatter) {
        //Get Date String
        let DateString = formatter.string(from: date)
        
        //Return Date String
        self = DateString
    }
    
    init(gender: Gender) {
        switch gender {
        case .man:
            self = "남자"
        case .woman:
            self = "여자"
        default:
            self = "기타"
        }
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
    init?(string: String, formatter: DateFormatter) {
        //Parse into Date
        if let dateFromString = formatter.date(from: string) {
            self = dateFromString
        } else {
            return nil
        }
    }
    
    init?(string: String) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")  // 2001/01/02
        
        self.init(string: string, formatter: formatter)
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
    
    func toTimeString() -> String
    {
        //Set Date Formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        
        //Get Time String
        let TimeString = formatter.string(from: self)
        
        //Return Time String
        return TimeString
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func numberOfDaysInMonth() -> Int {
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: self)
        return dateComponents.numberOfDaysInMonth()
    }
}

extension DateComponents {
    func numberOfDaysInMonth() -> Int {
        let calendar = Calendar.current
        let date = calendar.date(from: self)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
    public var startDate: Date {
        get {
            return Calendar.current.date(from: self)!
        }
    }
    
    func toDateString(_ formatter:DateFormatter) -> String?
    {
        if let date = Calendar.current.date(from: self) {
            //Get Date String
            let DateString = formatter.string(from: date)
            
            //Return Date String
            return DateString
        }
        return nil
    }
}

extension TimeInterval {
    static let hour = 60.0
    static let day = 24 * hour
    static let week = 7 * day
    static let month30 = 30 * day
}

extension UINavigationController {
    
    public func pushViewController(_ viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
}

