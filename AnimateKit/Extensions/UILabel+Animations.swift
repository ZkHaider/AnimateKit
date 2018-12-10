//
//  UILabel+Animations.swift
//  AnimateKit
//
//  Created by Haider Khan on 12/9/18.
//  Copyright © 2018 zkhaider. All rights reserved.
//

import Foundation

extension UILabel {
    
    @discardableResult public func animate(
        _ animations: TextAnimation...,
        after: TimeInterval = 0.0,
        completion: (() -> ())? = nil) -> AnimationToken {
        return _animate(animations, after: after, completion: completion)
    }
    
    @discardableResult public func animate(
        inParallel animations: TextAnimation...,
        after: TimeInterval = 0.0,
        completion: (() -> ())? = nil) -> AnimationToken {
        return _animate(inParallel: animations, after: after, completion: completion)
    }
    
    @discardableResult private func _animate(_ animations: [TextAnimation],
                                             after: TimeInterval = 0.0,
                                             completion: (() -> ())? = nil) -> AnimationToken {
        return AnimationToken(
            view: self,
            animations: animations,
            mode: .sequential,
            after: after,
            completion: completion
        )
    }
    
    @discardableResult private func _animate(inParallel animations: [TextAnimation],
                                             after: TimeInterval = 0.0,
                                             completion: (() -> ())? = nil) -> AnimationToken {
        return AnimationToken(
            view: self,
            animations: animations,
            mode: .parallel,
            after: after,
            completion: completion
        )
    }
    
}

extension UILabel {
    
    func performTextAnimations(_ animations: [Animation],
                               after: TimeInterval = 0.0,
                               completionHandler: @escaping () -> Void) {
        
        guard let animations = animations as? [TextAnimation] else { return }
        
        // This implementation is exactly the same as before, only now we call
        // the completion handler when our exit condition is hit
        guard !animations.isEmpty else {
            completionHandler()
            return
        }
        
        var _animations = animations
        let textAnimation = _animations.removeFirst()
        
        if after > 0.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + after) { [weak self] in
                guard let this = self else { return }
                let animation: CATransition = CATransition()
                animation.duration = textAnimation.duration
                animation.type = textAnimation.type
                animation.timingFunction = textAnimation.timingFunction
                animation.isRemovedOnCompletion = textAnimation.removeOnCompletion
                
                CATransaction.setCompletionBlock({ [weak self] in
                    guard let this = self else { return }
                    this.performTextAnimations(animations,
                                               completionHandler: completionHandler)
                })
                
                this.layer.add(animation, forKey: textAnimation.key)
                this.text = textAnimation.text
            }
        } else {
            let animation: CATransition = CATransition()
            animation.duration = textAnimation.duration
            animation.type = textAnimation.type
            animation.timingFunction = textAnimation.timingFunction
            animation.isRemovedOnCompletion = textAnimation.removeOnCompletion
            
            CATransaction.setCompletionBlock({ [weak self] in
                guard let this = self else { return }
                this.performTextAnimations(animations,
                                           completionHandler: completionHandler)
            })
            
            self.layer.add(animation, forKey: textAnimation.key)
            self.text = textAnimation.text
        }
    }
    
    func performTextAnimationsInParallel(_ animations: [Animation],
                                         after: TimeInterval = 0.0,
                                         completionHandler: @escaping () -> Void) {
        
        guard let animations = animations as? [TextAnimation] else { return }
        
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
                for textAnimation in animations {
                    let animation: CATransition = CATransition()
                    animation.duration = textAnimation.duration
                    animation.type = textAnimation.type
                    animation.timingFunction = textAnimation.timingFunction
                    animation.isRemovedOnCompletion = textAnimation.removeOnCompletion
                    
                    CATransaction.setCompletionBlock({ [weak self] in
                        guard let _ = self else { return }
                        animationCompletionHandler()
                    })
                    
                    this.layer.add(animation, forKey: textAnimation.key)
                    this.text = textAnimation.text
                }
            }
        } else {
            
            for textAnimation in animations {
                let animation: CATransition = CATransition()
                animation.duration = textAnimation.duration
                animation.type = textAnimation.type
                animation.timingFunction = textAnimation.timingFunction
                animation.isRemovedOnCompletion = textAnimation.removeOnCompletion
                
                CATransaction.setCompletionBlock({ [weak self] in
                    guard let _ = self else { return }
                    animationCompletionHandler()
                })
                
                self.layer.add(animation, forKey: textAnimation.key)
                self.text = textAnimation.text
            }
        }
    }
    
}
