//
//  BackgroundController.swift
//  FN_GS
//
//  Created by Viacheslav Poshelyk on 2/27/19.
//  Copyright © 2019 Viachaslau Pashaliuk. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class BackgroundController: UIViewController {

    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = UIColor.clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        return collection
    }()
    
    var BackgroundsToChooseFrom = [UIImage(named: "Budapest"), UIImage(named: "Yerevan"), UIImage(named: "Times_Square"), UIImage(named: "Hong_Kong"), UIImage(named: "Pinsk"), UIImage(named: "Los_Angeles"), UIImage(named: "Manhattan"), UIImage(named: "NYC"), UIImage(named: "Paris"), UIImage(named: "Bryant_Park"), UIImage(named: "Shanghai"), UIImage(named: "Safari"), UIImage(named: "Cool_Cat")]
    
    var backgroundPicture: UIImage!
    
    var estimateWidth = 300.0
    var cellMarginSize = 6.0

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        view.addSubview(animationView)

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "BackgroundViewCell", bundle: nil), forCellWithReuseIdentifier: "BackgroundViewCell")
        self.setupGridView()
        view.addSubview(collectionView)
        
        setupCollection()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
    
}

extension BackgroundController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BackgroundsToChooseFrom.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackgroundViewCell", for: indexPath) as! BackgroundViewCell
        cell.setData(image: self.BackgroundsToChooseFrom[indexPath.row]!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        backgroundPicture = self.BackgroundsToChooseFrom[indexPath.row]!
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let photoController = storyBoard.instantiateViewController(withIdentifier: "PhotoController") as! PhotoController

        photoController.backPicture = backgroundPicture
        
        present(photoController, animated: true, completion: nil)
        
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

extension BackgroundController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWith()
        let height = width * 3 / 5
        return CGSize(width: width, height: height)
    }
    func calculateWith() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
}
