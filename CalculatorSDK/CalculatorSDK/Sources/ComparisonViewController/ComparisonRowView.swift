//
//  ComparisonRowView.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 17.11.2022.
//

import CommonUI
import UIKit

extension Calculator {

    final class ComparisonRowView: View {

        var model: Model {
            didSet {
                updateUi()
            }
        }

        lazy var leftStackView = UIStackView.make(.vertical, spacing: 8)(
            label,
            currencyDropdown
        )
        let label = UILabel().make {
            $0.textColor = .init(hex: "#6C727A")
            $0.font = assetBuilder.font(face: .regular, size: 14)
            $0.text = "Sending from"
        }
        let currencyDropdown: CurrencyDropDownView

        lazy var rightStackView = UIStackView.make(.horizontal)(
            amount
        )
        let amount = UILabel().make {
            $0.textColor = .init(hex: "#000000")
            $0.font = assetBuilder.font(face: .bold, size: 32)
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        init(
            model: Model
        ) {
            self.model = model
            self.currencyDropdown = CurrencyDropDownView(
                model: .init(currency: model.currency, onTouch: model.onCurrencyChange)
            )

            super.init()
        }

        override func setup() {

            super.setup()

            addSubview(leftStackView)
            addSubview(rightStackView)
        }

        override func defineLayout() {

            super.defineLayout()

            var constraints = [NSLayoutConstraint](); defer { constraints.activate() }

            constraints += leftStackView.layoutInSuperview(edges: [.vertical, .leading], insets: .init(top: 16, left: 12, bottom: 16, right: 0))
            constraints += rightStackView.layoutInSuperview(edges: .trailing, insets: .init(top: 16, left: 0, bottom: 16, right: 12))
            constraints += rightStackView.layoutInSuperview(edges: .vertical, insets: .init(top: 32, left: 0, bottom: 32, right: 0), priority: .defaultHigh)
            constraints += rightStackView.layoutInSuperviewCenter(edges: .vertical)
            constraints += leftStackView.trailingAnchor.constraint(lessThanOrEqualTo: rightStackView.leadingAnchor)
        }

        func updateUi() {

            backgroundColor = model.kind == .sending ? .white : .clear
            label.text = model.kind == .sending ? "Sending from" : "Receiver gets"
            if let value = model.value {
                amount.text = "\(value)"
            } else {
                amount.text = "-"
            }
            if model.isValidInput {
                layer.borderWidth = 0
                amount.textColor = model.kind == .sending ? .init(hex: "#317FF5") : .init(hex: "#000000")
            } else {
                layer.borderColor = UIColor(hex: "#CC3F60")?.cgColor
                layer.borderWidth = 2
                amount.textColor = .init(hex: "#CC3F60")
            }
            currencyDropdown.model.currency = model.currency
        }

        // MARK: - Private

        private let formatter: NumberFormatter = {
            let _formatter = NumberFormatter()
            _formatter.numberStyle = .decimal
            return _formatter
        }()
    }
}

extension Calculator.ComparisonRowView {

    struct Model {

        typealias Currency = Calculator.Currency

        enum Kind { case sending, receiving }

        var kind = Kind.sending
        var currency: Currency
        var value: Float?
        var isValidInput = true

        var onCurrencyChange: (() -> Void)?
    }
}
