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

        var props: Props = .mock {
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
        let currencyDropdown = CurrencyDropDownView()

        lazy var rightStackView = UIStackView.make(.horizontal)(
            amount
        )
        let amount = AmountView()

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

            backgroundColor = props.kind == .sending ? .white : .clear
            label.text = props.kind == .sending ? "Sending from" : "Receiver gets"
            if let value = props.value {
                amount.amount.text = String(format: "%.2f", value)
            } else {
                amount.amount.text = "-"
            }
            if props.isValidInput {
                layer.borderWidth = 0
                amount.amount.textColor = props.kind == .sending ? .init(hex: "#317FF5") : .init(hex: "#000000")
            } else {
                layer.borderColor = UIColor(hex: "#CC3F60")?.cgColor
                layer.borderWidth = 2
                amount.amount.textColor = .init(hex: "#CC3F60")
            }
            amount.props.didChange = props.onAmountChanged
            currencyDropdown.props.currency = props.currency
            currencyDropdown.props.onTap = props.onCurrencyChange
        }
    }
}

extension Calculator.ComparisonRowView {

    struct Props {

        typealias Currency = Calculator.Currency

        enum Kind { case sending, receiving }

        var kind = Kind.sending
        var currency: Currency
        var value: Float?
        var isValidInput = true

        var onCurrencyChange: (() -> Void)?
        var onAmountChanged: ((String) -> Void)?

        static let mock: Self = .init(currency: .mock)
    }
}

extension Calculator {

    final class AmountView: View, UITextFieldDelegate {

        struct Props {
            var didChange: ((String) -> Void)?
        }

        var props = Props()

        let amount = UITextField().make {
            $0.keyboardType = .numberPad
            $0.autocorrectionType = .no
            $0.textColor = .init(hex: "#000000")
            $0.font = assetBuilder.font(face: .bold, size: 32)
        }

        override func setup() {

            super.setup()
            addSubview(amount)
            amount.delegate = self
        }

        override func defineLayout() {

            super.defineLayout()

            var constraints = [NSLayoutConstraint](); defer { constraints.activate() }
            constraints += amount.layoutInSuperview()
        }

        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            guard action != #selector(self.paste(_:)) else {
                return false
            }
            return super.canPerformAction(action, withSender: sender)
        }


        @objc func textFieldDidEndEditing(_ textField: UITextField) {
            props.didChange?(textField.text ?? "")
        }
    }
}
