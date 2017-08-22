//
//  UIView+BlurEffect.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 8/22/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

extension UIView {
    
    func addBlurBackgroundLayer(blurStyle: UIBlurEffectStyle, colorIfBlurIsDisable: UIColor) {
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: blurStyle)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.backgroundColor = colorIfBlurIsDisable
        }
    }
    
}
