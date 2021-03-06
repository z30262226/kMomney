//
//  ReportViewController.swift
//  kMoney
//
//  Created by ohlulu on 2019/7/16.
//  Copyright © 2019 ohlulu. All rights reserved.
//

import UIKit

class ReportViewController: BaseViewController {

    // MARK: UI element

    // MARK: Private property

    // MARK: - Life cycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observerSequence()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Observer sequence

fileprivate extension ReportViewController {
    
    func observerSequence() {
        
    }
}

// MARK: - Setup UI methods

fileprivate extension ReportViewController {

    func setupUI() {
        navigationItem.title = "財報"
    }
}
