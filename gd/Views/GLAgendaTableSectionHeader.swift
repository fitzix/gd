//
//  GLAgendaTableSectionHeader.swift
//  gd
//
//  Created by Fitz Leo on 2018/6/27.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import DateHelper

class GLAgendaTableSectionHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var labelHeaderBtn: UIButton!
    
    func reloadData(headerDate: Date) {
        labelHeaderBtn.titleLabel?.text = headerDate.toString(format: .isoYearMonth)
    }
}
