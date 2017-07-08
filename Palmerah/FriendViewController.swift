//
//  ViewController.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 7/6/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

class FriendViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Recents"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(FriendCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }

}

class FriendCell : UICollectionViewCell {
    

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
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.text = "Message and maybe something else"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "13:00 pm"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    let readMessageStatusImageView : UIImageView = {
        let imageView : UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder is not implemented")
    }
    
    func setupViews() {
        addSubview(profileImageView)
        
        profileImageView.image = UIImage(named:"sample_user_1")
        addConstraintWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintWithFormat(format: "V:[v0(68)]", views: profileImageView)
        addCenterYConstraintToParent(view: profileImageView)
        
        addSubview(dividerLine)
        addConstraintWithFormat(format: "H:|-82-[v0]|", views: dividerLine)
        addConstraintWithFormat(format: "V:[v0(1)]|", views: dividerLine)
        
        let containerView = UIView()
        
        addSubview(containerView)
        addConstraintWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addConstraintWithFormat(format: "V:[v0(50)]", views: containerView)
        addCenterYConstraintToParent(view: containerView)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        
        readMessageStatusImageView.image = UIImage(named: "status_pending")
        containerView.addSubview(readMessageStatusImageView)
        
        addConstraintWithFormat(format: "H:|[v0]-4-[v1(80)]-12-|", views: nameLabel, timeLabel)
        addConstraintWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        addConstraintWithFormat(format: "H:|[v0][v1(12)]-12-|", views: messageLabel, readMessageStatusImageView)
        addConstraintWithFormat(format: "V:|[v0(24)]", views: timeLabel)
        addConstraintWithFormat(format: "V:[v0(12)]|", views: readMessageStatusImageView)
    }
}
