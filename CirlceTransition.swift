//
//  CirlceTransition.swift
//  RoboDone_iOS
//
//  Created by fujiwara on 2016/12/12.
//  Copyright © 2016年 fujiwara. All rights reserved.
//

import UIKit

class CirlceTransition: NSObject {
    let kDuration = 0.6
    var presenting = false
    var button: UIButton!
    weak var transitionContext: UIViewControllerContextTransitioning?
    
}

extension CirlceTransition: UIViewControllerAnimatedTransitioning, CAAnimationDelegate
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        
        // 遷移するときと戻るときとで処理を変える
        if presenting {
            presentTransition(transitionContext: transitionContext, toView: toVC!.view, fromView: fromVC!.view)
        } else {
            dismissTransition(transitionContext: transitionContext, toView: toVC!.view, fromView: fromVC!.view)
        }
    }
    
    
    // 遷移するときのアニメーション
    func presentTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {
        let containerView = transitionContext.containerView
        containerView.addSubview(toView) // toViewの下にfromView
        
        
        let circleMaskPathInitial = UIBezierPath(ovalIn: button.frame)
        let extremePoint = CGPoint(x: UIScreen.mainWidth, y: UIScreen.mainHight)
        let radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
        let circleMaskPathFinal = UIBezierPath(ovalIn: (button?.frame.insetBy(dx: -radius-70, dy: -radius-120))!)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        toView.layer.mask = maskLayer
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
        maskLayerAnimation.duration = self.transitionDuration(using: transitionContext)
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")
        transitionContext.completeTransition(true)
    }
    
    
    // 戻るときのアニメーション
    func dismissTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {
        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, belowSubview: fromView) // fromViewの下にtoView
        
        containerView.insertSubview(toView, belowSubview: fromView) // fromViewの下にtoView
        
        // 上と逆のことをする。
        toView.frame = toView.frame.offsetBy(dx: 0, dy: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: { () -> Void in
            fromView.frame = fromView.frame.offsetBy(dx: 0, dy: containerView.frame.size.height)
            toView.frame = toView.frame.offsetBy(dx: 0, dy: 0)
            toView.alpha = 1.0
        }) { (finished) -> Void in
            transitionContext.completeTransition(true)
        }
    }
}
