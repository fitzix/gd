//
//  GLUserInfoRowCell.swift
//  gd
//
//  Created by fitz on 2018/7/19.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import Eureka

class GLUserInfoCell: Cell<GLUserModel>, CellType {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func setup() {
        height = {70}
        super.setup()
    }
    
    override func update() {
        super.update()
        guard let values = row.value else { return }
        
        userNameLabel.text = values.name
        if let urlStr = values.iconURL, let url = URL(string: urlStr), let data = try? Data(contentsOf: url) {
            userImageView.image = UIImage(data: data)
        } else {
            userImageView.image = UIImage(named: "placeholder")
        }
    }
}


final class GLUserInfoRow: Row<GLUserInfoCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<GLUserInfoCell>(nibName: "GLUserInfoCell")
    }
}
