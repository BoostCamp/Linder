//
//  ScheduleTableViewCell.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 2. 10..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: ScheduleCalendarViewCell {
    
    @IBOutlet weak var tableViewCell: UIView!
    @IBOutlet weak var extensionCell: UIView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var detailTextView: UITextView!

    override var schedule: Schedule? {
        set (new) {
            super.schedule = new
            detailTextView.text = new?.detail
        }
        get {
            return super.schedule
        }
    }
    
    var origianlIndicator: UIImageView?
    var flipedIndicator: UIImageView?
    var isIndicatorFliped = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //tableViewCell.layer.borderWidth = 0.1
        //tableViewCell.layer.borderColor = UIColor.darkGray.cgColor
        self.selectionStyle = .none
        
        flipedIndicator = UIImageView(image: #imageLiteral(resourceName: "UpArrow"))
        origianlIndicator = UIImageView(image: #imageLiteral(resourceName: "DownArrow"))
        
        indicatorView.addSubview(origianlIndicator!)
    }
    
    func flipIndicator() {
        guard let flipedIndicator = self.flipedIndicator, let origianlIndicator = self.origianlIndicator else {
            return
        }
        if isIndicatorFliped {
            UIView.transition(from: flipedIndicator, to: origianlIndicator, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromBottom, completion: nil)
            isIndicatorFliped = false
        } else {
            UIView.transition(from: origianlIndicator, to: flipedIndicator, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromBottom, completion: nil)
            isIndicatorFliped = true
        }
    }
}
