//
//  Animate.swift
//  AnimateKit
//
//  Created by Haider Khan on 12/9/18.
//  Copyright © 2018 zkhaider. All rights reserved.
//

import Foundation

public func animate(_ tokens: AnimationToken...) {
    animate(tokens)
}

internal func animate(_ tokens: [AnimationToken]) {
    guard !tokens.isEmpty else {
        return
    }
    
    var tokens = tokens
    let token = tokens.removeFirst()
    
    token.perform {
        animate(tokens)
    }
}

public protocol Animation {}
