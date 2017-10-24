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
        let textContainer = NSTextContainer(size: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textStorage.addAttribute(.font, value: font, range: NSMakeRange(0, textStorage.length))
        textContainer.lineFragmentPadding = 0.0
        
        layoutManager.glyphRange(for: textContainer)
        let size = layoutManager.usedRect(for: textContainer)
        return CGRect(x: size.origin.x, y: size.origin.y, width: ceil(size.width), height: ceil(size.height))
    }
    
    func lastLineFrameSize(maxWidth: CGFloat, font: UIFont) -> CGRect {
        
        let textStorage = NSTextStorage(string: self)
        let textContainer = NSTextContainer(size: CGSize(width:maxWidth, height: CGFloat.greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textStorage.addAttribute(.font, value: font, range: NSMakeRange(0, textStorage.length))
        textContainer.lineFragmentPadding = 0.0
        
        var index = 0
        let numberOfGlyphs : Int = layoutManager.numberOfGlyphs
        
        var lineRange = NSMakeRange(NSNotFound, 0)
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
        }
        
        let size = layoutManager.boundingRect(forGlyphRange: lineRange, in: textContainer)
        return CGRect(x: size.origin.x, y: size.origin.y, width: ceil(size.width), height: ceil(size.height))
    }
    
}
