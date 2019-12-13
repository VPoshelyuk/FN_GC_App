//
//  BackgroundViewCell.swift
//  FN_GS
//
//  Created by Viacheslav Poshelyk on 2/24/19.
//  Copyright © 2019 Viachaslau Pashaliuk. All rights reserved.
//

import UIKit

class BackgroundViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 3.0
    }
    
    func setData(image: UIImage) {
        self.backgroundImageView.image = image
    }
    
}
