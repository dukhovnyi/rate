//
//  RateValueView.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 17.11.2022.
//

import CommonUI
import UIKit

extension Calculator {

    final class RateValueView: View {

        enum State: Equatable {
            case loading, value(String)

            static func ==(lhs: Self, rhs: Self) -> Bool {

                switch (lhs, rhs) {

                case (.loading, .loading):
                    return true

                case (.value(let lhsValue), .value(let rhsValue)):
                    return lhsValue == rhsValue

                default:
                    return false
                }
            }
        }

        var state = State.loading {
            didSet {
                updateUi()
            }
        }

        let overlay = UIView().make {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 16
        }
        let activityIndicator = UIActivityIndicatorView().make {
            $0.style = .medium
            $0.color = .white
            $0.startAnimating()
        }

        let rateLabel = UILabel().make {
            $0.font = assetBuilder.font(face: .bold, size: 10)
            $0.textColor = .white
        }

        override func setup() {

            super.setup()

            addSubview(overlay)
            overlay.addSubview(activityIndicator)
            overlay.addSubview(rateLabel)
        }

        override func defineLayout() {

            super.defineLayout()

            var constraints = [NSLayoutConstraint](); defer { constraints.activate() }

            constraints += overlay.layoutInSuperview()
            indicatorConstraints = activityIndicator.layoutInSuperview(insets: .init(top: 8, left: 8, bottom: 8, right: 8))
            rateLabelConstraints = rateLabel.layoutInSuperview(insets: .init(top: 8, left: 8, bottom: 8, right: 8))

            updateUi()
        }

        func updateUi() {

            switch state {

            case .value(let value):
                rateLabel.text = value
                rateLabel.isHidden = false
                activityIndicator.isHidden = true
                indicatorConstraints.deactivate()
                rateLabelConstraints.activate()

            case .loading:
                rateLabel.isHidden = true
                activityIndicator.isHidden = false
                indicatorConstraints.activate()
                rateLabelConstraints.deactivate()
            }

            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.layoutIfNeeded()
            }
        }

        // MARK: - Private

        private var indicatorConstraints = [NSLayoutConstraint]()
        private var rateLabelConstraints = [NSLayoutConstraint]()
    }
}
