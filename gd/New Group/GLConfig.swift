//
//  ColorConfig.swift
//  gd
//
//  Created by fitz on 2018/6/27.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

enum GLColorConf {
    case BlackHaze
    case Mabel
    case BlueGray
    case Scooter
    
    var color: UIColor {
        switch self {
        case .BlackHaze:
            return UIColor(red:0.97, green:0.97, blue:0.98, alpha:1.00)
        case .Mabel:
            return UIColor(red:0.84, green:0.96, blue:0.99, alpha:1.00)
        case .BlueGray:
            return UIColor(red:0.40, green:0.60, blue:0.80, alpha:1.00)
        case .Scooter:
            return UIColor(red:0.20, green:0.60, blue:0.60, alpha:1.00)
        }
    }
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
