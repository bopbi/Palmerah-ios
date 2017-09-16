//
//  InputMessageView.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 9/1/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

class MessageInputView: UIView, UITextViewDelegate {
    
    let inputTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8.0
        textView.layer.masksToBounds = true
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.backgroundColor = UIColor.white.cgColor
        textView.layer.borderWidth = 0.5
        return textView
    }()
    
    let sendMessageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor.appleBlue()
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    override var intrinsicContentSize: CGSize {
        // Calculate intrinsicContentSize that will fit all the text
        let textSize = inputTextView.text.frameSize(maxWidth: bounds.width, font: inputTextView.font!)
        return CGSize(width: bounds.width, height: textSize.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addBlurBackgroundLayer(blurStyle: .extraLight, colorIfBlurIsDisable: .white)
        
        // This is required to make the view grow vertically
        autoresizingMask = .flexibleHeight
        
        // Setup textView as needed
        
        //sendMessageButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor.init(white: 0.69, alpha: 1)
        
        addSubview(inputTextView)
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sendMessageButton)
        addSubview(topBorderView)
        
        addConstraintWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextView, sendMessageButton)
        addConstraintWithFormat(format: "V:|-4-[v0]-4-|", views: inputTextView)
        addConstraintWithFormat(format: "V:|[v0]|", views: sendMessageButton)
        addConstraintWithFormat(format: "H:|[v0]|", views: topBorderView)
        addConstraintWithFormat(format: "V:|[v0(0.3)]", views: topBorderView)
        
        inputTextView.delegate = self
        
        // Disabling textView scrolling prevents some undesired effects,
        // like incorrect contentOffset when adding new line,
        // and makes the textView behave similar to Apple's Messages app
        inputTextView.isScrollEnabled = false
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        // Re-calculate intrinsicContentSize when text changes
        invalidateIntrinsicContentSize()
    }
}
