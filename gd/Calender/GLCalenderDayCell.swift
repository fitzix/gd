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
    
    func loadData(model: [GLAgendaResp]?) {
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
            lunarLabel.font = UIFont.systemFont(ofSize: 12)
            lunarLabel.textAlignment = .center
            addSubview(lunarLabel)
            lunarLabel.snp.makeConstraints({ (constraintMaker) in
                constraintMaker.left.equalToSuperview().offset(5)
                constraintMaker.top.equalTo(dayLabel.snp.bottom)
                constraintMaker.height.equalTo(15)
                constraintMaker.right.equalToSuperview()
            })
        }
        
        if tipLabelList.count == 0 {
            let distance = (bounds.height - 30 - 10)/5
            for index in 0...4 {
                let tipLabel = UILabel(frame: CGRect(x: 2, y: 30 + CGFloat(index) * (distance + 2), width: self.bounds.width - 4, height: distance))
                tipLabel.font = UIFont.systemFont(ofSize: 11)
                tipLabel.textAlignment = .center
                addSubview(tipLabel)
                tipLabelList.append(tipLabel)
            }
        }
        // resetTipList
        for index in 0...4 {
            guard let title = model?[safe: index]?.title else {
                tipLabelList[index].alpha = 0
                continue
            }
            tipLabelList[index].alpha = 1
            tipLabelList[index].text = title
            tipLabelList[index].backgroundColor = UIColor(red:0.95, green:0.89, blue:0.99, alpha:1.00)
        }

    }
}
