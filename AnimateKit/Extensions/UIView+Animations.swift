//
//  UIView+Animations.swift
//  AnimateKit
//
//  Created by Haider Khan on 12/9/18.
//  Copyright © 2018 zkhaider. All rights reserved.
//

import Foundation

extension UIView {
    
    @discardableResult public func animate(
        _ animations: ViewAnimation...,
        after: TimeInterval = 0.0,
        completion: (() -> ())? = nil) -> AnimationToken {
        return _animate(animations, after: after)
    }
    
    @discardableResult public func animate(
        inParallel animations: ViewAnimation...,
        after: TimeInterval = 0.0,
        completion: (() -> ())? = nil) -> AnimationToken {
        return _animate(inParallel: animations, after: after)
    }
    
    @discardableResult private func _animate(_ animations: [ViewAnimation],
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
    
    @discardableResult private func _animate(inParallel animations: [ViewAnimation],
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

extension UIView {
    
    func performAnimations(_ animations: [Animation],
                           after: TimeInterval = 0.0,
                           completionHandler: @escaping () -> Void) {
        
        guard let animations = animations as? [ViewAnimation] else { return }
        
        // This implementation is exactly the same as before, only now we call
        // the completion handler when our exit condition is hit
        guard !animations.isEmpty else {
            completionHandler()
            return
        }
        
        var _animations = animations
        let animation = _animations.removeFirst()
        
        if after > 0.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + after) { [weak self] in
                guard let this = self else { return }
                UIView.animate(withDuration: animation.duration,
                               delay: animation.delay,
                               options: animation.options,
                               animations: { animation.closure(this) }) { _ in
                                this.performAnimations(_animations,
                                                       completionHandler: completionHandler) }
            }
        } else {
            
            UIView.animate(withDuration: animation.duration,
                           delay: animation.delay,
                           options: animation.options,
                           animations: { animation.closure(self) }) { _ in
                            self.performAnimations(_animations,
                                                   completionHandler: completionHandler)
            }
        }
    }
    
    func performAnimationsInParallel(_ animations: [Animation],
                                     after: TimeInterval = 0.0,
                                     completionHandler: @escaping () -> Void) {
        
        guard let animations = animations as? [ViewAnimation] else { return }
        
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
                for animation in animations {
                    
                    UIView.animate(withDuration: animation.duration, animations: {
                        animation.closure(this)
                    }, completion: { _ in
                        animationCompletionHandler()
                    })
                }
            }
        } else {
            
            for animation in animations {
                
                UIView.animate(withDuration: animation.duration, animations: {
                    animation.closure(self)
                }, completion: { _ in
                    animationCompletionHandler()
                })
            }
        }
    }
    
}
