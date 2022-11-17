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

        var model: Model

        let overlayView = UIView().make {

            $0.backgroundColor = .init(hex: "#EDF0F4")
            $0.layer.cornerRadius = 16
        }

        lazy var container = UIStackView.make(.vertical)(
            sending,
            receiving
        )

        let sending: ComparisonRowView
        let receiving: ComparisonRowView

        let rateValueView = RateValueView()
        let swapView: SwapView

        required init() {
            fatalError("init() has not been implemented")
        }
        
        init(
            model: Model
        ) {
            self.model = model

            self.sending = ComparisonRowView(model: model.from).make {
                $0.model.kind = .sending
                $0.layer.cornerRadius = 16
                $0.layer.shadowRadius = 16
                $0.layer.shadowColor = UIColor.black.cgColor
                $0.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
                $0.layer.shadowOpacity = 0.2
                $0.layer.masksToBounds = false
            }
            self.receiving = ComparisonRowView(model: model.to).make {
                $0.model.kind = .receiving
            }
            self.swapView = .init {
                model.onSwap?()
            }
            super.init()
        }

        public override func setup() {

            super.setup()

            addSubview(overlayView)
            overlayView.addSubview(container)
            overlayView.addSubview(rateValueView)
            overlayView.addSubview(swapView)
        }

        public override func defineLayout() {

            super.defineLayout()

            var constraints = [NSLayoutConstraint](); defer { constraints.activate() }

            constraints += overlayView.layoutInSuperview(
                insets: .init(top: 16, left: 20, bottom: 20, right: 16),
                priority: .defaultHigh
            )

            constraints += container.layoutInSuperview()
            constraints += sending.heightAnchor.constraint(equalTo: receiving.heightAnchor)
            constraints += rateValueView.layoutInSuperviewCenter()
            constraints += swapView.layoutInSuperviewCenter(edges: .vertical)
            constraints += swapView.layoutInSuperview(edges: .leading, insets: .init(top: 0, left: 44, bottom: 0, right: 0))
        }
    }
}

extension Calculator.ComparisonView {

    struct Model {
        let from: Calculator.ComparisonRowView.Model
        let to: Calculator.ComparisonRowView.Model
        let onSwap: (() -> Void)?
    }
}

extension Calculator.ComparisonView {

    final class SwapView: View {

        let container = UIView().make {
            $0.backgroundColor = .init(hex: "#317FF5")
            $0.layer.cornerRadius = 12
        }
        let image = UIImageView(image: assetBuilder.image(name: "swap"))

        required init() {
            fatalError("init() has not been implemented")
        }

        init(
            onSwap: @escaping () -> Void
        ) {
            self.onSwap = onSwap
            super.init()
        }

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
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            onSwap()
        }

        // MARK: - Private

        private let onSwap: () -> Void
    }
}
