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
    
    // 展开实际上是添加空白行, targetIndex为需要添加空白行的第一个cell序列号
    var targetIndex = 0
    var taskModel: TaskModel!
    
    var collectionView: UICollectionView!
    var calenderExpandIndicator = GLCalenderExpandIndicator()
    
    func makeCollectionView() {
        // 重用cell
        if collectionView == nil {
            let layout = UICollectionViewFlowLayout()
            
            self.collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
        
            addSubview(collectionView)
            
            
            collectionView.isScrollEnabled = false
            collectionView.register(GLCalenderDayCell.self, forCellWithReuseIdentifier: "GLCalenderDayCell")
            collectionView.register(GLTaskListCell.self, forCellWithReuseIdentifier: "GLTaskListCell")
            
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.reloadData()
            collectionView.backgroundColor = UIColor.white
            
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
                    
                    if let cell = self.collectionView.cellForItem(at: IndexPath(item: self.calenderExpandIndicator.selectedIndex, section: 0)) as? GLCalenderDayCell {
                        cell.backgroundColor = UIColor.white
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
        if self.calenderExpandIndicator.expanded {
            return 36
        }
        return 35
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 展开状态
        if calenderExpandIndicator.expanded {
            // 空白cell
            if calenderExpandIndicator.expandedIndex == indexPath.item {
                let taskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GLTaskListCell", for: indexPath) as! GLTaskListCell
                taskCell.loadData(model: "")
                return taskCell
            }
            var index = indexPath.item
            if self.calenderExpandIndicator.expandedIndex < index {
                index -= 1
            }
            let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GLCalenderDayCell", for: indexPath) as! GLCalenderDayCell
            dayCell.loadData(model: "")
            let cellDate = self.taskModel.date.dateFor(.startOfWeek).adjust(.day, offset: index)
            dayCell.dayLabel.text = cellDate.toString(format: .custom("dd"))
            // TODO 颜色调整
            return dayCell
        // 未展开状态
        } else {
            let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GLCalenderDayCell", for: indexPath) as! GLCalenderDayCell
            dayCell.layer.borderWidth = 0.3
            dayCell.layer.borderColor = UIColor.lightGray.cgColor
            dayCell.loadData(model: "")
            let cellDate = self.taskModel.date.dateFor(.startOfWeek).adjust(.day, offset: indexPath.item)
            //TODO CELL 颜色
            dayCell.dayLabel.text = cellDate.toString(format: .custom("dd"))
            return dayCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.calenderExpandIndicator.expanded && self.calenderExpandIndicator.expandedIndex == indexPath.item
        {
            return CGSize.init(width: self.bounds.width, height: self.bounds.height/3)
        }
        return CGSize.init(width: self.bounds.width/7, height: self.bounds.height/5)
    }
    
    // 选择事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO 点击后颜色变化
//        if let dayCell = self.collectionView.cellForItem(at: indexPath) as? GLCalenderDayCell {
//
//        }
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
}

