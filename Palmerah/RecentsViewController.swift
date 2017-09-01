//
//  ViewController.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 7/6/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit
import CoreData

class RecentsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Recents"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(LastMessageCell.self, forCellWithReuseIdentifier: cellId)
        setupData()
        
        do {
            try self.recentsFetchController.performFetch()
        } catch let err {
            print(err)
        }
    }
    
    lazy var recentsFetchController : NSFetchedResultsController<Friend> = {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext
        let friendFetchRequest : NSFetchRequest<Friend> = Friend.fetchRequest()
        friendFetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "lastMessage.date", ascending: false)
        ]
        friendFetchRequest.predicate = NSPredicate(format: "lastMessage != nil")
        
        let fetchRequestController = NSFetchedResultsController(fetchRequest: friendFetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchRequestController.delegate = self
        return fetchRequestController
    }()
    
    var blockOperations = [BlockOperation]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.insertItems(at: [newIndexPath!])
            }))
            break
        case .delete:
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.deleteItems(at: [newIndexPath!])
            }))
            break
        case .update:
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.reloadItems(at: [newIndexPath!])
            }))
            break
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = self.recentsFetchController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LastMessageCell
        
        if let message = self.recentsFetchController.object(at: indexPath).lastMessage {
            cell.message = message
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellheight = 86 * (UIFont.preferredFont(forTextStyle: .headline).pointSize / 17)
        return CGSize(width: view.frame.width, height: cellheight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let controller = ChatRoomViewController(collectionViewLayout: layout)
        controller.friend = recentsFetchController.object(at: indexPath)
        navigationController?.pushViewController(controller, animated: true)
        
    }

}

class LastMessageCell : UICollectionViewCell {
    
    var message: Message? {
        didSet {
            nameLabel.text = message?.friend?.name
            
            if let profileImageName = message?.friend?.profileImageNamed {
                profileImageView.image = UIImage(named: profileImageName)
            }
            
            messageLabel.text = message?.text
            
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                
                let elapsedTimeInSecond : TimeInterval = NSDate().timeIntervalSince(date as Date)
                let oneDayInSeconds : TimeInterval = 60 * 60 * 24
                let oneWeekInSeconds : TimeInterval = 7 * oneDayInSeconds
                
                if elapsedTimeInSecond > oneDayInSeconds {
                    dateFormatter.dateFormat = "EEE"
                } else if elapsedTimeInSecond > oneWeekInSeconds {
                    dateFormatter.dateFormat = "DD:MM"
                }
                
                
                timeLabel.text = dateFormatter.string(from: date as Date)
            }
        }
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
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "13:00 pm"
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
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
        addConstraintWithFormat(format: "V:[v0(0.5)]|", views: dividerLine)
        
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
