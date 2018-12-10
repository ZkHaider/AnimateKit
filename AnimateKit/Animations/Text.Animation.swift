//
//  Text.Animation.swift
//  AnimateKit
//
//  Created by Haider Khan on 12/9/18.
//  Copyright © 2018 zkhaider. All rights reserved.
//

import Foundation

public struct TextAnimation: Animation {
    public var text: String
    public var duration: TimeInterval
    public var type: CATransitionType
    public var timingFunction: CAMediaTimingFunction
    public var removeOnCompletion: Bool
    public var key: String
    public init(text: String,
                duration: TimeInterval,
                type: CATransitionType,
                timingFunction: CAMediaTimingFunction,
                removeOnCompletion: Bool = true,
                key: String = "") {
        self.text = text
        self.duration = duration
        self.type = type
        self.timingFunction = timingFunction
        self.removeOnCompletion = removeOnCompletion
        self.key = key
    }
}

extension TextAnimation {
    
    public static func fade(to text: String,
                            duration: TimeInterval,
                            type: CATransitionType = CATransitionType.fade,
                            timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default),
                            removeOnCompletion: Bool = true,
                            animationKey: String = "") -> TextAnimation {
        return TextAnimation(text: text,
                             duration: duration,
                             type: type,
                             timingFunction: timingFunction,
                             removeOnCompletion: true,
                             key: animationKey)
    }
    
    public static func pushIn(to text: String,
                              duration: TimeInterval,
                              type: CATransitionType = CATransitionType.push,
                              timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default),
                              removeOnCompletion: Bool = true,
                              animationKey: String = "") -> TextAnimation {
        return TextAnimation(text: text,
                             duration: duration,
                             type: type,
                             timingFunction: timingFunction,
                             removeOnCompletion: true,
                             key: animationKey)
    }
    
    public static func moveIn(to text: String,
                              duration: TimeInterval,
                              type: CATransitionType = CATransitionType.moveIn,
                              timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default),
                              removeOnCompletion: Bool = true,
                              animationKey: String = "") -> TextAnimation {
        return TextAnimation(text: text,
                             duration: duration,
                             type: type,
                             timingFunction: timingFunction,
                             removeOnCompletion: true,
                             key: animationKey)
    }
    
    public static func reveal(to text: String,
                              duration: TimeInterval,
                              type: CATransitionType = CATransitionType.reveal,
                              timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default),
                              removeOnCompletion: Bool = true,
                              animationKey: String = "") -> TextAnimation {
        return TextAnimation(text: text,
                             duration: duration,
                             type: type,
                             timingFunction: timingFunction,
                             removeOnCompletion: true,
                             key: animationKey)
    }
    
}
