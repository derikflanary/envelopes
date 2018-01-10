//
//  RoundedButton.swift
//  foos
//
//  Created by Derik Flanary on 1/16/17.
//  Copyright © 2017 Derik Flanary. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    enum RoundedEdgeType {
        case soft
        case full
        case none
    }
    
    var roundedEdgeType: RoundedEdgeType = .soft {
        didSet {
            updateEdges()
        }
    }
    
    var isShadowed: Bool = true {
        didSet {
            if isShadowed {
                addShadow()
            } else {
                removeShadow()
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                alpha = 1.0
            } else {
                alpha = 0.2
            }
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateEdges()
        addShadow()
    }
    
    func updateEdges() {
        switch roundedEdgeType {
        case .soft:
            layer.cornerRadius = 5
        case .full:
            layer.cornerRadius = frame.height/2
        case .none:
            layer.cornerRadius = 0
        }
        clipsToBounds = true
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        let upTitle = title?.uppercased()
        super.setTitle(upTitle, for: state)
    }
        
    func addShadow() {
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.masksToBounds = false
    }
    
    func removeShadow() {
        layer.shadowOpacity = 0.0
        layer.shadowRadius = 0.0
        layer.masksToBounds = true
    }
    
}
