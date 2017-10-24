//
//  ChatCell.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 9/1/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

class ChatCell : UICollectionViewCell {
    
    static private let textPadding = CGFloat(10)
    static private let textToTimestampPadding = CGFloat(20)
    static private let maxBubbleContentWidth =  CGFloat(260)
    static private let sideBubblePadding = CGFloat(10)
    static private let topBubblePadding = CGFloat(5)
    static private let bottomBubblePadding = CGFloat(10)
    private let senderBubbleColor = UIColor.appleBlue()
    private let receiverBubbleColor = UIColor(white: 0.95, alpha: 1)
    static private let messageFont = UIFont.preferredFont(forTextStyle: .body)
    static private let timestampFont = UIFont.preferredFont(forTextStyle: .footnote)
    
    let messageWithTimestampView: ChatMessageWithTimestampView = {
        let messageView = ChatMessageWithTimestampView()
        return messageView
    }()
    
    let bubbleBackgroundView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 13
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder is not implemented")
    }
    
    func setupViews() {
        
        addSubview(bubbleBackgroundView)
        addSubview(messageWithTimestampView)
        
    }
    
    func drawMessage(message: Message) {
        
        if (message.isSender) {
            bubbleBackgroundView.backgroundColor = senderBubbleColor
            messageWithTimestampView.messageLabel.textColor = UIColor.white
            messageWithTimestampView.timestampLabel.textColor = UIColor.white
        } else {
            bubbleBackgroundView.backgroundColor = receiverBubbleColor
            messageWithTimestampView.messageLabel.textColor = UIColor.black
            messageWithTimestampView.timestampLabel.textColor = UIColor.black
        }
        
        let textMessage = message.text
        let timestampMessage = message.date
        let timestampText = ChatCell.formatDate(date: timestampMessage!)
        let timestampTextSize = timestampText.frameSize(maxWidth: ChatCell.maxBubbleContentWidth, font: ChatCell.timestampFont)
        let messageTextSize = textMessage?.frameSize(maxWidth: ChatCell.maxBubbleContentWidth, font: ChatCell.messageFont)
        
        messageWithTimestampView.timestampLabel.text = timestampText
        messageWithTimestampView.messageLabel.text = message.text
        
        var totalHeight = (messageTextSize?.height)! + (2 * ChatCell.textPadding)
        var totalWidth = (messageTextSize?.width)! + (2 * ChatCell.textPadding)
        var startBubble : CGFloat?;
        
        if ( ChatCell.textAndTimestampLargerThanBubbleWidth(timestampTextSize: timestampTextSize, messageTextSize: messageTextSize!)) {
            
            if (message.isSender) {
                startBubble = self.frame.width - ((messageTextSize?.width)! + ( 2 * ChatCell.textPadding ) + ChatCell.sideBubblePadding)
            } else {
                startBubble = ChatCell.sideBubblePadding
            }
            
            messageWithTimestampView.messageLabel.frame = CGRect(x: startBubble! + ChatCell.textPadding, y: ChatCell.topBubblePadding + ChatCell.textPadding, width: (messageTextSize?.width)!, height: (messageTextSize?.height)!)
            
            let lastMessageFrameSize = textMessage?.lastLineFrameSize(maxWidth: ChatCell.maxBubbleContentWidth, font: ChatCell.messageFont)
            
            if ( ChatCell.lastTextSizeAndTimestampLargerThanBubbleWidth(timestampTextSize: timestampTextSize, lastTextFrameSize: lastMessageFrameSize!) ) {
                messageWithTimestampView.timestampLabel.frame = CGRect(
                    x: messageWithTimestampView.messageLabel.frame.maxX - timestampTextSize.width,
                    y: messageWithTimestampView.messageLabel.frame.maxY + ChatCell.textPadding,
                    width: timestampTextSize.width,
                    height: timestampTextSize.height
                )
                totalHeight += timestampTextSize.height + ChatCell.textPadding
                bubbleBackgroundView.frame = CGRect(x: startBubble!, y: ChatCell.topBubblePadding, width: totalWidth, height: totalHeight)
            } else {
                
                bubbleBackgroundView.frame = CGRect(x: startBubble!, y: ChatCell.topBubblePadding, width: totalWidth, height: totalHeight)
                messageWithTimestampView.timestampLabel.frame = CGRect(
                    x: (bubbleBackgroundView.frame.maxX - timestampTextSize.width) - ChatCell.textPadding,
                    y: (bubbleBackgroundView.frame.maxY - timestampTextSize.height) - ChatCell.textPadding,
                    width: timestampTextSize.width,
                    height: timestampTextSize.height
                )
            }
            
        } else {
            
            if (message.isSender) {
                startBubble = self.frame.width - ((messageTextSize?.width)! + ChatCell.textPadding + ChatCell.textToTimestampPadding + ChatCell.sideBubblePadding) - timestampTextSize.width
            } else {
                startBubble = ChatCell.sideBubblePadding
            }
            
            totalWidth += timestampTextSize.width + ChatCell.textPadding
            
            bubbleBackgroundView.frame = CGRect(x: startBubble!, y: ChatCell.topBubblePadding, width: totalWidth, height: totalHeight)
            
            messageWithTimestampView.messageLabel.frame = CGRect(x: startBubble! + ChatCell.textPadding, y: ChatCell.topBubblePadding + ChatCell.textPadding, width: (messageTextSize?.width)!, height: (messageTextSize?.height)!)
            
            messageWithTimestampView.timestampLabel.frame = CGRect(
                x: (bubbleBackgroundView.frame.maxX - timestampTextSize.width) - ChatCell.textPadding,
                y: messageWithTimestampView.messageLabel.frame.maxY - timestampTextSize.height,
                width: timestampTextSize.width,
                height: timestampTextSize.height
            )
        }
        
    }
    
    static func textAndTimestampLargerThanBubbleWidth(timestampTextSize: CGRect, messageTextSize: CGRect) -> Bool {
        return ( timestampTextSize.width + messageTextSize.width + ChatCell.textPadding >=  ChatCell.maxBubbleContentWidth )
    }
    
    static func lastTextSizeAndTimestampLargerThanBubbleWidth(timestampTextSize: CGRect, lastTextFrameSize: CGRect) -> Bool {
        return ( timestampTextSize.width + lastTextFrameSize.width + ChatCell.textToTimestampPadding + ChatCell.textPadding >=  ChatCell.maxBubbleContentWidth )
    }
    
    static func cellHeightForMessage(message: Message, nextMessage: Message?) -> CGFloat {
        if let textMessage = message.text {
            
            let messageTextSize = textMessage.frameSize(maxWidth: maxBubbleContentWidth, font: ChatCell.messageFont)
            
            var bubbleSpace = ChatCell.bottomBubblePadding;
            if (nextMessage != nil) {
                if (message.isSender == nextMessage?.isSender) {
                    bubbleSpace = 0
                }
            }
            
            var totalHeight = messageTextSize.height + (2 * textPadding) + topBubblePadding + bubbleSpace;
            
            let timestampText = formatDate(date: message.date!)
            let timestampTextSize = timestampText.frameSize(maxWidth: maxBubbleContentWidth, font: self.timestampFont)
            let lastMessageFrameSize = textMessage.lastLineFrameSize(maxWidth: maxBubbleContentWidth, font: self.messageFont)
            if ( ChatCell.textAndTimestampLargerThanBubbleWidth(timestampTextSize: timestampTextSize, messageTextSize: messageTextSize)) {
                if ( ChatCell.lastTextSizeAndTimestampLargerThanBubbleWidth(timestampTextSize: timestampTextSize, lastTextFrameSize: lastMessageFrameSize) ) {
                    totalHeight += timestampTextSize.height + ChatCell.textPadding
                }
            }
            return totalHeight
        }
        return CGFloat(0)
    }
    
    static func formatDate(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        
        let elapsedTimeInSecond : TimeInterval = NSDate().timeIntervalSince(date as Date)
        let oneDayInSeconds : TimeInterval = 60 * 60 * 24
        let oneWeekInSeconds : TimeInterval = 7 * oneDayInSeconds
        
        if elapsedTimeInSecond > oneDayInSeconds {
            dateFormatter.dateFormat = "EEE H:mm"
        } else if elapsedTimeInSecond > oneWeekInSeconds {
            dateFormatter.dateFormat = "DD:MM"
        }
        
        let timestampText = dateFormatter.string(from: date as Date)
        return timestampText
    }
}
