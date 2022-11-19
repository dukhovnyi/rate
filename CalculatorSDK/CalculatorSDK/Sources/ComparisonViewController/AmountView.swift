//
//  AmountView.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 18.11.2022.
//

import CommonUI
import UIKit

extension Calculator {

    final class AmountView: View, UITextFieldDelegate {

        struct Props {
            var didChange: ((String) -> Void)?
        }

        var props = Props()

        let amount = UITextField().make {
            $0.accessibilityIdentifier = "amount-view-value"
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

        @objc func textFieldDidEndEditing(_ textField: UITextField) {
            props.didChange?(textField.text ?? "")
        }
    }
}
