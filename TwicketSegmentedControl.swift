//
//  TwicketSegmentedControl.swift
//  Twicket
//
//  Created by Pol Quintana on 7/11/15.
//  Copyright © 2015 Pol Quintana. All rights reserved.
//

import UIKit

protocol TwicketSegmentedControlDelegate: class {
    func didSelectSegmentIndex(segmentIndex: Int)
}

class TwicketSegmentedControl: UIView {
    static let height: CGFloat = 44
    weak var delegate: TwicketSegmentedControlDelegate?
    var selectedIndex = 0 {
        didSet {
            segmentedControl.selectedSegmentIndex = selectedIndex
        }
    }
    var items: [String] = []
    
    lazy var segmentedControl: UISegmentedControl = { [unowned self] in
        let control = UISegmentedControl(items: self.items)
        control.frameWidth = self.frameWidth - Margin.m20
        control.centerX = self.frameWidth/2
        control.centerY = TwicketSegmentedControl.height/2
        control.tintColor = UIColor.whiteColor()
        return control
    }()
    
    init(width: CGFloat, items: [String], delegate: TwicketSegmentedControlDelegate, initialIndex: Int = 0) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: TwicketSegmentedControl.height))
        self.items = items
        addSubview(segmentedControl)
        backgroundColor = Color.mainBlueBackgroundColor
        self.delegate = delegate
        selectedIndex = initialIndex
        segmentedControl.selectedSegmentIndex = selectedIndex
        segmentedControl.addTarget(self, action: "didChangeSegmentedControlValue", forControlEvents: .ValueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didChangeSegmentedControlValue() {
        delegate?.didSelectSegmentIndex(segmentedControl.selectedSegmentIndex)
    }
}