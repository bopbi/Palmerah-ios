//
//  ChatCell.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 9/1/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

class ChatCell : UICollectionViewCell {
    
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
}
