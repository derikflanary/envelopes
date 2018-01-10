//
//  ViewController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/6/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit
import Reactor

class ViewController: UIViewController {

    var core = App.sharedCore

    override func viewDidLoad() {
        super.viewDidLoad()
        core.fire(command: CreateNewUser(userId: "89898", networkAccess: FirebaseNetworkAccess.sharedAccess, completion: {
            print("success")
        }))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

