//
//  SwapView.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 19.11.2022.
//

import CommonUI
import UIKit

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

        required init() {
            super.init()
            accessibilityIdentifier = "swap-view"
            accessibilityTraits = .button
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
