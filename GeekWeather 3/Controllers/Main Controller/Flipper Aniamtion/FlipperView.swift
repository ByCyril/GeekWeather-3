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
    
    lazy var flipperStaticView: FlipperStaticView = {
        let view = FlipperStaticView(frame: frame)
        return view
    }()
    
    var flipperState = FlipperState.inactive
    var activeView: UIView?
    var currentPage = 0
    var animatingLayers = [FlipperAnimationLayer]()
    
    let numberOfPages = 3
    
    init() {
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
        flipperStaticView.updateFrame(frame)
    }
    
    func updateTheActiveView() {
        
        guard let dataSource = self.dataSource else { return }
        
        if let activeView = self.activeView {
            if activeView.isDescendant(of: self) {
                activeView.removeFromSuperview()
            }
        }
        
        activeView = dataSource.viewForPage(currentPage, flipper: self)
        addSubview(activeView!)
        
        //set up the constraints
        activeView?.translatesAutoresizingMaskIntoConstraints = false
        let viewDictionary = ["activeView":self.activeView!]
        
        let constraintTop = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[activeView]-0-|",
                                                           options: .alignAllTop,
                                                           metrics: nil,
                                                           views: viewDictionary)
        let constraintLeft = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[activeView]-0-|",
                                                            options: .alignAllLeft,
                                                            metrics: nil,
                                                            views: viewDictionary)
        
        addConstraints(constraintTop)
        addConstraints(constraintLeft)
        
    }
    
    @objc
    private func clearAnimation() {
        guard flipperState != .inactive else { return }
        
        //remove all animation layers and update the static view
        updateTheActiveView()
        
        for animation in animatingLayers {
            animation.flipAnimationStatus = .fail
            animation.removeFromSuperlayer()
        }
        animatingLayers.removeAll(keepingCapacity: false)
        
        flipperStaticView.removeFromSuperlayer()
        CATransaction.flush()
        flipperStaticView.leftSide.contents = nil
        flipperStaticView.rightSide.contents = nil
        
        flipperState = .inactive
    }
    
    @objc
    private func pan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view!).x
        let progress = translation / gesture.view!.bounds.size.width
        
        switch gesture.state {
        case .began:
            panBegan(gesture)
        case .changed:
            panChanged(gesture, translation, progress)
        case .ended:
            panEnded(gesture, translation)
        case .cancelled:
            enableGesture(gesture, false)
        default:
            break
        }
        
    }
    
    func panBegan(_ gesture: UIPanGestureRecognizer) {
        if animationsArePassedHalfway() {
            if flipperState == .inactive {
                flipperState = .began
            }
            
            let animationLayer = FlipperAnimationLayer(frame: flipperStaticView.rightSide.bounds, isFirstOrLast: false)
            
            if let hiZanimLayer = getHighestZIndexFlipperAnimationLayer() {
                animationLayer.zPosition = hiZanimLayer.zPosition + animationLayer.bounds.size.height
            } else {
                animationLayer.zPosition = 0
            }
            
            animatingLayers.append(animationLayer)
        } else {
            enableGesture(gesture, false)
        }
    }
    
    func panChanged(_ gesture: UIPanGestureRecognizer,_ translation: CGFloat,_ progress: CGFloat) {
        
        guard let currentFlipperAnimationLayer = animatingLayers.first else { return }
        
        switch currentFlipperAnimationLayer.flipAnimationStatus {
        case .beginning:
            animationStatusBeginning(currentFlipperAnimationLayer,
                                     translation: translation,
                                     progress: progress,
                                     gesture: gesture)
        case .active:
            animationStatusActive(currentFlipperAnimationLayer,
                                  translation: translation,
                                  progress: progress)
        case .completing:
            enableGesture(gesture, false)
            animationStatusCompleting(currentFlipperAnimationLayer)
        default:
            break
        }
        
    }
    
    func panEnded(_ gesture: UIPanGestureRecognizer,_ translation: CGFloat) {
        
        guard let currentFlipperAnimationLayer = animatingLayers.last else { return }
        
        currentFlipperAnimationLayer.flipAnimationStatus = .completing
        
        if didFlipToNewPage(currentFlipperAnimationLayer, gesture, translation) == true {
            setUpForFlip(currentFlipperAnimationLayer, progress: 1.0, animated: true, clearFlip: true)
        } else {
            if currentFlipperAnimationLayer.isFirstOrLastPage == false {
                handleDidNotFlipToNewPage(currentFlipperAnimationLayer)
            }
            setUpForFlip(currentFlipperAnimationLayer, progress: 0.0, animated: true, clearFlip: true)
        }
        
    }
    
    func didFlipToNewPage(_ animationLayer: FlipperAnimationLayer,_ gesture: UIPanGestureRecognizer, _ translation: CGFloat) -> Bool {
        
        let releaseSpeed = getReleaseSpeed(translation, gesture: gesture)
        
        var didFlipToNewPage = false
        if animationLayer.flipDirection == .top && abs(releaseSpeed) > 0.5 && !animationLayer.isFirstOrLastPage && releaseSpeed < 0 ||
        animationLayer.flipDirection == .bottom && abs(releaseSpeed) > 0.5 && !animationLayer.isFirstOrLastPage && releaseSpeed > 0 {
                didFlipToNewPage = true
        }
        return didFlipToNewPage
    }
    
    func handleDidNotFlipToNewPage(_ animationLayer: FlipperAnimationLayer) {
        if animationLayer.flipDirection == .top {
            animationLayer.flipDirection = .bottom
            currentPage -= 1
        } else {
            animationLayer.flipDirection = .top
            currentPage += 1
        }
    }
    
    func animationStatusBeginning(_ currentDJKAnimationLayer:FlipperAnimationLayer, translation:CGFloat, progress:CGFloat, gesture:UIPanGestureRecognizer) {
        
        if currentDJKAnimationLayer.flipAnimationStatus == .beginning {
            
            flipperState = .active
            
            //set currentDJKAnimationLayers direction
            currentDJKAnimationLayer.updateFlipDirection(getFlipDirection(translation))
            
            if handleConflictingAnimationsWithDJKAnimationLayer(currentDJKAnimationLayer) == false {
                //check if swipe is fast enough to be considered a complete page swipe
                if isIncrementalSwipe(gesture, animationLayer: currentDJKAnimationLayer) {
                    currentDJKAnimationLayer.flipAnimationStatus = .active
                } else {
                    currentDJKAnimationLayer.flipAnimationStatus = .completing
                }
                
                updateViewControllerSnapShotsWithCurrentPage(self.currentPage)
                setUpDJKAnimationLayerFrontAndBack(currentDJKAnimationLayer)
                setUpStaticLayerForTheDJKAnimationLayer(currentDJKAnimationLayer)
                
                self.layer.addSublayer(currentDJKAnimationLayer)
                //you need to perform a flush otherwise the animation duration is not honored.
                //more information can be found here http://stackoverflow.com/questions/8661355/implicit-animation-fade-in-is-not-working#comment10764056_8661741
                CATransaction.flush()
                
                //add the animation layer to the view
                addDJKAnimationLayer()
                
                if currentDJKAnimationLayer.flipAnimationStatus == .active {
                    animationStatusActive(currentDJKAnimationLayer, translation: translation, progress: progress)
                }
            } else {
                enableGesture(gesture, false)
            }
        }
    }
    
    func animationsArePassedHalfway() -> Bool{
        var passedHalfWay = false
        
        if flipperState == FlipperState.inactive {
            passedHalfWay = true
        } else if animatingLayers.count > 0 {
            //LOOP through this and check the new animation layer with current animations to make sure we dont allow the same animation to happen on a flip up
            for animLayer in animatingLayers {
                let animationLayer = animLayer as FlipperAnimationLayer
                var layerIsPassedHalfway = false
                
                let rotationX = animationLayer.presentation()?.value(forKeyPath: "transform.rotation.x") as! CGFloat
                
                if animationLayer.flipDirection == .bottom && rotationX > 0 {
                    layerIsPassedHalfway = true
                } else if animationLayer.flipDirection == .top && rotationX == 0 {
                    layerIsPassedHalfway = true
                }
                
                if layerIsPassedHalfway == false {
                    passedHalfWay = false
                    break
                } else {
                    passedHalfWay = true
                }
            }
        } else {
            passedHalfWay = true
        }
        
        return passedHalfWay
    }
    
    func handleConflictingAnimationsWithDJKAnimationLayer(_ animationLayer:FlipperAnimationLayer) -> Bool {
        
        var animationConflict = false
        guard animatingLayers.count > 1 else { return animationConflict }
                
        guard let oppositeAnimationLayer = getHighestZIndexFlipperAnimationLayer() else { return animationConflict }
        
        if !oppositeAnimationLayer.isFirstOrLastPage {
            animationConflict = false
            
        }
        
        removeDJKAnimationLayer(animationLayer)
        reverseAnimationForLayer(oppositeAnimationLayer)
        
        return animationConflict
    }
    
    func getHighestDJKAnimationLayerFromDirection(_ flipDirection: FlipDirection) -> FlipperAnimationLayer? {
        
        var animationsInSameDirection = [FlipperAnimationLayer]()
        
        for animLayer in animatingLayers {
            if animLayer.flipDirection == flipDirection {
                animationsInSameDirection.append(animLayer)
            }
        }

        return animationsInSameDirection.sorted(by: {$0.zPosition > $1.zPosition}).first
    }
    
    func removeDJKAnimationLayer(_ animationLayer:FlipperAnimationLayer) {
        animationLayer.flipAnimationStatus = .fail
        
        var zPos = animationLayer.bounds.size.height
        
        if let highestZPosAnimLayer = getHighestZIndexFlipperAnimationLayer() {
            zPos = zPos + highestZPosAnimLayer.zPosition
        } else {
            zPos = 0
        }
        
        animatingLayers.remove(object: animationLayer)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        animationLayer.zPosition = zPos
        CATransaction.commit()
    }
    
    func reverseAnimationForLayer(_ animationLayer: FlipperAnimationLayer) {
        animationLayer.flipAnimationStatus = .interrupt
        
        if animationLayer.flipDirection == .top {
            currentPage = currentPage - 1
            animationLayer.updateFlipDirection(.bottom)
            setUpForFlip(animationLayer, progress: 1.0, animated: true, clearFlip: true)
        } else if animationLayer.flipDirection == .bottom {
            currentPage = currentPage + 1
            animationLayer.updateFlipDirection(.top)
            setUpForFlip(animationLayer, progress: 1.0, animated: true, clearFlip: true)
        }
    }
    
    func setUpForFlip(_ animationLayer: FlipperAnimationLayer, progress:CGFloat, animated:Bool, clearFlip:Bool) {
        
        let newAngle:CGFloat = animationLayer.flipProperties.startAngle + progress * (animationLayer.flipProperties.endFlipAngle - animationLayer.flipProperties.startAngle)
        
        var duration:CGFloat
        
        if animated == true {
            duration = getAnimationDurationFromDJKAnimationLayer(animationLayer, newAngle: newAngle)
        } else {
            duration = 0
        }
        
        animationLayer.flipProperties.currentAngle = newAngle
        
        if animationLayer.isFirstOrLastPage == true {
            setMaxAngleIfDJKAnimationLayerIsFirstOrLast(animationLayer, newAngle: newAngle)
        }
        
        performFlipWithDJKAnimationLayer(animationLayer, duration: duration, clearFlip: clearFlip)
    }
    
    func performFlipWithDJKAnimationLayer(_ animationLayer: FlipperAnimationLayer, duration:CGFloat, clearFlip:Bool) {
        var t = CATransform3DIdentity
        t.m34 = 1.0/850
        t = CATransform3DRotate(t, animationLayer.flipProperties.currentAngle, 0, 1, 0)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(CFTimeInterval(duration))
        
        //if the flip animationLayer should be cleared after its animation is completed
        if clearFlip {
            clearFlipAfterCompletion(animationLayer)
        }
        
        animationLayer.transform = t
        CATransaction.commit()
    }
    
    func setMaxAngleIfDJKAnimationLayerIsFirstOrLast(_ animationLayer: FlipperAnimationLayer, newAngle:CGFloat) {
        if animationLayer.flipDirection == .bottom {
            if newAngle < -1.4 {
                animationLayer.flipProperties.currentAngle = -1.4
            }
        } else {
            if newAngle > -1.8 {
                animationLayer.flipProperties.currentAngle = -1.8
            }
        }
    }
    
    func clearFlipAfterCompletion(_ animationLayer: FlipperAnimationLayer) {
        CATransaction.setCompletionBlock { () -> Void in
            
            DispatchQueue.main.async(execute: { [weak self] in
                if animationLayer.flipAnimationStatus == .interrupt {
                    animationLayer.flipAnimationStatus = .completing
                    
                } else if animationLayer.flipAnimationStatus == .completing {
                    animationLayer.flipAnimationStatus = .none
                    
                    if animationLayer.isFirstOrLastPage == false {
                        CATransaction.begin()
                        CATransaction.setAnimationDuration(0)
                        if animationLayer.flipDirection == .top {
                            self?.flipperStaticView.leftSide.contents = animationLayer.backLayer.contents
                        } else {
                            self?.flipperStaticView.rightSide.contents = animationLayer.frontLayer.contents
                        }
                        CATransaction.commit()
                    }
                    
                    self?.animatingLayers.remove(object: animationLayer)
                    animationLayer.removeFromSuperlayer()
                    
                    if self?.animatingLayers.count == 0 {
                        
                        self?.flipperState = .inactive
                        self?.updateTheActiveView()
                        self?.flipperStaticView.removeFromSuperlayer()
                        CATransaction.flush()
                        self?.flipperStaticView.leftSide.contents = nil
                        self?.flipperStaticView.rightSide.contents = nil
                    } else {
                        CATransaction.flush()
                    }
                }
            })
            
        }
    }
    
    func setUpDJKAnimationLayerFrontAndBack(_ animationLayer: FlipperAnimationLayer) {
        if animationLayer.flipDirection == .top {
            if self.currentPage + 1 > numberOfPages - 1 {
                //we are at the end
                animationLayer.flipProperties.endFlipAngle = -1.5
                animationLayer.isFirstOrLastPage = true
                animationLayer.setTheFrontLayer(viewControllerSnapshots[currentPage]!)
            } else {
                //next page flip
                animationLayer.setTheFrontLayer(viewControllerSnapshots[currentPage]!)
                currentPage = currentPage + 1
                animationLayer.setTheBackLayer(viewControllerSnapshots[currentPage]!)
            }
        } else {
            if currentPage - 1 < 0 {
                //we are at the end
                animationLayer.flipProperties.endFlipAngle = -CGFloat.pi + 1.5
                animationLayer.isFirstOrLastPage = true
                animationLayer.setTheBackLayer(viewControllerSnapshots[currentPage]!)
                
            } else {
                //previous page flip
                animationLayer.setTheBackLayer(viewControllerSnapshots[currentPage]!)
                currentPage = currentPage - 1
                animationLayer.setTheFrontLayer(viewControllerSnapshots[currentPage]!)
            }
        }
    }
    
    func setUpStaticLayerForTheDJKAnimationLayer(_ animationLayer: FlipperAnimationLayer) {
        if animationLayer.flipDirection == .top {
            if animationLayer.isFirstOrLastPage == true && animatingLayers.count <= 1 {
                flipperStaticView.setTheLeftSide(viewControllerSnapshots[currentPage]!)
            } else {
                flipperStaticView.setTheLeftSide(viewControllerSnapshots[currentPage - 1]!)
                flipperStaticView.setTheRightSide(viewControllerSnapshots[currentPage]!)
            }
        } else {
            if animationLayer.isFirstOrLastPage == true && animatingLayers.count <= 1 {
                flipperStaticView.setTheRightSide(viewControllerSnapshots[currentPage]!)
            } else {
                flipperStaticView.setTheRightSide(viewControllerSnapshots[currentPage + 1]!)
                flipperStaticView.setTheLeftSide(viewControllerSnapshots[currentPage]!)
            }
        }
    }
    
    func updateViewControllerSnapShotsWithCurrentPage(_ currentPage:Int) {
        
        guard currentPage <= numberOfPages - 1 else { return }
        
        //set the current page snapshot
        viewControllerSnapshots[currentPage] = dataSource?.viewForPage(currentPage, flipper: self).takeSnapshot()
        
        if currentPage + 1 <= numberOfPages - 1  {
            //set the bottom page snapshot, if there already is a screen shot then dont update it
            if viewControllerSnapshots[currentPage + 1] == nil {
                viewControllerSnapshots[currentPage + 1] = dataSource?.viewForPage(currentPage + 1, flipper: self).takeSnapshot()
            }
        }
        
        if currentPage - 1 >= 0 {
            //set the top page snapshot, if there already is a screen shot then dont update it
            if viewControllerSnapshots[currentPage - 1] == nil {
                viewControllerSnapshots[currentPage - 1] = dataSource?.viewForPage(currentPage - 1, flipper: self).takeSnapshot()
            }
        }
    }
    
    func animationStatusCompleting(_ animationLayer: FlipperAnimationLayer) {
        performCompleteAnimationToLayer(animationLayer)
    }
    
    func performCompleteAnimationToLayer(_ animationLayer: FlipperAnimationLayer) {
        setUpForFlip(animationLayer, progress: 1.0, animated: true, clearFlip: true)
    }
    
    func getAnimationDurationFromDJKAnimationLayer(_ animationLayer: FlipperAnimationLayer, newAngle:CGFloat) -> CGFloat {
        var durationConstant: CGFloat = 0.75
        
        if animationLayer.isFirstOrLastPage == true {
            durationConstant = 0.5
        }
        return durationConstant * abs((newAngle - animationLayer.flipProperties.currentAngle) / (animationLayer.flipProperties.endFlipAngle - animationLayer.flipProperties.startAngle))
    }
    
    func addDJKAnimationLayer() {
        self.layer.addSublayer(flipperStaticView)
        CATransaction.flush()
        activeView?.removeFromSuperview()
    }
    
    func animationStatusActive(_ currentDJKAnimationLayer: FlipperAnimationLayer, translation:CGFloat, progress:CGFloat) {
        performIncrementalAnimationToLayer(currentDJKAnimationLayer, translation: translation, progress: progress)
    }
    
    func performIncrementalAnimationToLayer(_ animationLayer: FlipperAnimationLayer, translation:CGFloat, progress:CGFloat) {
        var progress = progress
        
        if translation > 0 {
            progress = max(progress, 0)
        } else {
            progress = min(progress, 0)
        }
        
        progress = abs(progress)
        setUpForFlip(animationLayer, progress: progress, animated: false, clearFlip: false)
    }
    
    func getFlipDirection(_ translation:CGFloat) -> FlipDirection {
        if translation > 0 {
            return .bottom
        } else {
            return .top
        }
    }
    
    func getReleaseSpeed(_ translation:CGFloat, gesture:UIPanGestureRecognizer) -> CGFloat {
        return (translation + gesture.velocity(in: self).x/4) / self.bounds.size.width
    }
    
    func enableGesture(_ gesture: UIPanGestureRecognizer,_ enabled: Bool) {
        gesture.isEnabled = enabled
    }
    
    func getHighestZIndexFlipperAnimationLayer() -> FlipperAnimationLayer? {
        return animatingLayers.sorted { (view0, view1) -> Bool in
            return view0.zPosition > view1.zPosition
        }.first
    }
    
    func isIncrementalSwipe(_ gesture:UIPanGestureRecognizer, animationLayer: FlipperAnimationLayer) -> Bool {
        
        var incrementalSwipe = false
        if abs(gesture.velocity(in: self).x) < 500 || animationLayer.isFirstOrLastPage == true {
            incrementalSwipe = true
        }
        
        return incrementalSwipe
    }
    
    func reload() {
        updateTheActiveView()

        viewControllerSnapshots.removeAll(keepingCapacity: false)

        for _ in 0..<numberOfPages {
            viewControllerSnapshots.append(nil)
        }
    }
    
}
