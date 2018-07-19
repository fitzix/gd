//
//  GLModel.swift
//  gd
//
//  Created by fitz on 2018/7/19.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation

struct GLUserModel: Equatable {
    var name: String?
    var iconURL: String?
}

func ==(lhs: GLUserModel, rhs: GLUserModel) -> Bool {
    return lhs.name == rhs.name
}
