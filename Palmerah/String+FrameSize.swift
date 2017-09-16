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
        return self.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
    }
    
}
