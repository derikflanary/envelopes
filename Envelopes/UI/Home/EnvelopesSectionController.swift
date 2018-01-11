//
//  EnvelopesSectionController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import IGListKit
import UIKit

class EnvelopeSection: NSObject, ListDiffable {

    var envelope: Envelope

    init(envelope: Envelope) {
        self.envelope = envelope
    }

    public func diffIdentifier() -> NSObjectProtocol {
        return envelope.id as NSString
    }

    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? EnvelopeSection else { return false }
        return envelope.id == other.envelope.id &&
        envelope.totalAmount == other.envelope.totalAmount
    }

}


class EnvelopesSectionController: ListSectionController {

    var envelopeSection: EnvelopeSection!
    var core = App.sharedCore
    var sectionSelectionCompletion: (() -> Void)?

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }

}


extension EnvelopesSectionController {

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let collectionContext = collectionContext else { return .zero }
        let height: CGFloat = EnvelopeCell.height
        let width = collectionContext.containerSize.width - 32
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: EnvelopeCell.reuseIdentifier, bundle: nil, for: self, at: index) as! EnvelopeCell
        return cell
    }

    override func didUpdate(to object: Any) {
        if let object = object as? EnvelopeSection {
            envelopeSection = object
        }
    }

    override func didSelectItem(at index: Int) {
        sectionSelectionCompletion?()
        core.fire(event: Selected(item: envelopeSection.envelope))
    }

}

