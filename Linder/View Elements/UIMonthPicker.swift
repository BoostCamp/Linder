//
//  UIMonthPicker.swift
//
//  Created by Ben Dodson on 15/04/2015.
//  Modified by Jiayang Miao on 24/10/2016 to support Swift 3
//  Modified by 박종훈 on 2017. 2. 16..
//
import UIKit

class UIMonthPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let componentForYear = 0
    let componentForMonth = 1
    
    var startYear = 1990
    var endYear = 2100
    
    var months: [String]!
    var years: [Int]!
    
    var month: Int = 0 {
        didSet {
            selectRow(month-1, inComponent: componentForMonth, animated: false)
        }
    }
    
    var year: Int = 0 {
        didSet {
            selectRow(year, inComponent: componentForYear, animated: true)
        }
    }
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        // population years
        let years: [Int] = Array(startYear...endYear)
        self.years = years
        
        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            months.append(formatter.monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
        self.delegate = self
        self.dataSource = self
        
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: Date())
        self.selectRow(currentMonth - 1, inComponent: componentForMonth, animated: false)
        
        let currentYear = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: Date())
        self.selectRow(currentYear - startYear, inComponent: componentForYear, animated: false)
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case componentForMonth :
            return months[row]
        case componentForYear :
            return "\(years[row])" + "년"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case componentForMonth :
            return months.count
        case componentForYear:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRow(inComponent: componentForMonth)+1
        let year = years[self.selectedRow(inComponent: componentForYear)]
        if let block = onDateSelected {
            block(month, year)
        }
        
        self.month = month
        self.year = year
    }
    
}
