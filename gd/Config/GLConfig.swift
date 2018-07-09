//
//  ColorConfig.swift
//  gd
//
//  Created by fitz on 2018/6/27.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GLConfig {
    static let CAL_START_DATE = "1960-01-01"
    static let CAL_END_DATE_AFTER_NOW_YEAR = 100
}


// 事件性质

enum GLAgendaType: Int {
    case focus, daily, casual, sport
    
    var title: String {
        switch self {
        case .focus: return "专注"
        case .daily: return "日常"
        case .casual: return "休闲"
        case .sport: return "运动"
        }
    }
}

// 提醒类型
enum GLRemindType: String {
    case no = "0"
    case five = "1"
    case fifteen = "2"
    case thirty = "3"
    case hour = "4"
    case day = "5"
    
    var title: String {
        switch self {
        case .no: return "不提醒"
        case .five: return "5分钟"
        case .fifteen: return "15分钟"
        case .thirty: return "30分钟"
        case .hour: return "一小时"
        case .day: return "一天"
        }
    }
}

// 重复类型

enum GLRepeatType: Int {
    case no, day, week, month, year
    
    var title: String {
        switch self {
        case .no: return "不重复"
        case .day: return "每天"
        case .week: return "每周"
        case .month: return "每月"
        case .year: return "每年"
        }
    }
}

