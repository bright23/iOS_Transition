//
//  RightToLeftTransition.swift
//  RoboDone_iOS
//
//  Created by bright on 2016/12/01.
//  Copyright © 2016年 fujiwara. All rights reserved.
//

import UIKit

class RightToLeftTransition: NSObject {
    let kMovedDistance: CGFloat = 70.0 // 遷移元のviewのずれる分の距離
    let kDuration = 0.3
    var presenting = false
    
}

extension RightToLeftTransition: UIViewControllerAnimatedTransitioning
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
        
        // 遷移先のviewを画面の右側に移動させておく。
        toView.frame = toView.frame.offsetBy(dx: containerView.frame.size.width, dy: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.05, options: .curveEaseInOut, animations: { () -> Void in
            // 遷移元のviewを少し左へずらし、alpha値を下げて少し暗くする。
            fromView.frame = fromView.frame.offsetBy(dx: -self.kMovedDistance, dy: 0)
            fromView.alpha = 0.7
            
            // 遷移先のviewを画面全体にはまるように移動させる。
            toView.frame = containerView.frame
        }) { (finished) -> Void in
            fromView.frame = fromView.frame.offsetBy(dx: self.kMovedDistance, dy: 0) // 元の位置に戻す
            transitionContext.completeTransition(true)
        }
    }
    
    // 戻るときのアニメーション
    func dismissTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {
        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, belowSubview: fromView) // fromViewの下にtoView
        
        // 上と逆のことをする。
        toView.frame = toView.frame.offsetBy(dx: -kMovedDistance, dy: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: { () -> Void in
            fromView.frame = fromView.frame.offsetBy(dx: containerView.frame.size.width, dy: 0)
            toView.frame = toView.frame.offsetBy(dx: self.kMovedDistance, dy: 0)
            toView.alpha = 1.0
        }) { (finished) -> Void in
            transitionContext.completeTransition(true)
        }
    }
}
