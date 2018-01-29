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
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = frame.height / 20
        imageView.clipsToBounds = true
        transparentView.layer.cornerRadius = 6
        transparentView.clipsToBounds = true
    }

    func configure(with envelope: Envelope) {
        nameLabel.text = envelope.name
    }

}
