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
        control.frame = self.bounds.insetBy(dx: Margin.m20, dy: Margin.m8 - Margin.m1)
        control.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        control.tintColor = UIColor.white()
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
    
    func setSegmentedControlItems(_ items: [String]) {
        segmentedControl.removeAllSegments()
        for (index, title) in items.enumerated() {
            segmentedControl.insertSegment(withTitle: title, at: index, animated: true)
        }
    }
    
    private func setup() {
        addSubview(segmentedControl)
        backgroundColor = Color.mainBlueBackgroundColor
        selectedIndex = 1
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentedControlValue), for: .valueChanged)
    }
    
    dynamic private func didChangeSegmentedControlValue() {
        delegate?.didSelect(index: segmentedControl.selectedSegmentIndex)
    }
}
