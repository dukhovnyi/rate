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

        struct Model {
            var currency: Currency
            var onTouch: (() -> Void)?
        }

        var model: Model {
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

        required init() {
            fatalError("init() has not been implemented")
        }

        init(model: Model) {
            self.model = model
            super.init()
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
        }

        func updateUi() {
            flagView.image = assetBuilder.image(name: model.currency.img)
            codeLabel.text = model.currency.code.uppercased()
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)

            model.onTouch?()
        }
    }
}
