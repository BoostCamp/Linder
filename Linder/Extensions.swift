//
//  Extensions.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 7..
//  Copyright © 2017년 Linder. All rights reserved.
//


import Foundation
import EventKit

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
