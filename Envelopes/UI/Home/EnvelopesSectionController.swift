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

    var envelopes: [Envelope]
    var id: Int

    init(id: Int, envelopes: [Envelope]) {
        self.id = id
        self.envelopes = envelopes
    }

    public func diffIdentifier() -> NSObjectProtocol {
        return NSNumber(integerLiteral: id)
    }

    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? EnvelopeSection else { return false }
        return envelopes == other.envelopes
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
        return envelopeSection.envelopes.count
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let collectionContext = collectionContext else { return .zero }
        let width = floor(collectionContext.containerSize.width/2) - 16
        let height: CGFloat = width * 1.0
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: EnvelopeCell.reuseIdentifier, bundle: nil, for: self, at: index) as! EnvelopeCell
        let envelope = envelopeSection.envelopes[index]
        cell.configure(with: envelope)
        return cell
    }

    override func didUpdate(to object: Any) {
        if let object = object as? EnvelopeSection {
            envelopeSection = object
        }
    }

    override func didSelectItem(at index: Int) {
        sectionSelectionCompletion?()
        let envelope = envelopeSection.envelopes[index]
        core.fire(event: Selected(item: envelope))
        core.fire(command: LoadExpenses(for: envelope))
        core.fire(command: LoadDeposits(for: envelope))
    }

}

