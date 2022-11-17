//
//  SendingViewController.Cell.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 17.11.2022.
//

import CommonUI
import UIKit

extension Calculator {

    final class SendingViewControllerCell: TableViewCell {

        static let reuseIdentifier = String(describing: SendingViewControllerCell.self)

        var currency: Currency? {
            didSet {
                updateUi()
                updateConstraintsIfNeeded()
            }
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            currency = nil
        }

        lazy var container = UIStackView.make(.horizontal, spacing: 16)(
            flagContainer,
            contentContainer
        )
        let flagContainer = UIView().make {
            $0.backgroundColor = .init(hex: "#EDF0F4")
            $0.layer.cornerRadius = 24
        }
        let flagImageView = UIImageView()

        lazy var contentContainer = UIStackView.make(.vertical, spacing: 4)(
            titleLabel,
            descriptionLabel
        )
        let titleLabel = UILabel().make {
            $0.text = "title"
            $0.font = assetBuilder.font(face: .bold, size: 14)
            $0.textColor = .init(hex: "#000000")
        }
        let descriptionLabel = UILabel().make {
            $0.text = "description"
            $0.font = assetBuilder.font(face: .regular, size: 14)
            $0.textColor = .init(hex: "#6C727A")
        }

        func updateUi() {

            titleLabel.text = currency?.code
            descriptionLabel.text = "\(currency?.name ?? "") • \(currency?.code ?? "")"
            if let img = currency?.img {
                flagImageView.image = assetBuilder.image(name: img)
            }
        }

        override func setup() {
            super.setup()

            addSubview(container)
            flagContainer.addSubview(flagImageView)
        }

        override func defineLayout() {
            super.defineLayout()

            var constraints = [NSLayoutConstraint](); defer { constraints.activate() }
            constraints += flagContainer.match(value: 48, priority: .defaultHigh)
            constraints += flagImageView.layoutInSuperviewCenter()
            constraints += container.layoutInSuperview(insets: .init(top: 8, left: 16, bottom: 8, right: 16))
        }
    }
}

