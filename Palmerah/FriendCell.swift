//
//  FriendCell.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 18/11/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    var friend: Friend?
    
    func bindMessage(friend: Friend, emojiImage: UIImage)  {
        nameLabel.text = friend.name
        
        if let profileImageName = friend.profileImageNamed {
            profileImageView.image = UIImage(named: profileImageName)
        }
        
        // messageLabel.attributedText = message.text?.emojiTransform(emojiCode: ":D", emoticonImage: emojiImage)

    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .lightGray : .white
        }
    }
    
    let profileImageView : UIImageView = {
        let imageView : UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLine : UIView = {
        let view : UIView = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Friend Name That is very long long that depend on the last name"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.text = "Message and maybe something else"
        label.textColor = UIColor.darkGray
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    let readMessageStatusImageView : UIImageView = {
        let imageView : UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder is not implemented")
    }
    
    func setupViews() {
        addSubview(profileImageView)
        
        profileImageView.image = UIImage(named:"sample_user_1")
        addConstraintWithFormat(format: "H:|-[v0(68)]", views: profileImageView)
        addConstraintWithFormat(format: "V:[v0(68)]", views: profileImageView)
        addCenterYConstraintToParent(view: profileImageView)
        
        let containerView = UIView()
        
        addSubview(containerView)
        addConstraintWithFormat(format: "H:[v0]-[v1]|", views: profileImageView, containerView)
        addConstraintWithFormat(format: "V:[v0(50)]", views: containerView)
        addCenterYConstraintToParent(view: containerView)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        
        readMessageStatusImageView.image = UIImage(named: "status_pending")
        containerView.addSubview(readMessageStatusImageView)
        
        addConstraintWithFormat(format: "H:|[v0]|", views: nameLabel)
        addConstraintWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        addConstraintWithFormat(format: "H:|[v0][v1(12)]-|", views: messageLabel, readMessageStatusImageView)
        addConstraintWithFormat(format: "V:[v0(12)]|", views: readMessageStatusImageView)
    }
}
