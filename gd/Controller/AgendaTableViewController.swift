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
    
    var agendaTableList: [[GLAgendaResp]]?
    

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
            self?.loadData {
                self?.tableView.cr.endHeaderRefresh()
            }
        }
        tableView.cr.beginHeaderRefresh()
        
        /// animator: 你的下拉加载的Animator, 默认是NormalFootAnimator
        tableView.cr.addFootRefresh(animator: normalFooterAnimator) { [weak self] in
            self?.loadData(down: false, completion: {
                self?.tableView.cr.endLoadingMore()
            })
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let counts = agendaTableList?.count else {
            return 0
        }
        return counts
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let counts = agendaTableList?[section].count else {
            return 0
        }
        return counts
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //用重用的方式获取标识为wifiCell的cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GLAgendaTableViewCell", for: indexPath) as! GLAgendaTableViewCell
        
        var isHeader = true
        if indexPath.row != 0, let agendaArray = agendaTableList?[indexPath.section], let current = agendaArray[indexPath.row].beginDate, let pre = agendaArray[indexPath.row - 1].beginDate, current == pre  {
            isHeader = false
        }
        
        cell.reloadData(glAgendaResp: agendaTableList![indexPath.section][indexPath.row], indexPath: indexPath.row, isHeader: isHeader)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let beginDate = agendaTableList?[section][0].beginDate, let headerDate = Date(fromString: beginDate, format: .isoDate) else {
            return nil
        }
        
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GLAgendaTableSectionHeader") as? GLAgendaTableSectionHeader
        cell?.labelHeaderBtn.tag = section
        cell?.labelHeaderBtn.addTarget(self, action: #selector(didSelectHeader(_:)), for: .touchUpInside)
        
        cell?.reloadData(headerDate: headerDate)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let rowData = agendaTableList?[indexPath.section][indexPath.row] else {
            return
        }
    
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

        guard let beginDate = agendaTableList?[sender.tag][0].beginDate, let headerDate = Date(fromString: beginDate, format: .isoDate) else {
            return
        }
        
        let monthVC = storyboard?.instantiateViewController(withIdentifier: "MonthViewController") as! MonthViewController
        monthVC.startDate = headerDate
        
        navigationController?.pushViewController(monthVC, animated: true)
        
    }
    
    // 下拉down 上拉up
    func loadData(down: Bool = true, completion: @escaping () -> Void?) {
        var topDateStr = Date().toString(format: .isoDate)
        var viewType = 4
        
        if agendaTableList != nil {
            viewType = 5
            if down {
               topDateStr = Date(fromString: agendaTableList!.first!.first!.beginDate!, format: .isoDate)!.adjust(.year, offset: -1).toString(format: .isoDate)
            } else {
               topDateStr = Date(fromString: agendaTableList!.last!.last!.beginDate!, format: .isoDate)!.adjust(.month, offset: 1).toString(format: .isoDate)
            }
        }
        GLHttpUtil.shared.request(.getAgendaList, parameters: ["viewType": viewType, "date": topDateStr]) { [weak self] (resp: GLAgendaListResp?) in
            guard let resp = resp, let info = resp.info else {
                HUD.flash(.labeledError(title: "请求数据失败", subtitle: nil), delay: 1)
                completion()
                return
            }
            let result = GLHttpUtil.flatAgendaList(dataList: info)
            if result.count > 0 {
                if self?.agendaTableList != nil {
                    if down {
                        self?.agendaTableList?.insert(contentsOf: result, at: 0)
                    } else {
                        self?.agendaTableList?.append(contentsOf: result)
                    }
                } else {
                    self?.agendaTableList = result
                }
                self?.tableView.reloadData()
               
            } else {
                if !down {
                    self?.tableView.cr.noticeNoMoreData()
                }
            }
             completion()
        }
    }
}

