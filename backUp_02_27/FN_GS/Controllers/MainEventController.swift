//
//  MainEventController.swift
//  FN_GS
//
//  Created by Viacheslav Poshelyk on 2/23/19.
//  Copyright © 2019 Viachaslau Pashaliuk. All rights reserved.
//

import UIKit
import Firebase
import Photos
import CoreData

class MainEventController: UIViewController {
    
    lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(UIColor.init(red: 144/255, green: 210/255, blue: 232/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    @objc func handleLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let logOutError {
            print(logOutError)
        }
        let viewController = ViewController()
        present(viewController, animated: false, completion: nil)
    }
    
    
    //TODO: FIX CollectionView - Done
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.backgroundColor = UIColor.clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        return collection
    }()
    //                              HARDCODED DATA
//    var webCodeArray = ["7SD", "R4E", "HUI", "OK4", "JUI", "R43", "O1P", "SEZ", "PL9"]
//    var eventNameArray = ["Cipriani", "Rainbow Room", "John's Bar Mitzvah", "Goldenberg's Wedding", "Olivia's Bat Mizvah", "230 5th Ave", "Briant Park Grill", "6two9 NJ", "Pier 9"]
//    var eventImageArray = [UIImage(named: "camera"), UIImage(named: "camera"), UIImage(named: "camera"), UIImage(named: "camera"), UIImage(named: "camera"), UIImage(named: "camera"), UIImage(named: "camera"), UIImage(named: "camera"), UIImage(named: "check")]
    var eventNameArray: [NSManagedObject] = []
    var webCodes: [NSManagedObject] = []
    
    var estimateWidth = 200.0
    var cellMarginSize = 16.0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest1 =
            NSFetchRequest<NSManagedObject>(entityName: "WebCodes")
        do {
            webCodes = try managedContext.fetch(fetchRequest1)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        let fetchRequest2 =
            NSFetchRequest<NSManagedObject>(entityName: "EventNames")
        do {
            eventNameArray = try managedContext.fetch(fetchRequest2)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        let animationView = UIView()
        animationView.frame.size = view.frame.size
        animationView.center = view.center
        
        let gradient = CAGradientLayer(layer: animationView.layer)
        gradient.colors = [UIColor.init(red: 144/255, green: 210/255, blue: 232/255, alpha: 1).cgColor, UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = animationView.bounds
        
        animationView.layer.insertSublayer(gradient, at: 0)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0, 0.2]
        animation.toValue = [0, 1.4]
        animation.duration = 3
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        gradient.add(animation, forKey: nil)
        view.addSubview(animationView)
        
        if Auth.auth().currentUser?.uid == nil {
            handleLogOut()
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "EventsViewCell", bundle: nil), forCellWithReuseIdentifier: "EventsViewCell")
        self.setupGridView()
        view.addSubview(collectionView)
        view.addSubview(logOutButton)
        
        let negativeSpacer:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -5
        navigationItem.rightBarButtonItems = [negativeSpacer, UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addEvent))]
        
        setupCollection()
        setupLogOutButton()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    @objc func addEvent(){
        showAlert()
        
        print("It works!")
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Create new event", message: "Please enter:", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            (action) in print("Cancelled!")
        }
        let doneAction = UIAlertAction(title: "Done", style: .default){
            (action) in print("It's done!")
            self.save(webCode: (alert.textFields?.last?.text)!, eventName:(alert.textFields?.first?.text)!)
            let newIndexPath = IndexPath(row: 0, section: 0)
            self.collectionView.insertItems(at: [newIndexPath])
            
        }
        alert.addTextField{
            (textField) in textField.placeholder = "Event name"
            textField.keyboardType = .alphabet
        }
        alert.addTextField{
                (textField) in textField.placeholder = "Web-Code"
                textField.keyboardType = .alphabet
        }
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setupGridView() {
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func setupCollection() {
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -100).isActive = true
    }
    
    func setupLogOutButton() {
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        logOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    func save(webCode: String, eventName: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity1 =
            NSEntityDescription.entity(forEntityName: "WebCodes",
                                       in: managedContext)!
        let entity2 =
            NSEntityDescription.entity(forEntityName: "EventNames",
                                       in: managedContext)!
        
        let setWebCode = NSManagedObject(entity: entity1,
                                         insertInto: managedContext)
        setWebCode.setValue(webCode, forKeyPath: "webCode")
        
        let setEventName = NSManagedObject(entity: entity2,
                                           insertInto: managedContext)
        setEventName.setValue(eventName, forKeyPath: "eventName")
        do {
            try managedContext.save()
            webCodes.append(setWebCode)
            eventNameArray.append(setEventName)
            print("Saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension MainEventController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return webCodes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newWebCode = webCodes.reversed()[indexPath.row]
        let webCodeToPass = (newWebCode.value(forKeyPath: "webCode") as? String)
        let newEventName = eventNameArray.reversed()[indexPath.row]
        let eventNameToPass = (newEventName.value(forKeyPath: "eventName") as? String)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsViewCell", for: indexPath) as! EventsViewCell
        cell.setData(webCode: webCodeToPass!, eventName: eventNameToPass!, image: UIImage(named: "camera")!)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newWebCode = webCodes.reversed()[indexPath.row]
        print((newWebCode.value(forKeyPath: "webCode") as? String)!)
        print(indexPath.row)
        //TODO: add library access and create separate album for every web-code
        //TODO: create next viewController with the access to camera and add image processing - Done
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                // Permission Granted
                createPhotoLibraryAlbum(name: (newWebCode.value(forKeyPath: "webCode") as? String)!)
            case .denied:
            // Permission Denied
                print("User denied")
            default:
                print("Restricted")
            }
        }
        
//        let photoController = PhotoController()
//        present(photoController, animated: true, completion: nil)
        let backgroundController = BackgroundController()
        present(backgroundController, animated: true, completion: nil)

        
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 0.5
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha  = 1
    }
    
}

func createPhotoLibraryAlbum(name: String) {
    var alreadyExists = false
    let albumsPhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
    albumsPhoto.enumerateObjects({(collection, index, object) in
        let photoInAlbum = PHAsset.fetchAssets(in: collection, options: nil)
        if name == collection.localizedTitle {alreadyExists = true}
        print(photoInAlbum.count)
        print(collection.localizedTitle!)
    })
    if alreadyExists == false {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
        }, completionHandler: { success, error in
            if !success { print("Error creating album: \(String(describing: error)).") }
        })
    }
}

extension MainEventController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWith()
        return CGSize(width: width, height: width)
    }
    func calculateWith() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
}


