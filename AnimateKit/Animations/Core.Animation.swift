//
//  Core.Animation.swift
//  AnimateKit
//
//  Created by Haider Khan on 12/16/18.
//  Copyright © 2018 zkhaider. All rights reserved.
//

import Foundation

public enum AnimationOperation {
    case alpha(from: CGFloat, to: CGFloat)
}

public struct CoreAnimation: Animation {
    public var operation: AnimationOperation
    public var duration: TimeInterval
    public var timingFunction: CAMediaTimingFunction
    public var removeOnCompletion: Bool
    public var autoReverses: Bool
    public var animationKey: String
    public var key: String
    public init(operation: AnimationOperation,
                duration: TimeInterval,
                timingFunction: CAMediaTimingFunction,
                removeOnCompletion: Bool = true,
                autoReverses: Bool = false,
                animationKey: String = "",
                key: String = "") {
        self.operation = operation
        self.duration = duration
        self.timingFunction = timingFunction
        self.removeOnCompletion = removeOnCompletion
        self.autoReverses = autoReverses
        self.animationKey = animationKey
        self.key = key
    }
}

extension CoreAnimation {
    
    public static func flash(fromAlpha alpha: CGFloat,
                             toAlpha: CGFloat,
                             duration: TimeInterval = 0.3,
                             delay: TimeInterval = 0.0,
                             timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default),
                             removeOnCompleton: Bool = true,
                             autoReverses: Bool = false,
                             key: String = "") -> CoreAnimation {
        let alphaOperation: AnimationOperation = .alpha(from: alpha, to: toAlpha)
        return CoreAnimation(operation: alphaOperation,
                             duration: duration,
                             timingFunction: timingFunction,
                             removeOnCompletion: removeOnCompleton,
                             autoReverses: autoReverses,
                             animationKey: "opacity",
                             key: key)
    }
    
}
