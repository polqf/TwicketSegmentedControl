//
//  ViewController.swift
//  TwicketSegmentedControlDemo
//
//  Created by Pol Quintana on 17/09/16.
//  Copyright © 2016 Pol Quintana. All rights reserved.
//

import UIKit
import TwicketSegmentedControl

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let titles = ["First", "Second", "Third"]
        let frame = CGRect(x: 5, y: view.frame.height / 2 - 20, width: view.frame.width - 10, height: 40)

        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)

        view.addSubview(segmentedControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

