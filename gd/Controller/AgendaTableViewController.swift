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

class AgendaTableViewController: UITableViewController {
    
    var agendaTableList: [[GLAgendaResp]]?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedSectionHeaderHeight = 40
        
        //创建一个重用的单元格
        self.tableView.register(UINib(nibName: "GLAgendaTableViewCell", bundle: nil), forCellReuseIdentifier: "GLAgendaTableViewCell")
        self.tableView.register(UINib(nibName: "GLAgendaTableSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "GLAgendaTableSectionHeader")
        
        self.tableView.tableFooterView = UIView()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell?.tag = section
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
            print(info.toJSON())
            detailVC.glAgendaResp = info
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
//  ============================================================
    func setup() {
        GLHttpUtil.shared.request(.getAgendaList, parameters: ["viewType": 3, "date": Date().toString(format: .isoDate)]) { [weak self] (resp: GLAgendaListResp?) in
            guard let resp = resp, let info = resp.info else {
                return
            }
            self?.agendaTableList = GLHttpUtil.flatAgendaList(dataList: info)
            self?.tableView.reloadData()
        }
    }
    
    @objc func didSelectHeader(_ sender: UIButton) {
        print(sender.tag)
    }
}
