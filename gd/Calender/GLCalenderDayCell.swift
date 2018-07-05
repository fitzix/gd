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
            
            dayLabel = UILabel()
            dayLabel.font = UIFont.systemFont(ofSize: 10)
            dayLabel.textAlignment = .center
            addSubview(dayLabel)
            dayLabel.snp.makeConstraints({ (constraintMaker) in
                constraintMaker.left.equalToSuperview().offset(5)
                constraintMaker.top.equalToSuperview()
                constraintMaker.height.equalTo(15)
                constraintMaker.right.equalToSuperview()
            })
        }
        if lunarLabel == nil {
            lunarLabel = UILabel()
            lunarLabel.font = UIFont.systemFont(ofSize: 11)
            lunarLabel.textAlignment = .center
            addSubview(lunarLabel)
            lunarLabel.snp.makeConstraints({ (constraintMaker) in
                constraintMaker.left.equalToSuperview().offset(5)
                constraintMaker.top.equalTo(dayLabel.snp.bottom)
                constraintMaker.height.equalTo(15)
                constraintMaker.right.equalToSuperview()
            })
        }
        if rightLine == nil
        {
            rightLine = UIView()
            bottomLine = UIView()
            rightLine.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            bottomLine.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            
            addSubview(rightLine)
            addSubview(bottomLine)
            
            bottomLine.snp.makeConstraints({ (constraintMaker) in
                constraintMaker.left.equalToSuperview()
                constraintMaker.right.equalToSuperview()
                constraintMaker.bottom.equalToSuperview()
                constraintMaker.height.equalTo(0.3)
            })
            
            rightLine.snp.makeConstraints({ (constraintMaker) in
                constraintMaker.top.equalToSuperview()
                constraintMaker.right.equalToSuperview()
                constraintMaker.bottom.equalToSuperview()
                constraintMaker.width.equalTo(0.4)
            })
        }
        
    }
}
