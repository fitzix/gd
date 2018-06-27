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
        
        detailView.backgroundColor = GLColorUtil.random(tableCellIndex: indexPath)
        
        titleLabel.text = glAgendaResp.title
        timeLabel.text = "\(glAgendaResp.beginTime ?? "") ~ \(glAgendaResp.endTime ?? "")"
        locationLabel.text = glAgendaResp.place
    }

}

