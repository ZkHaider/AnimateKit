//
//  ViewController.swift
//  Example
//
//  Created by Haider Khan on 12/9/18.
//  Copyright © 2018 zkhaider. All rights reserved.
//

import UIKit
import AnimateKit

class ViewController: UIViewController {
    
    // MARK: - Views
    
    let stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()
    
    let stackViewSubview1: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .green
        return view
    }()
    
    let stackViewSubview2: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .red
        return view
    }()
    
    let stackViewSubview3: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .yellow
        return view
    }()
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let bounds = view.bounds
        let slice = bounds.divided(atDistance: 100.0, from: .minYEdge)
            .slice.offsetBy(dx: 0.0, dy: 100.0)
        self.stackView.frame = slice
        
        let stackViewBounds = self.stackView.bounds
        let (stackViewSlice, stackViewRemainder) = stackViewBounds
            .divided(atDistance: stackViewBounds.width / 3.0, from: .minXEdge)
        
        self.stackViewSubview1.frame = stackViewSlice
        
        let (subview2Frame, subview3Frame) = stackViewRemainder.divided(atDistance: stackViewRemainder.width / 2.0, from: .minXEdge)
        self.stackViewSubview2.frame = subview2Frame
        self.stackViewSubview3.frame = subview3Frame
    }

}

extension ViewController {
    
    fileprivate func initialize() {
        func addSubviews() {
            self.view.addSubview(stackView)
            [stackViewSubview1, stackViewSubview2, stackViewSubview3].forEach(stackView.addArrangedSubview)
        }
        addSubviews()
    }
    
}

