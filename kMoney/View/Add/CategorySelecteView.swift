//
//  CategorySelecteView.swift
//  kMoney
//
//  Created by ohlulu on 2019/8/25.
//  Copyright © 2019 ohlulu. All rights reserved.
//

import UIKit
import RealmSwift

/*
 Layout
 */
private final class CategorySelectorLayout: UICollectionViewFlowLayout {
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }
        let numberOfPage = Int(ceil(collectionView.numberOfItems(inSection: 0).double / 10))
        
        let width = (UIScreen.widthf * numberOfPage.cgfloat)
            + collectionView.contentInset.horizontal
        
        let height = 124.cgfloat + 32

        return CGSize(width: width, height: height)
    }
    
    private lazy var _itemSize: CGSize = {
        guard let cv = collectionView else { return .zero }
        let width = Int((UIScreen.widthf - mockInset) / 5)
        return .init(width: width, height: 60)
    }()
    
    private lazy var margin: CGFloat = {
        guard let cv = collectionView else { return .zero }
        return (UIScreen.widthf - (_itemSize.width * 5) - 40) / 2
    }()
    
    private let mockInset = 40.cgfloat
    
    private var cach: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let indexPaths = indexPathsForElementsInRect(rect)
        let layoutAttributes = indexPaths
            .map {
                self.layoutAttributesForItem(at: $0)
        }
        .filter { $0 != nil }
        .map { $0! }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let cachAttributes = cach[indexPath] {
            return cachAttributes
        }

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let xOffset: CGFloat = ((_itemSize.width) * (indexPath.item % 5).cgfloat)
            + Int(indexPath.item.cgfloat / 10).cgfloat
            * UIScreen.widthf + mockInset / 2
            + margin
        
        let yOffset: CGFloat = (indexPath.item % 10 < 5 ? 0 : _itemSize.height + 16) + 16
        
        let point = CGPoint(x: xOffset, y: yOffset)
        
        let frame = CGRect(origin: point, size: _itemSize)

        attributes.frame = frame
        
        cach[indexPath] = attributes
        
        return attributes
    }
    
    fileprivate func indexPathsForElementsInRect(_ rect: CGRect) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        
        if let numItems = collectionView?.numberOfItems(inSection: 0), numItems > 0 {
            indexPaths.reserveCapacity(numItems)
            for i in 0..<numItems {
                indexPaths.append(IndexPath(item: i, section: 0))
            }
        }
        
        return indexPaths
    }
}

/**
 Collection View
 */
private final class CategorySelecteCollectionView: UICollectionView {
    
    override var intrinsicContentSize: CGSize {
        return flowLayout.collectionViewContentSize
    }
    
    let flowLayout = CategorySelectorLayout()
    
    private var datas: Results<Category>
    
    init(datas: Results<Category>) {
        self.datas = datas
        

        super.init(frame: .zero,
                   collectionViewLayout: flowLayout)
        
        oh.register(CategorySelecteCell.self)
            .dataSource(self)
            .delegate(self)
            .backgroundColor(.clear)
            .showsVerticalIndicator(false)
            .showsHorizontalIndicator(false)
            .isPagingEnabled(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UICollectionViewDelegate

extension CategorySelecteCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension CategorySelecteCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategorySelecteCell = collectionView.dequeueReuseableCell(indexPath: indexPath)
        let currentData = datas[indexPath.row]
        cell.configCell(currentData)
        return cell
    }
}

final class CategorySelectorView: UIView {
    
    var datas = Category.getAll()
    
    override var intrinsicContentSize: CGSize {
        let height = collectionView.intrinsicContentSize.height + 32
        return .init(width: collectionView.intrinsicContentSize.width, height: height)
    }
    
    private lazy var collectionView = CategorySelecteCollectionView(datas: datas)
    
    private lazy var pageControl = UIPageControl().oh
        .numberOfPages(Int(ceil(datas.count.double / 10.0)))
        .pageIndicatorTintColor(.blueGrey)
        .currentPageIndicatorTintColor(.cornflower)
        .done()
    
    private let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        collectionView.rx.didScroll
            .map { [unowned self] in
                Int(self.collectionView.contentOffset.x / UIScreen.widthf)
            }
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: bag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension CategorySelectorView {
    
    func setupUI() {
        // category selector view
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
//            make.bottom.equalToSuperview().offset(4)
        }
    }
}
