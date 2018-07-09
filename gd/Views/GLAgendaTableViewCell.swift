//
//  AgendaTableViewCell.swift
//  gd
//
//  Created by fitz on 2018/6/26.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import DateHelper

class GLAgendaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    var agendaDetail: GLAgendaResp?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layoutMargins = UIEdgeInsetsMake(20, 0, 20, 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadData(glAgendaResp: GLAgendaResp, indexPath: Int, isHeader: Bool) {
        dateLabel.text = ""
        
        if  isHeader, let beginDateString = glAgendaResp.beginDate, let beginDate = Date(fromString: beginDateString, format: .isoDate)  {
            let date = beginDate.toString(format: .custom("dd"))
            let week = beginDate.toString(style: .shortWeekday)
            dateLabel.text = "\(date)\n\(week)"
        }
        if glAgendaResp.id == nil {
            detailView.backgroundColor = UIColor(red:1.00, green:0.62, blue:0.01, alpha:1.00)
            titleLabel.textColor = .white
            timeLabel.textColor = .white
            locationLabel.textColor = .white
        } else {
            detailView.backgroundColor = GLColorUtil.random(tableCellIndex: indexPath)
            titleLabel.textColor = .black
            timeLabel.textColor = .black
            locationLabel.textColor = .black
        }
        titleLabel.text = glAgendaResp.title
        timeLabel.text = "\(glAgendaResp.beginTime?.prefix(5) ?? "") ~ \(glAgendaResp.endTime?.prefix(5) ?? "")"
        locationLabel.text = glAgendaResp.place
    }

}

