//
//  AnimationToken.swift
//  AnimateKit
//
//  Created by Haider Khan on 12/9/18.
//  Copyright © 2018 zkhaider. All rights reserved.
//

import Foundation

public final class AnimationToken {
    
    weak var view: UIView?
    weak var layer: CALayer?
    private let animations: [Animation]
    private let mode: AnimationMode
    private var isValid: Bool = true
    private var after: TimeInterval
    private var completion: (() -> ())?
    
    // We don't want the API user to think that they should create tokens
    // themselves, so we make the initializer internal to the framework
    internal init(view: UIView? = nil,
                  layer: CALayer? = nil,
                  animations: [Animation],
                  mode: AnimationMode,
                  after: TimeInterval = 0.0,
                  completion: (() -> ())? = nil) {
        self.view = view
        self.layer = layer
        self.animations = animations
        self.mode = mode
        self.after = after
        self.completion = completion
    }
    
    deinit {
        // Perform animation
        AnimationToken.perform(withView: self.view,
                               layer: self.layer,
                               animations: self.animations,
                               mode: self.mode,
                               isValid: self.isValid,
                               after: self.after,
                               completion: self.completion,
                               completionHandler: {})
        completion = nil
        layer = nil
        view = nil
    }
    
    internal static func perform(withView view: UIView?,
                                 layer: CALayer?,
                                 animations: [Animation],
                                 mode: AnimationMode,
                                 isValid: Bool,
                                 after: TimeInterval,
                                 completion: (() -> Void)?,
                                 completionHandler: @escaping () -> Void) {
        // To prevent the animation from being executed twice, we invalidate
        // the token once its animation has been performed
        guard isValid else {
            completion?()
            return
        }
        
        switch mode {
        case .sequential:
            switch view {
            case view as UILabel:
                guard
                    let label = view as? UILabel,
                    let _ = animations as? [TextAnimation]
                    else {
                        view?.performAnimations(animations,
                                                after: after,
                                                completionHandler: completionHandler)
                        return
                }
                label.performTextAnimations(animations,
                                            after: after,
                                            completionHandler: completionHandler)
            default:
                view?.performAnimations(animations,
                                        after: after,
                                        completionHandler: completionHandler)
            }
            
            if let layer = layer,
                let animations = animations as? [CoreAnimation] {
                layer.performCoreAnimations(animations,
                                            after: after,
                                            completionHandler: completionHandler)
            }
            
        case .parallel:
            switch view {
            case view as UILabel:
                guard
                    let label = view as? UILabel,
                    let _ = animations as? [TextAnimation]
                    else {
                        view?.performAnimationsInParallel(animations,
                                                          after: after,
                                                          completionHandler: completionHandler)
                        return
                }
                label.performTextAnimationsInParallel(animations,
                                                      after: after,
                                                      completionHandler: completionHandler)
            default:
                view?.performAnimationsInParallel(animations,
                                                  after: after,
                                                  completionHandler: completionHandler)
            }
            
            if let layer = layer,
                let animations = animations as? [CoreAnimation] {
                layer.performCoreAnimationsInParallel(animations,
                                                      after: after,
                                                      completionHandler: completionHandler)
            }
        }
    }
    
    internal func perform(completionHandler: @escaping () -> Void) {
        // To prevent the animation from being executed twice, we invalidate
        // the token once its animation has been performed
        guard isValid else {
            self.completion?()
            self.completion = nil
            return
        }
        
        isValid = false
        
        switch mode {
        case .sequential:
            switch view {
            case view as UILabel:
                guard
                    let label = view as? UILabel,
                    let _ = animations as? [TextAnimation]
                    else {
                        view?.performAnimations(animations,
                                                after: after,
                                                completionHandler: completionHandler)
                        return
                }
                label.performTextAnimations(animations,
                                            after: after,
                                            completionHandler: completionHandler)
            default:
                view?.performAnimations(animations,
                                        after: after,
                                        completionHandler: completionHandler)
            }
            
            if let layer = layer,
                let animations = animations as? [CoreAnimation] {
                layer.performCoreAnimations(animations,
                                            after: after,
                                            completionHandler: completionHandler)
            }
            
        case .parallel:
            switch view {
            case view as UILabel:
                guard
                    let label = view as? UILabel,
                    let _ = animations as? [TextAnimation]
                    else {
                        view?.performAnimationsInParallel(animations,
                                                          after: after,
                                                          completionHandler: completionHandler)
                        return
                }
                label.performTextAnimationsInParallel(animations,
                                                      after: after,
                                                      completionHandler: completionHandler)
            default:
                view?.performAnimationsInParallel(animations,
                                                  after: after,
                                                  completionHandler: completionHandler)
            }
            
            if let layer = layer,
                let animations = animations as? [CoreAnimation] {
                layer.performCoreAnimationsInParallel(animations,
                                                      after: after,
                                                      completionHandler: completionHandler)
            }
        }
    }
    
}

internal enum AnimationMode {
    case sequential
    case parallel
}
