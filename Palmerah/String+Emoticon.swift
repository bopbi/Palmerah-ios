//
//  String+Emoticon.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 24/10/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

extension String {
    
    func emojiTransform(emoticonImage: UIImage) -> NSAttributedString {
        
        let stringWithEmoji = NSMutableAttributedString()
        let stringLength = self.characters.count;
        
        let emojiAttachment = NSTextAttachment()
        emojiAttachment.image = emoticonImage
        emojiAttachment.bounds = CGRect(x: 0, y: 0, width: emoticonImage.size.width, height: emoticonImage.size.height)
        
        var index = 1
        var buffer = ""
        while (index < stringLength) {
            let prevChar = self[self.index(self.startIndex, offsetBy: index - 1)]
            let currentChar = self[self.index(self.startIndex, offsetBy: index)]
            if (prevChar == ":" && currentChar == "D") {
                if (buffer.characters.count > 0) {
                    let characterAttributed = NSAttributedString(string: buffer)
                    stringWithEmoji.insert(characterAttributed, at: stringWithEmoji.length)
                    buffer = ""
                }
                let emojiAttributedString = NSAttributedString(attachment: emojiAttachment)
                stringWithEmoji.insert(emojiAttributedString, at: stringWithEmoji.length)
                index += 1
            } else {
                buffer += String(prevChar)
                if (index == stringLength - 1) {
                    buffer += String(currentChar)
                    let characterAttributed = NSAttributedString(string: buffer)
                    stringWithEmoji.insert(characterAttributed, at: stringWithEmoji.length)
                }
            }
            index += 1
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineSpacing = 1.0
        stringWithEmoji.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, stringWithEmoji.length))
        return stringWithEmoji;
    }
 
}
