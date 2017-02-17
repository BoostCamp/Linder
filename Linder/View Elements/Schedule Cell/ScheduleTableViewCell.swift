//
//  ScheduleTableViewCell.swift
//  Pastel
//
//  Created by 박종훈 on 2017. 2. 10..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: ScheduleCalendarViewCell {
    // TODO :  오른쪽에 > 왼쪽에 + 버튼 . 셀 누르면 아래에 디테일 설명이 나와야 한다.
    @IBOutlet weak var tableViewCell: UIView!
    @IBOutlet weak var extensionCell: UIView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var detailTextView: UITextView!
    
    
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
