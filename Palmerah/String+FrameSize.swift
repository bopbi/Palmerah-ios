//
//  NSString+SizeOfString.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 9/15/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

extension String {

    func frameSize(maxWidth: CGFloat, font: UIFont) -> CGRect {
        
        let textStorage = NSTextStorage(string: self)
        let textContainer = NSTextContainer(size: CGSize(width: CGFloat(maxWidth), height: CGFloat.greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textStorage.addAttribute(.font, value: font, range: NSMakeRange(0, textStorage.length))
        textContainer.lineFragmentPadding = 0.0
        
        layoutManager.glyphRange(for: textContainer)
        return layoutManager.usedRect(for: textContainer)
    }
    
}
