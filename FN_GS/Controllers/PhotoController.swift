//
//  PhotoController.swift
//  FN_GS
//
//  Created by Viacheslav Poshelyk on 2/25/19.
//  Copyright © 2019 Viachaslau Pashaliuk. All rights reserved.
//

import UIKit
import Firebase
import Photos
import PhotosUI
import CoreData

class PhotoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginScreenLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var backPicture: UIImage!
    var gsUIImage: UIImage!
    
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var takeAPhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitle("Take A Photo", for: .normal)
        button.setTitleColor(UIColor.init(red: 144/255, green: 210/255, blue: 232/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        backgroundImageView.image = backPicture
        view.addSubview(photoImageView)
        view.addSubview(takeAPhotoButton)
        
        setupPhotoImageView()
        setupTakeAPhotoButton()
    }
    
    func chromaKeyFilter(fromHue: CGFloat, toHue: CGFloat) -> CIFilter?
    {
        let size = 64
        var cubeRGB = [Float]()
        
        for z in 0 ..< size {
            let blue = CGFloat(z) / CGFloat(size-1)
            for y in 0 ..< size {
                let green = CGFloat(y) / CGFloat(size-1)
                for x in 0 ..< size {
                    let red = CGFloat(x) / CGFloat(size-1)
    
                    let hue = getHue(red: red, green: green, blue: blue)
                    let alpha: CGFloat = (hue >= fromHue && hue <= toHue) ? 0: 1
                    
                    cubeRGB.append(Float(red * alpha))
                    cubeRGB.append(Float(green * alpha))
                    cubeRGB.append(Float(blue * alpha))
                    cubeRGB.append(Float(alpha))
                }
            }
        }
        
        let data = Data(buffer: UnsafeBufferPointer(start: &cubeRGB, count: cubeRGB.count))
   
        let colorCubeFilter = CIFilter(name: "CIColorCube", parameters: ["inputCubeDimension": size, "inputCubeData": data])
        return colorCubeFilter
    }
    func getHue(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat
    {
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        var hue: CGFloat = 0
        color.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage:UIImage = info[.originalImage] as! UIImage
        let ciImage = toCIImage(image: tempImage)
        
        
        
        let chromaCIFilter = self.chromaKeyFilter(fromHue: 0.27, toHue: 0.43)
        chromaCIFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        let sourceCIImageWithoutBackground = chromaCIFilter?.outputImage
        gsUIImage = toUIImage(image: sourceCIImageWithoutBackground!)
        
        let compositor = CIFilter(name:"CISourceOverCompositing")
        compositor?.setValue(sourceCIImageWithoutBackground, forKey: kCIInputImageKey)
        let backgroundCIImage = toCIImage(image: self.backPicture)
        compositor?.setValue(backgroundCIImage, forKey: kCIInputBackgroundImageKey)
        let context = CIContext() // Prepare to create CGImage
        let cgimg = context.createCGImage((compositor?.outputImage)!, from: (compositor?.outputImage?.extent)!)
        let chromaKeyedImage  : UIImage = UIImage(cgImage: cgimg!)
        
        //        TODO: Pass picture taken and background to the next screen as a UIImageView.image to allow zooming and placing
        //          Save after it's plased
        //          Allow (adding stickers?drawing?)
        //          For adding stickers: represent strings passed by user from keyboard as an images and make it a movable object using same tecniques as with picture taken zoom ins and placing(UIImageView + UIScrollView)
        //          For drawing: create canvas(out of UIImage?) on tap of the button, save it as a new UIImage
        
        UIImageWriteToSavedPhotosAlbum(chromaKeyedImage, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
        
        
//                              UPDATE!!!
        let storyBoard: UIStoryboard = UIStoryboard(name: "userInteraction", bundle: nil)
        let userInteractionController = storyBoard.instantiateViewController(withIdentifier: "userInteractionController") as! UserInteractionController
        userInteractionController.backPicture = backPicture
        userInteractionController.gsUIImage = gsUIImage
        
        present(userInteractionController, animated: false, completion: nil)
    }
    
    func toCIImage(image: UIImage) -> CIImage {
        return image.ciImage ?? CIImage(cgImage: image.cgImage!)
    }
    
    func toUIImage(image: CIImage) -> UIImage {
        return UIImage(ciImage: image)
    }
    
    @objc func takePhoto(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func setupPhotoImageView(){
        photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func setupTakeAPhotoButton() {
        takeAPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        takeAPhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        takeAPhotoButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        takeAPhotoButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

}

