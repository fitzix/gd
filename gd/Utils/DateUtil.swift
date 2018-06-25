//
//  DateUtil.swift
//  gd
//
//  Created by fitz on 2018/6/25.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation

class GLDateUtil {
    class func timeFormat(format: String? = "YYYY-MM-dd") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }
}
