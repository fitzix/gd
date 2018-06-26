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
    
    var agendaTableList: [GLAgendaResp]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.tableFooterView = UIView()
        
        //创建一个重用的单元格
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "wifiCell")
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let counts = agendaTableList?.count else {
            return 0
        }
        return counts
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //用重用的方式获取标识为wifiCell的cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "wifiCell", for: indexPath)
        cell.textLabel?.text = "2222222"
        return cell
    }
  

    func setup() {
        let req = GLHttpUtil.shared.request(.getAgendaList, parameters: ["viewType": 3, "date": Date().toString(format: .isoDate)])
        req.responseObject { [weak self] (response: DataResponse<GLAgendaListResp>) in
            guard let result = response.result.value, result.ok else {
                print("出错了")
                return
            }
            
            self?.agendaTableList = result.info
            self?.tableView.reloadData()
        }
    }
}
