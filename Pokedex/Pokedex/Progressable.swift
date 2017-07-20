//
//  Progressable.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 20/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import Foundation
import PKHUD

protocol Progressable {
    func showLoading()
    func showError()
    func showSuccess()
}

extension Progressable {
    
    func showLoading() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
    }
    
    func showError() {
        PKHUD.sharedHUD.hide()
        HUD.flash(.error, delay: 1.0)
    }
    
    func showSuccess() {
        PKHUD.sharedHUD.hide()
        HUD.flash(.success, delay: 1.0)
    }
    
    func hideLoading() {
        PKHUD.sharedHUD.hide()
    }
}
