//
//  GLCalenderDayCell.swift
//  gd
//
//  Created by fitz on 2018/6/25.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GLCalenderDayCell: UICollectionViewCell {
    var dayLabel: UILabel!
    var tipLabelList: [UILabel]! = []
    
    var rightLine: UIView!
    var bottomLine: UIView!
    
    func loadData(model: Any) {
        if dayLabel == nil {
            dayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
            dayLabel.textAlignment = .center
            addSubview(dayLabel)
            // snap约束
            
        }
    }
}
