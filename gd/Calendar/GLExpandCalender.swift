//
//  ExpandCalender.swift
//  gd
//
//  Created by fitz on 2018/6/25.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import SnapKit
import DateHelper

class GLCalender: UIView {
    typealias GLCalenderMonthWillChane = (_ month: Date) -> Void
    
    var WillChangeMonth: GLCalenderMonthWillChane!
    // MARK:
    var startDate = Date()
    var endDate = Date()
    var monthCount:Int = 0
    var monthString = ""
    
    fileprivate var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, start: String = "2000-01-01", end: String = "2100-12-31", willChangeMonth: GLCalenderMonthWillChane? = nil) {
        self.init(frame: frame)
        if let monthBlock = willChangeMonth {
            self.WillChangeMonth = monthBlock
        }
        self.startDate = GLDateUtil.timeFormat().date(from: start)!
        self.endDate = GLDateUtil.timeFormat().date(from: end)!
        self.monthCount = Int(endDate.since(startDate, in: .month))
        makeCollectionView(bounds: self.frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeCollectionView(bounds: CGRect) {
        let layout = UICollectionViewFlowLayout()
        
        self.collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        addSubview(collectionView)
        
        collectionView.register(GLCalenderMonthCell.self, forCellWithReuseIdentifier: "GLCalenderMonthCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.white
        
        collectionView.snp.makeConstraints { ConstraintMaker in
            ConstraintMaker.top.equalToSuperview()
            ConstraintMaker.bottom.equalToSuperview()
            ConstraintMaker.left.equalToSuperview()
            ConstraintMaker.right.equalToSuperview()
        }
        orientationCurrentDate()
    }
    
    func orientationCurrentDate() {
        let index = Int(Date().since(self.startDate, in: .month)) - 1
        let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: index, section: 0))?.frame
        collectionView.contentOffset = (rect?.origin)!
        self.WillChangeMonth(startDate.adjust(.month, offset: index))
    }
}

extension GLCalender: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GLCalenderMonthCell", for: indexPath) as! GLCalenderMonthCell
        cell.makeCollectionView()
        let taskModel = TaskModel()
        taskModel.date = self.startDate.adjust(.month, offset: indexPath.item)
        cell.loadData(withModel: taskModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.height)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(collectionView.indexPathsForVisibleItems)
        let index = collectionView.indexPathsForVisibleItems.last?.item
        WillChangeMonth(startDate.adjust(.month, offset: index!))
    }
}















