//
//  ComparisonView.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 17.11.2022.
//

import CommonUI
import UIKit

extension Calculator {

    public final class ComparisonView: View {

        var props: Props = .init() {
            didSet {
                updateUi()
            }
        }

        lazy var containerStackView = UIStackView.make(.vertical, spacing: 24)(
            overlayView,
            errorStack
        )

        let overlayView = UIView().make {
            $0.backgroundColor = .init(hex: "#EDF0F4")
            $0.layer.cornerRadius = 16
        }

        lazy var container = UIStackView.make(.vertical)(
            sending,
            receiving
        )

        let sending = ComparisonRowView().make {
            $0.props.kind = .sending
            $0.layer.cornerRadius = 16
            $0.layer.shadowRadius = 16
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            $0.layer.shadowOpacity = 0.2
            $0.layer.masksToBounds = false
        }
        let receiving = ComparisonRowView().make {
            $0.props.kind = .receiving
            $0.amount.isUserInteractionEnabled = false
        }

        let rateValueView = RateValueView()
        let swapView: SwapView = .init()

        lazy var errorStack = UIStackView.make(.horizontal, spacing: 6)(
            errorImage,
            errorLabel
        ).make {
            $0.isHidden = true
        }

        let errorImage = UIImageView().make {
            $0.image = assetBuilder.image(name: "validation-error")
            $0.contentMode = .center
        }
        let errorLabel = UILabel().make {
            $0.textColor = .init(hex: "#E5476D")
            $0.font = assetBuilder.font(face: .regular, size: 14)
            $0.numberOfLines = 0
        }

        public override func setup() {

            super.setup()

            addSubview(containerStackView)
            overlayView.addSubview(container)
            overlayView.addSubview(rateValueView)
            overlayView.addSubview(swapView)
        }

        public override func defineLayout() {

            super.defineLayout()

            var constraints = [NSLayoutConstraint](); defer { constraints.activate() }

            constraints += containerStackView.layoutInSuperview(
                insets: .init(top: 16, left: 20, bottom: 20, right: 16),
                priority: .init(999)
            )

            constraints += container.layoutInSuperview()
            constraints += sending.heightAnchor.constraint(equalTo: receiving.heightAnchor)
            constraints += rateValueView.layoutInSuperviewCenter()
            constraints += swapView.layoutInSuperviewCenter(edges: .vertical)
            constraints += swapView.layoutInSuperview(edges: .leading, insets: .init(top: 0, left: 44, bottom: 0, right: 0))
            constraints += errorImage.match(value: 12, priority: .defaultLow)
        }

        func updateUi() {
            sending.props = props.from
            sending.props.onAmountChanged = props.onAmountChanged
            receiving.props = props.to
            swapView.props.tap = props.swap

            errorStack.isHidden = props.errorMessage.isEmpty
            errorLabel.text = props.errorMessage

            rateValueView.state = props.fxRateState
        }
    }
}

extension Calculator.ComparisonView {

    struct Props {
        var from: Calculator.ComparisonRowView.Props = .init(currency: .mock())
        var to: Calculator.ComparisonRowView.Props = .init(currency: .mock())
        var swap: (() -> Void)? = nil
        var onAmountChanged: ((String) -> Void)? = nil
        var errorMessage = ""
        var fxRateState = Calculator.RateValueView.State.loading
    }
}

extension Calculator.ComparisonView {

    final class SwapView: View {

        struct Props {
            var tap: (() -> Void)?
        }

        var props = Props()

        let container = UIView().make {
            $0.backgroundColor = .init(hex: "#317FF5")
            $0.layer.cornerRadius = 12
        }
        let image = UIImageView(image: assetBuilder.image(name: "swap"))

        override func setup() {

            super.setup()

            container.addSubview(image)
            addSubview(container)
        }

        override func defineLayout() {

            super.defineLayout()

            var constraints = [NSLayoutConstraint](); defer { constraints.activate() }
            constraints += container.layoutInSuperview()
            constraints += image.layoutInSuperview(insets: .init(top: 4, left: 4, bottom: 4, right: 4))
            constraints += image.match(value: 16)

            addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(tap)
                )
            )
        }

        // MARK: - Private

        @objc private func tap() {
            props.tap?()
        }
    }
}
