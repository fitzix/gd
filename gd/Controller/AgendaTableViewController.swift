//
//  AgendaTableViewController.swift
//  gd
//
//  Created by fitz on 2018/6/26.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import PKHUD
import CRRefresh

class AgendaTableViewController: UITableViewController {
    
    var agendaList: [[GLAgendaResp]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedSectionHeaderHeight = 44
        
        //创建一个重用的单元格
        self.tableView.register(UINib(nibName: "GLAgendaTableViewCell", bundle: nil), forCellReuseIdentifier: "GLAgendaTableViewCell")
        self.tableView.register(UINib(nibName: "GLAgendaTableSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "GLAgendaTableSectionHeader")
        // 移除空白格
        self.tableView.tableFooterView = UIView()
        
        /// animator: your customize animator, default is NormalHeaderAnimator
        let normalHeaderAnimator = NormalHeaderAnimator()
        let normalFooterAnimator = NormalFooterAnimator()
        normalHeaderAnimator.trigger = 130
        normalFooterAnimator.trigger = 40
        tableView.cr.addHeadRefresh(animator: normalHeaderAnimator) { [weak self] in
            GLAgendaDataUtil.shared.loadData(after: false) { succeed in
                self?.tableView.cr.endHeaderRefresh()
                if succeed {
                    self?.agendaList = GLAgendaDataUtil.shared.flatAgendaList()
                    self?.tableView.reloadData()
                }
            }
        }
        tableView.cr.beginHeaderRefresh()
        
        tableView.cr.addFootRefresh(animator: normalFooterAnimator) { [weak self] in
            GLAgendaDataUtil.shared.loadData { succeed in
                self?.tableView.cr.endLoadingMore()
                if succeed {
                    self?.agendaList = GLAgendaDataUtil.shared.flatAgendaList()
                    self?.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return agendaList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agendaList[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //用重用的方式获取标识cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GLAgendaTableViewCell", for: indexPath) as! GLAgendaTableViewCell
        let data = agendaList[indexPath.section]
        
        var isHeader = true
        if indexPath.row != 0, data[indexPath.row].beginDate == data[indexPath.row - 1].beginDate {
            isHeader = false
        }
        cell.reloadData(glAgendaResp: data[indexPath.row], indexPath: indexPath.row, isHeader: isHeader)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerDate = Date(fromString: agendaList[section][0].beginDate!, format: .isoDate)
        
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GLAgendaTableSectionHeader") as? GLAgendaTableSectionHeader
        cell?.labelHeaderBtn.tag = section
        cell?.labelHeaderBtn.addTarget(self, action: #selector(didSelectHeader(_:)), for: .touchUpInside)
        
        cell?.reloadData(headerDate: headerDate!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowData = agendaList[indexPath.section][indexPath.row]
        
        if rowData.id == nil { return }
    
        GLHttpUtil.shared.request(.getDetail, appendUrl: "/\(rowData.id!)") { [weak self] (resp: GLAgendaDetailResp?) in
            guard let resp = resp, let info = resp.info else {
                return
            }
            let detailVC = self?.storyboard?.instantiateViewController(withIdentifier: "AgendaDetailViewController") as! AgendaDetailViewController
            detailVC.glAgendaResp = info
            
            self?.navigationController?.pushViewController(detailVC, animated: true)
        
        }
    }
    
    // 点击月份
    @objc func didSelectHeader(_ sender: UIButton) {
        guard let headerDate = Date(fromString: agendaList[sender.tag][0].beginDate!, format: .isoDate) else {
            return
        }

        let monthVC = storyboard?.instantiateViewController(withIdentifier: "MonthViewController") as! MonthViewController
        monthVC.startDate = headerDate
        
        navigationController?.pushViewController(monthVC, animated: true)
    }
}

