//
//  SubHeadlineCell.swift
//  foos
//
//  Created by Derik Flanary on 1/16/17.
//  Copyright © 2017 Derik Flanary. All rights reserved.
//

import UIKit

class SubHeadlineCell: UITableViewCell, ReusableView {

    @IBOutlet weak var subHeadlineLabel: UILabel!
    
    func configure(with authViewState: AuthViewState) {
        subHeadlineLabel.text = authViewState.subHeadline()
    }
    
}
