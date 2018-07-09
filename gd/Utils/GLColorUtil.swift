//
//  GLColorUtil.swift
//  gd
//
//  Created by fitz on 2018/6/27.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GLColorUtil {
    
    class func random(tableCellIndex: Int) -> UIColor {
        if tableCellIndex % 2 == 0 {
            return UIColor(red:0.80, green:0.90, blue:1.00, alpha:1.00)
        } else {
            return UIColor(red:0.97, green:0.97, blue:0.98, alpha:1.00)
        }
    }
}
