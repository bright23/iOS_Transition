//
//  AnimationController.swift
//  WaterLand
//
//  Created by bright on 2016/11/28.
//  Copyright © 2016年 bright. All rights reserved.
//

import UIKit

class TopToBottomAnimation: NSObject {
    let kMovedDistance: CGFloat = 70.0 // 遷移元のviewのずれる分の距離
    let kDuration = 0.3
    var presenting = false
    
}

extension TopToBottomAnimation: UIViewControllerAnimatedTransitioning
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
        // アニメーション終了時のframe
        let finalFrame = toView.frame
        // アニメーション開始時のframe（上からなのでマイナス値）
        let menuStartFrame = finalFrame.offsetBy(dx: 0, dy: UIScreen.mainHight * -1)
        
        toView.frame = menuStartFrame
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.05, animations: { () -> Void in
            toView.frame = finalFrame
            toView.frame = containerView.frame
        }) { (finished) -> Void in
            transitionContext.completeTransition(true)
        }
    }
    
    // 戻るときのアニメーション
    func dismissTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {
        // アニメーション終了時のframe
        let finalFrame = toView.frame
        // アニメーション開始時のframe（上からなのでマイナス値）
        let menuStartFrame = finalFrame.offsetBy(dx: 0, dy: UIScreen.mainHight * -1)
        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, belowSubview: fromView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, animations: { () -> Void in
            fromView.frame = menuStartFrame
            toView.alpha = 1.0
        }) { (finished) -> Void in
            transitionContext.completeTransition(true)
        }
    }
}
