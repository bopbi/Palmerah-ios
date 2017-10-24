//
//  UIImage+Resize.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 25/10/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizeImage(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / self.size.width
        let verticalRatio = newSize.height / self.size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        var newImage: UIImage
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = false
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: newSize.width, height: newSize.height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}
