//
//  UserInteractionController.swift
//  FN_GS
//
//  Created by Viacheslav Poshelyk on 2/27/19.
//  Copyright © 2019 Viachaslau Pashaliuk. All rights reserved.
//

import UIKit

class UserInteractionController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var gsImageView: UIImageView!
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    var backPicture: UIImage!
    var gsUIImage: UIImage!

    lazy var backToBackgroundButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(backToBackground), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func backToBackground() {
        let backgroundChoose = BackgroundController()
        present(backgroundChoose, animated: false, completion: nil)
    }
    
//    lazy var backgroundImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = backPicture
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        scrollView.delegate = self

        backgroundImageView.image = backPicture
        gsImageView.image = gsUIImage
        
//        scrollView.addSubview(gsImageView)
        
        
        view.addSubview(backToBackgroundButton)
        
//        scrollView.minimumZoomScale = -6.0
//        scrollView.maximumZoomScale = 6.0
        
    
//        setupScrollView()
        setupBackToBackgroundButton()
//        setupBackgroundImageView()
//        setupGSImageView()
        

    }
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.gsImageView
//    }
//
//    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        let tap = UITapGestureRecognizer(target: self, action: nil)
//        tap.numberOfTapsRequired = 1
//        view!.addGestureRecognizer(tap)
//        let tappedPoint = tap.location(in: self.view)
//
//        scrollView.contentOffset.x = -tappedPoint.x
//        scrollView.contentOffset.y = -tappedPoint.y
//    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }


    func setupBackToBackgroundButton(){
        backToBackgroundButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        backToBackgroundButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
        backToBackgroundButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backToBackgroundButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
//    func setupScrollView(){
//        scrollView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor).isActive = true
//        scrollView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor).isActive = true
//        scrollView.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor).isActive = true
//        scrollView.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor).isActive = true
//    }
//
//    func setupGSImageView(){
//        gsImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        gsImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        gsImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        gsImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//    }

}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
