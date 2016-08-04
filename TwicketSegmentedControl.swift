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

    lazy var segmentedControl: UISegmentedControl = UISegmentedControl()

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
        backgroundColor = Color.appGray
        setupSegmentedControl()
        selectedIndex = 1
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentedControlValue), for: .valueChanged)
    }

    private func setupSegmentedControl() {
        segmentedControl.frame = bounds.insetBy(dx: Margin.m20, dy: Margin.m8 - Margin.m1)
        segmentedControl.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        segmentedControl.tintColor = Color.appDarkGray
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.setTitleTextAttributes([
            NSFontAttributeName : Font.appMedium(15),
            NSForegroundColorAttributeName : Color.appDarkGray
            ], for: .normal)
    }

    dynamic private func didChangeSegmentedControlValue() {
        delegate?.didSelect(index: segmentedControl.selectedSegmentIndex)
    }
}
