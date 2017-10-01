//
//  InputMessageView.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 9/1/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

class MessageInputView: UIView, UITextViewDelegate {
    
    let inputTextViewLabelPlaceHolder : UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.font = UIFont.preferredFont(forTextStyle: .body)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.text = "Message"
        return placeholderLabel
    }()
    
    let inputTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
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
        addSubview(inputTextView)
        
        inputTextView.addSubview(inputTextViewLabelPlaceHolder)
        addConstraintWithFormat(format: "H:|-4-[v0]", views: inputTextViewLabelPlaceHolder)
        addConstraintWithFormat(format: "V:|-[v0]-|", views: inputTextViewLabelPlaceHolder)
        
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sendMessageButton)
        
        addConstraintWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextView, sendMessageButton)
        
        inputTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        inputTextView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -6).isActive = true
        
        sendMessageButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sendMessageButton.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        
        // Disabling textView scrolling prevents some undesired effects,
        // like incorrect contentOffset when adding new line,
        // and makes the textView behave similar to Apple's Messages app
        inputTextView.isScrollEnabled = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
