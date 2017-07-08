//
//  UIView+ConstraintWithFormat.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 7/8/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraintWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraint = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        NSLayoutConstraint.activate(constraint)
    }
    
    func addCenterYConstraintToParent(view: UIView) {
        NSLayoutConstraint.activate([NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        
    }
}
