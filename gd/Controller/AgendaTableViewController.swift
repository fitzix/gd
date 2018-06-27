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
    
//  ============================================================
    func setup() {
        let req = GLHttpUtil.shared.request(.getAgendaList, parameters: ["viewType": 3, "date": "2018-06-01"])
        req.responseObject { [weak self] (response: DataResponse<GLAgendaListResp>) in
            guard let result = response.result.value, result.ok else {
                print("出错了")
                return
            }
            self?.agendaTableList = self?.flatAgendaList(dataList: result.info!)
            self?.tableView.reloadData()
        }
    }
    
    func flatAgendaList(dataList: [GLAgendaResp]) -> [[GLAgendaResp]] {
//        let dayKeys = Array(Set(dataList.compactMap { $0.beginDate })).sorted(by: <)
        let monthKeys = Array(Set(dataList.compactMap{ $0.beginDate?.prefix(7) })).sorted(by: <)
        var result = [[GLAgendaResp]]()
        
        monthKeys.forEach {
            let tempKey = $0
            let tempList = dataList.filter{ $0.beginDate?.prefix(7) == tempKey }
            result.append(tempList)
        }
        return result
    }
    
    @objc func didSelectHeader(_ sender: UIButton) {
        print(sender.tag)
        let tvc = self.storyboard?.instantiateViewController(withIdentifier: "AgendaDetailViewController")
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(tvc!, animated: true)
        hidesBottomBarWhenPushed = false
//        present(tvc!, animated: true, completion: nil)
    }
    @IBAction func tttttt(_ sender: UIBarButtonItem) {
        let tvc = self.storyboard?.instantiateViewController(withIdentifier: "AgendaDetailViewController") as! AgendaDetailViewController
        present(tvc, animated: true, completion: nil)
        
    }
}
