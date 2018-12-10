//
//  StackView.Animation.swift
//  AnimateKit
//
//  Created by Haider Khan on 12/9/18.
//  Copyright © 2018 zkhaider. All rights reserved.
//

import Foundation

public struct StackViewAnimation: Animation {
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

extension StackViewAnimation {
    
    
    
}
