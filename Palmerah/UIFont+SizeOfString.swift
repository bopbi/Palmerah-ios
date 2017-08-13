//
//  UIFont+SizeOfString.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 8/7/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

extension UIFont {
    
    func sizeOfString (string: String, constrainedToWidth width: CGFloat) -> CGSize {
        let attributes = [NSFontAttributeName:self,]
        let attString = NSAttributedString(string: string,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), nil)
    }
    
}
