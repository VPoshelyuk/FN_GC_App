//
//  EventsViewCell.swift
//  FN_GS
//
//  Created by Viacheslav Poshelyk on 2/24/19.
//  Copyright © 2019 Viachaslau Pashaliuk. All rights reserved.
//

import UIKit

class EventsViewCell: UICollectionViewCell {

    @IBOutlet weak var webCodeLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10.0
    }
    
    func setData(webCode: String, eventName: String, image: UIImage) {
        self.webCodeLabel.text = webCode
        self.eventNameLabel.text = eventName
        self.eventImageView.image = image
    }

}
