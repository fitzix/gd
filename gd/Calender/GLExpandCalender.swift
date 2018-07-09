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
    
    let startDate = Date(fromString: GLConfig.CAL_START_DATE, format: .isoDate)!
    
    fileprivate var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, willChangeMonth: GLCalenderMonthWillChane? = nil) {
        self.init(frame: frame)
        if let monthBlock = willChangeMonth {
            self.WillChangeMonth = monthBlock
        }

        makeCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeCollectionView() {
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
    }
    
    func orientationCurrentDate(start: Date) {
        
        let index = Int(start.since(self.startDate, in: .month)) - 1
        let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: index, section: 0))?.frame
        
        collectionView.contentOffset = (rect?.origin)!
        self.WillChangeMonth(startDate.adjust(.month, offset: index))
    }
}

extension GLCalender: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let endDate = Date().adjust(.year, offset: GLConfig.CAL_END_DATE_AFTER_NOW_YEAR)
        return Int(endDate.since(startDate, in: .month))
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
        let index = collectionView.indexPathsForVisibleItems.last?.item
        WillChangeMonth(startDate.adjust(.month, offset: index!))
    }
}















