//
//  BaseNavigationController.swift
//  kMoney
//
//  Created by ohlulu on 2019/4/14.
//  Copyright © 2019 ohlulu. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    private lazy var transitionAnimation = DiffusionTransition()

    init(rootVC: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = [rootVC]
    }
    
    init(rootVC: UIViewController, diffusionPoint: CGPoint? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = [rootVC]
        if let diffusionPoint = diffusionPoint {
            transitionAnimation.targetPoint = diffusionPoint
            transitionAnimation.interaction.wireGesture(on: self)
            transitioningDelegate = transitionAnimation
            modalPresentationStyle = .custom
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension BaseNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count <= 1 {
            return false
        } else {
            return true
        }
    }
}

// MARK: Setup UI methods

fileprivate extension BaseNavigationController {
    
    func setupUI() {
        interactivePopGestureRecognizer?.delegate = self
        
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: KMFont.text(.medium, 16).rawValue
        ]
        
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}