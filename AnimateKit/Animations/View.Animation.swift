//
//  View.Animation.swift
//  AnimateKit
//
//  Created by Haider Khan on 12/9/18.
//  Copyright © 2018 zkhaider. All rights reserved.
//

import Foundation

public struct ViewAnimation: Animation {
    public var duration: TimeInterval
    public var delay: TimeInterval
    public var options: UIView.AnimationOptions
    public var closure: (UIView) -> Void
    public init(duration: TimeInterval,
                delay: TimeInterval = 0.0,
                options: UIView.AnimationOptions = .curveEaseInOut,
                closure: @escaping (UIView) -> Void) {
        self.duration = duration
        self.delay = delay
        self.options = options
        self.closure = closure
    }
}

extension ViewAnimation {
    
    public static func alpha(to alpha: CGFloat,
                             duration: TimeInterval = 0.3,
                             delay: TimeInterval = 0.0,
                             options: UIView.AnimationOptions = .curveEaseInOut,
                             restoreIdentity: Bool = false) -> ViewAnimation {
        return ViewAnimation(duration: duration,
                             delay: delay,
                             options: options,
                             closure: {
                                $0.alpha = alpha
                                if restoreIdentity { $0.transform = .identity }
        })
    }
    
    public static func fadeOut(duration: TimeInterval = 0.3,
                               delay: TimeInterval = 0.0,
                               options: UIView.AnimationOptions = .curveEaseInOut,
                               restoreIdentity: Bool = false ) -> ViewAnimation {
        return ViewAnimation(duration: duration,
                             delay: delay,
                             options: options,
                             closure: {
                                $0.alpha = 0.0
                                if restoreIdentity { $0.transform = .identity }
        })
    }
    
    public static func fadeIn(duration: TimeInterval = 0.3,
                              delay: TimeInterval = 0.0,
                              options: UIView.AnimationOptions = .curveEaseInOut,
                              restoreIdentity: Bool = false) -> ViewAnimation {
        return ViewAnimation(duration: duration,
                             delay: delay,
                             options: options,
                             closure: {
                                $0.alpha = 1.0
                                if restoreIdentity { $0.transform = .identity }
        })
    }
    
    public static func scale(to size: CGSize,
                             duration: TimeInterval = 0.3,
                             delay: TimeInterval = 0.0,
                             options: UIView.AnimationOptions = .curveEaseInOut,
                             restoreIdentity: Bool = false) -> ViewAnimation {
        return ViewAnimation(duration: duration,
                             delay: delay,
                             options: options,
                             closure: {
                                $0.frame.size = size
                                if restoreIdentity { $0.transform = .identity }
        })
    }
    
    public static func scale(byX x: CGFloat,
                             y: CGFloat,
                             duration: TimeInterval = 0.3,
                             delay: TimeInterval = 0.0,
                             options: UIView.AnimationOptions = .curveEaseIn,
                             restoreIdentity: Bool = false) -> ViewAnimation {
        return ViewAnimation(duration: duration,
                             delay: delay,
                             options: options,
                             closure: {
                                $0.transform = CGAffineTransform(scaleX: x, y: y)
        })
    }
    
    public static func resize(to size: CGSize,
                              duration: TimeInterval = 0.3,
                              delay: TimeInterval = 0.0,
                              options: UIView.AnimationOptions = .curveEaseInOut,
                              restoreIdentity: Bool = false) -> ViewAnimation {
        return ViewAnimation(duration: duration,
                             delay: delay,
                             options: options,
                             closure: {
                                $0.bounds.size = size
                                if restoreIdentity { $0.transform = .identity }
        })
    }
    
    public static func move(byX x: CGFloat,
                            y: CGFloat,
                            duration: TimeInterval = 0.3,
                            delay: TimeInterval = 0.0,
                            options: UIView.AnimationOptions = .curveEaseInOut,
                            restoreIdentity: Bool = false) -> ViewAnimation {
        return ViewAnimation(duration: duration,
                             delay: delay,
                             options: options) {
                                $0.center.x += x
                                $0.center.y += y
                                if restoreIdentity { $0.transform = .identity }
        }
    }
    
    public static func move(to point: CGPoint,
                            currentView: UIView,
                            relativeView: UIView,
                            duration: TimeInterval = 0.3,
                            delay: TimeInterval = 0.0,
                            options: UIView.AnimationOptions = .curveEaseInOut,
                            restoreIdentity: Bool = false) -> ViewAnimation {
        
        // Calculate the relative point from current view to relative view
        let relativePoint = currentView.convert(point, to: relativeView)
        return ViewAnimation(duration: duration,
                             delay: delay,
                             options: options,
                             closure: {
                                $0.center = relativePoint
                                if restoreIdentity { $0.transform = .identity }
        })
    }
    
}
