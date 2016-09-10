//
//  TwicketSegmentedControl.swift
//  Twicket
//
//  Created by Pol Quintana on 7/11/15.
//  Copyright © 2015 Pol Quintana. All rights reserved.
//

import UIKit

protocol TwicketSegmentedControlDelegate: class {
    func didSelect(_ segmentIndex: Int)
}

open class TwicketSegmentedControl: UIControl {
    static let height: CGFloat = Constants.height + Constants.topBottomMargin * 2

    struct Constants {
        static let height: CGFloat = 30
        static let topBottomMargin: CGFloat = 5
        static let leadingTrailingMargin: CGFloat = 10
    }

    class SliderView: UIView {
        // MARK: - Properties
        fileprivate let sliderMaskView = UIView()

        var cornerRadius: CGFloat! {
            didSet {
                layer.cornerRadius = cornerRadius
                sliderMaskView.layer.cornerRadius = cornerRadius
            }
        }

        override var frame: CGRect {
            didSet {
                sliderMaskView.frame = frame
            }
        }

        override var center: CGPoint {
            didSet {
                sliderMaskView.center = center
            }
        }

        init() {
            super.init(frame: .zero)
            setup()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }

        private func setup() {
            layer.masksToBounds = true
            sliderMaskView.backgroundColor = .black
            sliderMaskView.addShadow(with: .black)
        }
    }

    weak var delegate: TwicketSegmentedControlDelegate?

    open var defaultTextColor: UIColor = Color.appDarkGray40 {
        didSet {
            updateLabelsColor(with: defaultTextColor, selected: false)
        }
    }

    open var highlightTextColor: UIColor = .white {
        didSet {
            updateLabelsColor(with: highlightTextColor, selected: true)
        }
    }

    open var segmentsBackgroundColor: UIColor = Color.appGray70 {
        didSet {
            backgroundView.backgroundColor = backgroundColor
        }
    }

    open var sliderBackgroundColor: UIColor = Color.appSecondaryColor {
        didSet {
            selectedContainerView.backgroundColor = sliderBackgroundColor
        }
    }

    open var font: UIFont = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium) {
        didSet {
            updateLabelsFont(with: font)
        }
    }

    open var selectedSegmentIndex: Int = 0 {
        didSet {
            move(to: selectedSegmentIndex)
        }
    }

    fileprivate var segments: [String] = []

    fileprivate var numberOfSegments: Int {
        return segments.count
    }

    fileprivate var segmentWidth: CGFloat {
        return self.backgroundView.frame.width / CGFloat(numberOfSegments)
    }

    fileprivate var correction: CGFloat = 0

    fileprivate lazy var containerView: UIView = UIView()
    fileprivate lazy var backgroundView: UIView = UIView()
    fileprivate lazy var selectedContainerView: UIView = UIView(frame: .zero)
    fileprivate lazy var sliderView: SliderView = SliderView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    fileprivate func setup() {
        addSubview(containerView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(selectedContainerView)
        containerView.addSubview(sliderView)

        selectedContainerView.layer.mask = sliderView.sliderMaskView.layer
        addTapGesture()
        addDragGesture()
    }

    public func setSegmentItems(_ segments: [String]) {
        guard !segments.isEmpty else { fatalError("Segments array cannot be empty") }

        self.segments = segments
        configureViews()

        clearLabels()

        for (index, title) in segments.enumerated() {
            let baseLabel = createLabel(with: title, at: index, selected: false)
            let selectedLabel = createLabel(with: title, at: index, selected: true)
            backgroundView.addSubview(baseLabel)
            selectedContainerView.addSubview(selectedLabel)
        }
    }

    fileprivate func configureViews() {
        containerView.frame = bounds
        let insets = UIEdgeInsets(top: Constants.topBottomMargin,
                                  left: Constants.leadingTrailingMargin,
                                  bottom: Constants.topBottomMargin,
                                  right: Constants.leadingTrailingMargin)
        let frame = UIEdgeInsetsInsetRect(bounds, insets)
        backgroundView.frame = frame
        selectedContainerView.frame = frame
        sliderView.frame = CGRect(x: 0, y: 0, width: segmentWidth, height: backgroundView.frame.height)

        let cornerRadius = backgroundView.frame.height / 2
        [backgroundView, selectedContainerView].forEach { $0.layer.cornerRadius = cornerRadius }
        sliderView.cornerRadius = cornerRadius

        backgroundColor = Color.appPureWhite
        backgroundView.backgroundColor = segmentsBackgroundColor
        selectedContainerView.backgroundColor = sliderBackgroundColor

        selectedContainerView.addShadow(with: sliderBackgroundColor)
    }

    // MARK: Labels

    fileprivate func clearLabels() {
        backgroundView.subviews.forEach { $0.removeFromSuperview() }
        selectedContainerView.subviews.forEach { $0.removeFromSuperview() }
    }

    fileprivate func createLabel(with text: String, at index: Int, selected: Bool) -> UILabel {
        let rect = CGRect(x: CGFloat(index) * segmentWidth, y: 0, width: segmentWidth, height: backgroundView.frame.height)
        let label = UILabel(frame: rect)
        label.text = text
        label.textAlignment = .center
        label.textColor = selected ? highlightTextColor : defaultTextColor
        label.font = font
        return label
    }

    fileprivate func updateLabelsColor(with color: UIColor, selected: Bool) {
        let containerView = selected ? selectedContainerView : backgroundView
        containerView.subviews.forEach { ($0 as? UILabel)?.textColor = color }
    }

    fileprivate func updateLabelsFont(with font: UIFont) {
        selectedContainerView.subviews.forEach { ($0 as? UILabel)?.font = font }
        backgroundView.subviews.forEach { ($0 as? UILabel)?.font = font }
    }

    // MARK: Tap gestures

    fileprivate func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }

    fileprivate func addDragGesture() {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        sliderView.addGestureRecognizer(drag)
    }

    @objc fileprivate func didTap(tapGesture: UITapGestureRecognizer) {
        moveToNearestPoint(basedOn: tapGesture)
    }

    @objc fileprivate func didPan(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .cancelled, .ended, .failed:
            moveToNearestPoint(basedOn: panGesture)
        case .began:
            correction = panGesture.location(in: sliderView).x - sliderView.frame.width/2
        case .changed:
            let location = panGesture.location(in: self)
            sliderView.center.x = location.x - correction
        case .possible: ()
        }
    }

    // MARK: Slider position

    fileprivate func moveToNearestPoint(basedOn gesture: UIGestureRecognizer) {
        let location = gesture.location(in: self)
        let index = segmentIndex(for: location)
        move(to: index)
        delegate?.didSelect(index)
    }

    open func move(to index: Int) {
        let correctOffset = center(at: index)
        animate(to: correctOffset)

        selectedSegmentIndex = index
    }

    fileprivate func segmentIndex(for point: CGPoint) -> Int {
        let index = Int(point.x / sliderView.frame.width)
        return index > numberOfSegments - 1 ? numberOfSegments - 1 : index
    }

    fileprivate func center(at index: Int) -> CGFloat {
        let xOffset = CGFloat(index) * sliderView.frame.width + sliderView.frame.width / 2
        return xOffset
    }
    
    fileprivate func animate(to position: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.sliderView.center.x = position
        }
    }
}

fileprivate extension UIView {
    func addShadow(with color: UIColor) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}
