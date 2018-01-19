//
//  HomeViewController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit
import Reactor
import IGListKit

final class HomeViewController: UIViewController, StoryboardInitializable {

    // MARK: Properties

    static var storyboardName = "Home"
    static var viewControllerIdentifier = "HomeNav"

    static func initialViewController() -> UINavigationController {
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let vc = storyboard.instantiateInitialViewController() as? UINavigationController else { fatalError("Error instantiating initial view controller from storyboard \(storyboardName)") }
        return vc
    }

    var core = App.sharedCore

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    @IBOutlet weak var newButton: RoundedButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var emptyStateView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: View life cycle

    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.darkText,
             NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32, weight: .thin)]
        adapter.collectionView = collectionView
        adapter.dataSource = self
        newButton.roundedEdgeType = .full
        collectionView.alwaysBounceVertical = true
        core.fire(command: LoadEnvelopes())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newButton.isShadowed = true
        core.add(subscriber: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }

    func envelopeTapped() {
        performSegue(withIdentifier: "showEnvelope", sender: self)
    }

}

// MARK: - IGListkit functions

extension HomeViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var objects = [ListDiffable]()
        let envelopes = core.state.envelopeState.envelopes
        objects.append(EnvelopeSection(id: 1, envelopes: envelopes))
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = EnvelopesSectionController()
        sectionController.sectionSelectionCompletion = {
            self.envelopeTapped()
        }
        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        if core.state.envelopeState.envelopesLoaded {
            return emptyStateView
        } else {
            return nil
        }
    }

}

extension HomeViewController: Subscriber {

    func update(with state: AppState) {
        if state.envelopeState.envelopesLoaded {
            activityIndicator.stopAnimating()
        }
        if core.state.envelopeState.envelopesLoaded {
            adapter.performUpdates(animated: true, completion: nil)
        }
    }
}
