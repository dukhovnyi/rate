//
//  CurrencyDropDownView.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 17.11.2022.
//

import CommonUI
import UIKit

extension Calculator {

    final class CurrencyDropDownView: View {

        struct Props {
            var currency: Currency
            var onTap: (() -> Void)?
        }

        var props: Props = .init(currency: .mock) {
            didSet {
                updateUi()
            }
        }

        lazy var container = UIStackView.make(.horizontal, spacing: 8)(
            flagView,
            codeLabel,
            dropDownImage
        )

        let flagView = UIImageView()
        let codeLabel = UILabel().make {
            $0.font = assetBuilder.font(face: .bold, size: 14)
            $0.text = "Choose currency"
        }
        let dropDownImage = UIImageView(image: assetBuilder.image(name: "dropdown")).make {
            $0.contentMode = .center
        }

        override func setup() {

            super.setup()

            addSubview(container)
        }

        override func defineLayout() {

            super.defineLayout()

            var constraints = [NSLayoutConstraint](); defer { constraints.activate() }
            constraints += container.layoutInSuperview()
            constraints += flagView.match(value: 24)

            updateUi()
            addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(tap)
                )
            )
        }

        func updateUi() {
            flagView.image = assetBuilder.image(name: props.currency.img)
            codeLabel.text = props.currency.code.uppercased()
        }

        @objc private func tap() {
            props.onTap?()
        }
    }
}

