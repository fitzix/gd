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
            return GLColorConf.BlackHaze.color
        } else {
            return GLColorConf.Mabel.color
        }
    }
}
