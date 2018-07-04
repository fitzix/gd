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
    var lunarLabel: UILabel!
    var tipLabelList: [UILabel]! = []
    
    var rightLine: UIView!
    var bottomLine: UIView!
    
    func loadData(model: Any) {
        if dayLabel == nil {
            
            dayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
            dayLabel.font = UIFont.systemFont(ofSize: 10)
            dayLabel.textAlignment = .center
            addSubview(dayLabel)
            dayLabel.snp.makeConstraints({ (constraintMaker) in
                constraintMaker.left.equalToSuperview()
                constraintMaker.top.equalToSuperview()
                constraintMaker.height.equalTo(30)
                constraintMaker.width.equalTo(40)
            })
        }
//        if lunarLabel == nil {
//
//            lunarLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
//            lunarLabel.font = UIFont.systemFont(ofSize: 12)
//            lunarLabel.textAlignment = .center
//            addSubview(dayLabel)
//            dayLabel.snp.makeConstraints({ (constraintMaker) in
//                constraintMaker.left.equalToSuperview()
//                constraintMaker.top.equalTo(dayLabel.snp.bottom)
//                constraintMaker.height.equalTo(30)
//                constraintMaker.width.equalTo(40)
//            })
//        }
    }
}
