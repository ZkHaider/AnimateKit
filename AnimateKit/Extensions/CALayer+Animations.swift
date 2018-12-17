//
//  CALayer+Animations.swift
//  AnimateKit
//
//  Created by Haider Khan on 12/16/18.
//  Copyright © 2018 zkhaider. All rights reserved.
//

import Foundation

extension CALayer {
    
    @discardableResult public func animate(
        _ animations: CoreAnimation...,
        after: TimeInterval = 0.0,
        completion: (() -> ())? = nil) -> AnimationToken {
        return _animate(animations, after: after)
    }
    
    @discardableResult public func animate(
        inParallel animations: CoreAnimation...,
        after: TimeInterval = 0.0,
        completion: (() -> ())? = nil) -> AnimationToken {
        return _animate(inParallel: animations, after: after)
    }
    
    @discardableResult private func _animate(_ animations: [CoreAnimation],
                                             after: TimeInterval = 0.0,
                                             completion: (() -> ())? = nil) -> AnimationToken {
        return AnimationToken(
            view: nil,
            layer: self,
            animations: animations,
            mode: .sequential,
            after: after,
            completion: completion
        )
    }
    
    @discardableResult private func _animate(inParallel animations: [CoreAnimation],
                                             after: TimeInterval = 0.0,
                                             completion: (() -> ())? = nil) -> AnimationToken {
        return AnimationToken(
            view: nil,
            layer: self,
            animations: animations,
            mode: .parallel,
            after: after,
            completion: completion
        )
    }
    
}

extension CALayer {
    
    func performCoreAnimations(_ animations: [Animation],
                               after: TimeInterval = 0.0,
                               completionHandler: @escaping () -> Void) {
        
        guard let animations = animations as? [CoreAnimation] else { return }
        
        // This implementation is exactly the same as before, only now we call
        // the completion handler when our exit condition is hit
        guard !animations.isEmpty else {
            completionHandler()
            return
        }
        
        var _animations = animations
        let coreAnimation = _animations.removeFirst()
        
        if after > 0.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + after) { [weak self] in
                guard let this = self else { return }
                let animation: CABasicAnimation = CABasicAnimation(keyPath: coreAnimation.animationKey)
                this.applyValues(animation: animation, coreAnimation: coreAnimation)
                animation.duration = coreAnimation.duration
                animation.timingFunction = coreAnimation.timingFunction
                animation.isRemovedOnCompletion = coreAnimation.removeOnCompletion
                
                CATransaction.setCompletionBlock({ [weak self] in
                    guard let this = self else { return }
                    this.performCoreAnimations(animations,
                                               completionHandler: completionHandler)
                })
                
                this.add(animation, forKey: coreAnimation.key)
            }
        } else {
            let animation: CABasicAnimation = CABasicAnimation(keyPath: coreAnimation.animationKey)
            applyValues(animation: animation, coreAnimation: coreAnimation)
            animation.duration = coreAnimation.duration
            animation.autoreverses = coreAnimation.autoReverses
            animation.timingFunction = coreAnimation.timingFunction
            animation.isRemovedOnCompletion = coreAnimation.removeOnCompletion
            
            CATransaction.setCompletionBlock({ [weak self] in
                guard let this = self else { return }
                this.performCoreAnimations(animations,
                                           completionHandler: completionHandler)
            })
            
            self.add(animation, forKey: coreAnimation.key)
        }
    }
    
    func performCoreAnimationsInParallel(_ animations: [Animation],
                                         after: TimeInterval = 0.0,
                                         completionHandler: @escaping () -> Void) {
        
        guard let animations = animations as? [CoreAnimation] else { return }
        
        // If we have no animations, we can exit early
        guard !animations.isEmpty else {
            completionHandler()
            return
        }
        
        // In order to call the completion handler once all animations
        // have finished, we need to keep track of these counts
        let animationCount = animations.count
        var completionCount = 0
        
        let animationCompletionHandler = {
            completionCount += 1
            
            // Once all animations have finished, we call the completion handler
            if completionCount == animationCount {
                completionHandler()
            }
        }
        
        // Same as before, only with the call to the animation
        // completion handler added
        if after > 0.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + after) { [weak self] in
                guard let this = self else { return }
                for coreAnimation in animations {
                    let animation: CABasicAnimation = CABasicAnimation(keyPath: coreAnimation.animationKey)
                    this.applyValues(animation: animation, coreAnimation: coreAnimation)
                    animation.duration = coreAnimation.duration
                    animation.autoreverses = coreAnimation.autoReverses
                    animation.timingFunction = coreAnimation.timingFunction
                    animation.isRemovedOnCompletion = coreAnimation.removeOnCompletion
                    
                    CATransaction.setCompletionBlock({ [weak self] in
                        guard let _ = self else { return }
                        animationCompletionHandler()
                    })
                    
                    this.add(animation, forKey: coreAnimation.key)
                }
            }
        } else {
            
            for coreAnimation in animations {
                let animation: CABasicAnimation = CABasicAnimation(keyPath: coreAnimation.animationKey)
                applyValues(animation: animation, coreAnimation: coreAnimation)
                animation.duration = coreAnimation.duration
                animation.autoreverses = coreAnimation.autoReverses
                animation.timingFunction = coreAnimation.timingFunction
                animation.isRemovedOnCompletion = coreAnimation.removeOnCompletion
                
                CATransaction.setCompletionBlock({ [weak self] in
                    guard let _ = self else { return }
                    animationCompletionHandler()
                })
                
                self.add(animation, forKey: coreAnimation.key)
            }
        }
    }
    
    private func applyValues(animation: CABasicAnimation, coreAnimation: CoreAnimation) {
        switch coreAnimation.operation {
        case let .alpha(fromValue, toValue):
            animation.fromValue = fromValue
            animation.toValue = toValue
        }
    }
    
}
