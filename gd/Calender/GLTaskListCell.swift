//
// Created by Fitz Leo on 2018/6/25.
// Copyright (c) 2018 Fitz Leo. All rights reserved.
//

import UIKit
class GLTaskListCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var tableData: [GLAgendaResp] = []
    var bottomLine: UIView!

    func loadData(model: [GLAgendaResp]?) {
        if tableView == nil {
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
            tableView.separatorColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.00)
            tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
            tableView.tableFooterView = UIView()
            addSubview(tableView)
        }
        
        if bottomLine == nil {
            
            bottomLine = UIView()
            
            bottomLine.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
            
            addSubview(bottomLine)
            
            bottomLine.snp.makeConstraints({ (constraintMaker) in
                constraintMaker.left.equalToSuperview()
                constraintMaker.right.equalToSuperview()
                constraintMaker.bottom.equalToSuperview()
                constraintMaker.height.equalTo(0.3)
            })
            
        }
        
        if let model = model {
            tableData = model
        } else {
            tableData = []
        }
        
        tableView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "tableCell")
        cell.textLabel?.text = "\(tableData[indexPath.row].beginTime?.prefix(5) ?? "") ~ \(tableData[indexPath.row].endTime?.prefix(5) ?? "")"
        cell.detailTextLabel?.text = tableData[indexPath.row].title
        cell.detailTextLabel?.textAlignment = .center
        cell.backgroundColor = UIColor.white.withAlphaComponent(0)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = tableData[safe: indexPath.row], let eventId = row.id else {
            return
        }
        GLAgendaDataUtil.shared.taskListDidSelect?(eventId, row.beginDate!, row.endDate!)
    }
}
