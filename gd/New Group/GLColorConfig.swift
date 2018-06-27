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
