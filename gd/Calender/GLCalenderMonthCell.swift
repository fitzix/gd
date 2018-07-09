//
//  GLCalenderMonthCell.swift
//  gd
//
//  Created by fitz on 2018/6/25.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

struct GLCalenderExpandIndicator {
    
    var expanded = false
    // 已展开空白行第一个cell序列号
    var expandedIndex = -1
    // 选中的cell系列号
    var selectedIndex = -1
    
    
}

class GLCalenderMonthCell: UICollectionViewCell {
    var numberOfRow: Int {
        get {
            let allCell = self.taskModel.date.numberOfDaysInMonth() + self.taskModel.date.dateFor(.startOfMonth).component(.weekday)! - 1
            var temp = 5
            if allCell/7 == 5 && allCell%7 != 0 {
                temp = 6
            }
            return temp
        }
    }
    
    // 展开实际上是添加空白行, targetIndex为需要添加空白行的第一个cell序列号
    var targetIndex = 0
    var taskModel: TaskModel!
    
    var collectionView: UICollectionView!
    var calenderExpandIndicator = GLCalenderExpandIndicator()
    
    func makeCollectionView() {
        // 重用cell
        if collectionView == nil {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            
            self.collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
           
            addSubview(collectionView)
            
            
            collectionView.isScrollEnabled = false
            collectionView.register(GLCalenderDayCell.self, forCellWithReuseIdentifier: "GLCalenderDayCell")
            collectionView.register(GLTaskListCell.self, forCellWithReuseIdentifier: "GLTaskListCell")
            
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.reloadData()
            
            collectionView.isPagingEnabled = true
            
            collectionView.snp.makeConstraints { ConstraintMaker in
                ConstraintMaker.top.equalToSuperview()
                ConstraintMaker.bottom.equalToSuperview()
                ConstraintMaker.left.equalToSuperview()
                ConstraintMaker.right.equalToSuperview()
            }
        }
    }
    
    // TODO 加载数据
    func loadData(withModel model: TaskModel) {
        self.taskModel = model
        collectionView.reloadData()
        self.calenderExpandIndicator = GLCalenderExpandIndicator()
    }
    
    
    func expandAction(indexPath: IndexPath) {
        switch indexPath.item {
        case ..<7:
            targetIndex = 7
        case ..<14:
            targetIndex = 14
        case ..<21:
            targetIndex = 21
        case ..<28:
            targetIndex = 28
        case ..<35:
            targetIndex = 35
        default:
            targetIndex = 0
        }
        // 展开状态
        if self.calenderExpandIndicator.expanded {
            // 同一行切换, 空白行不用再次展开
            if self.calenderExpandIndicator.expandedIndex == self.targetIndex {
                // 判断是否是点击已展开cell
                if indexPath.item == self.calenderExpandIndicator.selectedIndex {
                    // 关闭删除空白行
                    self.calenderExpandIndicator.selectedIndex = -1
                    self.calenderExpandIndicator.expanded = false
                    self.calenderExpandIndicator.expandedIndex = -1
                    self.collectionView.performBatchUpdates({ [weak self] in
                        guard let `self` = self else {
                            return
                        }
                        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
                        self.collectionView.deleteItems(at: [IndexPath(item: targetIndex, section: 0)])
                        }, completion: { [weak self] _ in
                            guard let `self` = self else {
                                return
                            }
                            self.collectionView.reloadData()
                    })
                // 点击同一行其他cell
                } else {
                    self.collectionView.reloadData()
                    self.calenderExpandIndicator.selectedIndex = indexPath.item
                }
            // 已展开状态 但点击了其它行
            } else {
                self.collectionView.performBatchUpdates({ [weak self] in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.calenderExpandIndicator.selectedIndex = -1
                    self.calenderExpandIndicator.expanded = false
                    let needCloseIndex = self.calenderExpandIndicator.expandedIndex
                    self.calenderExpandIndicator.expandedIndex = -1
                    
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
                    self.collectionView.deleteItems(at: [IndexPath(item: needCloseIndex, section: 0)])
                }, completion: { [weak self] _ in
                    guard let `self` = self else {
                        return
                    }
                    self.expandAction(indexPath: indexPath)
                })
            }
        // 未展开状态
        } else {
            self.calenderExpandIndicator.selectedIndex = indexPath.item
            self.calenderExpandIndicator.expanded = true
            self.calenderExpandIndicator.expandedIndex = targetIndex
            self.collectionView.performBatchUpdates({ [weak self] in
                guard let `self` = self else { return }
                self.collectionView.insertItems(at: [IndexPath(item: targetIndex, section: 0)])
            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: self.targetIndex, section: 0), at: UICollectionViewScrollPosition.centeredVertically, animated: true)
            })
        }
    }
}

extension GLCalenderMonthCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let allCell = self.taskModel.date.numberOfDaysInMonth() + self.taskModel.date.dateFor(.startOfMonth).component(.weekday)! - 1
        var numberOfRow = 5
        if allCell/7 == 5 && allCell%7 != 0 {
            numberOfRow = 6
        }
        
        if self.calenderExpandIndicator.expanded {
            return 7 * numberOfRow + 1
        }
        return 7 * numberOfRow
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 展开状态
        if calenderExpandIndicator.expanded {
            // 空白cell
            if calenderExpandIndicator.expandedIndex == indexPath.item {
                let cellDate = self.taskModel.date.dateFor(.startOfWeek).adjust(.day, offset: calenderExpandIndicator.selectedIndex)
                let taskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GLTaskListCell", for: indexPath) as! GLTaskListCell
                taskCell.loadData(model: GLAgendaDataUtil.shared.agendaMap[cellDate.toString(format: .isoDate)])
                return taskCell
            }
            var index = indexPath.item
            if self.calenderExpandIndicator.expandedIndex < index {
                index -= 1
            }
            
            let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GLCalenderDayCell", for: indexPath) as! GLCalenderDayCell
            
            
            if calenderExpandIndicator.selectedIndex == indexPath.item {
                dayCell.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
            } else {
                dayCell.backgroundColor = nil
            }
            
            let cellDate = self.taskModel.date.dateFor(.startOfWeek).adjust(.day, offset: index)
            dayCell.loadData(model: GLAgendaDataUtil.shared.agendaMap[cellDate.toString(format: .isoDate)])
            
            if !cellDate.compare(.isSameMonth(as: taskModel.date)) {
                dayCell.isHidden = true
                return dayCell
            }
            
            dayCell.isHidden = false
            dayCell.dayLabel.text = cellDate.toString(format: .custom("dd"))
            dayCell.lunarLabel.text = EventKitUtil.shared.getHolidayTitle(date: cellDate)
            return dayCell
        // 未展开状态
        } else {
            let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GLCalenderDayCell", for: indexPath) as! GLCalenderDayCell
            dayCell.backgroundColor = nil
            
            dayCell.borderWidth = 0.28
            dayCell.borderColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
            
            let cellDate = self.taskModel.date.dateFor(.startOfWeek).adjust(.day, offset: indexPath.item)
            dayCell.loadData(model: GLAgendaDataUtil.shared.agendaMap[cellDate.toString(format: .isoDate)])
            
            if !cellDate.compare(.isSameMonth(as: taskModel.date)) {
                dayCell.isHidden = true
                return dayCell
            }
            dayCell.isHidden = false
            dayCell.dayLabel.text = cellDate.toString(format: .custom("dd"))
            dayCell.lunarLabel.text = EventKitUtil.shared.getHolidayTitle(date: cellDate)
            return dayCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.calenderExpandIndicator.expanded && self.calenderExpandIndicator.expandedIndex == indexPath.item
        {
            return CGSize.init(width: self.bounds.width, height: self.bounds.height/2)
        }
        return CGSize.init(width: self.bounds.width/7, height: self.bounds.height/CGFloat(numberOfRow))
    }
    
    // 选择事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if calenderExpandIndicator.expanded {
            if calenderExpandIndicator.expandedIndex == indexPath.item { return }
            var index = indexPath.item
            if calenderExpandIndicator.expandedIndex < index {
                index -= 1
            }
            self.expandAction(indexPath: IndexPath(item: index, section: 0))
        } else {
            self.expandAction(indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

