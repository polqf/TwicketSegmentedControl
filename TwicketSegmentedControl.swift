//
//  TwicketSegmentedControl.swift
//  Twicket
//
//  Created by Pol Quintana on 7/11/15.
//  Copyright © 2015 Pol Quintana. All rights reserved.
//

import UIKit

protocol TwicketSegmentedControlDelegate: class {
    func didSelect(index segmentIndex: Int)
}

class TwicketSegmentedControl: UIView {
    static let height: CGFloat = 44
    weak var delegate: TwicketSegmentedControlDelegate?
    var selectedIndex: Int {
        get { return segmentedControl.selectedSegmentIndex }
        set { segmentedControl.selectedSegmentIndex = newValue }
    }
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.frame = CGRectInset(self.bounds, Margin.m20, Margin.m8 - Margin.m1)
        control.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        control.tintColor = UIColor.whiteColor()
        return control
    }()
    
    init(width: CGFloat, items: [String] = [], selectedIndex: Int = 0) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: TwicketSegmentedControl.height))
        setup()
        setSegmentedControlItems(items)
        self.selectedIndex = selectedIndex
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setSegmentedControlItems(items: [String]) {
        segmentedControl.removeAllSegments()
        for (index, title) in items.enumerate() {
            segmentedControl.insertSegmentWithTitle(title, atIndex: index, animated: true)
        }
    }
    
    private func setup() {
        addSubview(segmentedControl)
        backgroundColor = Color.mainBlueBackgroundColor
        selectedIndex = 1
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentedControlValue), forControlEvents: .ValueChanged)
    }
    
    dynamic private func didChangeSegmentedControlValue() {
        delegate?.didSelect(index: segmentedControl.selectedSegmentIndex)
    }
}