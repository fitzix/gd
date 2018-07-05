//
// Created by Fitz Leo on 2018/6/25.
// Copyright (c) 2018 Fitz Leo. All rights reserved.
//

import UIKit
class GLTaskListCell: UICollectionViewCell {
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.groupTableViewBackground.withAlphaComponent(0.7)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(model: String) {
        
    }
}
