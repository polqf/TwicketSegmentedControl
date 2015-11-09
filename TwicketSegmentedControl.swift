//
//  TwicketSegmentedControl.swift
//  Twicket
//
//  Created by Pol Quintana on 7/11/15.
//  Copyright © 2015 Pol Quintana. All rights reserved.
//

import UIKit

class TwicketSegmentedControl: UIView {
    static let height: CGFloat = 44
    var selectedIndex = 0 {
        didSet {
            segmentedControl.selectedSegmentIndex = selectedIndex
        }
    }
    
    lazy var segmentedControl: UISegmentedControl = { [unowned self] in
        let control = UISegmentedControl(items: ["Tweets", "Users"])
        control.frameWidth = self.frameWidth - Margin.m20
        control.centerX = self.frameWidth/2
        control.centerY = TwicketSegmentedControl.height/2
        control.tintColor = UIColor.whiteColor()
        return control
        }()
    
    init(width: CGFloat, initialIndex: Int = 0) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: TwicketSegmentedControl.height))
        addSubview(segmentedControl)
        backgroundColor = Color.mainBlueBackgroundColor
        selectedIndex = initialIndex
        segmentedControl.selectedSegmentIndex = selectedIndex
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}