//
//  UIButtonExtension.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 03/08/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import Foundation
import UIKit
extension UIButton {
    
    func animatePulse() {
        self.isSelected = !self.isSelected
        
        if self.isSelected {
            
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.duration = 0.75
            pulse.fromValue = 0.9
            pulse.toValue = 1.0
            pulse.autoreverses = true
            pulse.repeatCount = .greatestFiniteMagnitude
            pulse.initialVelocity = 0.5
            pulse.damping = 1.0
            
            self.layer.add(pulse, forKey: "pulse")
            
        } else {
            self.layer.removeAnimation(forKey: "pulse")
        }
        
    }
    
    func animateRadius() {
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = self.layer.cornerRadius
        animation.toValue = 25
        animation.duration = 2.5
        self.layer.add(animation, forKey: "cornerRadiusAnimation")
        
    }
    
}
