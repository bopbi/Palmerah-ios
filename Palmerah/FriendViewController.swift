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
        navigationItem.title = "Friend"
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
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0(68)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[v0(68)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImageView]))
        
        addSubview(dividerLine)
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-82-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : dividerLine]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : dividerLine]))
    }
}
