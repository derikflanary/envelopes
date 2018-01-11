//
//  EnvelopeCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

class EnvelopeCell: UICollectionViewCell, ReusableView {

    static var height: CGFloat = 250

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
    }

}
