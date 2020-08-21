//
//  FlipperView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

enum FlipperState {
    case began
    case active
    case inactive
}

protocol FlipperViewDataSource: AnyObject {
    func viewForPage(_ page: Int, flipper: FlipperView) -> UIView
}

final class FlipperView: UIView {
    
    var viewControllerSnapshots: [UIImage?] = []
    weak var dataSource: FlipperViewDataSource?
    
    lazy var staticView: FlipperStaticView = {
        let view = FlipperStaticView(frame: frame)
        return view
    }()
    
    var flipperState = FlipperState.inactive
    var activeView: UIView?
    var currentPage = 0
    var animatingLayers = [FlipperAnimationLayer]()

    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        
        NotificationCenter.default.addObserver(self,
                                 selector: #selector(clearAnimation),
                                 name: NSNotification.Name.NSExtensionHostWillResignActive,
                                 object: nil)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(NSNotification.Name.NSExtensionHostWillResignActive)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    @objc
    private func clearAnimation() {}
    
    @objc
    private func pan(_ gesture: UIGestureRecognizer) {}
    
}
