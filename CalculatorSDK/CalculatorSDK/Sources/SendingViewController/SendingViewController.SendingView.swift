//
//  SendingViewController.SendingView.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import CommonUI
import UIKit

extension Calculator {

    final class SendingView: View {

        lazy var container: UIStackView = .make(.vertical) (
            handleViewContainer,
            titleLabel,
            tableView
        )
        let handleViewContainer = UIView()
        let handleView = UIView().make {
            $0.backgroundColor = .init(hex: "#E6E1E6")
            $0.layer.cornerRadius = 2
        }
        let titleLabel = UILabel().make {
            $0.text = "Sending to"
            $0.textAlignment = .center
            $0.font = assetBuilder.font(face: .bold, size: 24)
        }
        let tableView = UITableView()

        override func setup() {
            super.setup()

            addSubview(container)
            handleViewContainer.addSubview(handleView)

            backgroundColor = .white
        }

        override func defineLayout() {
            super.defineLayout()

            var constraints = [NSLayoutConstraint](); defer { constraints.activate() }

            constraints += container.layoutInSuperview()

            constraints += handleView.layoutInSuperviewCenter()
            constraints += handleView.match(.height, value: 4)
            constraints += handleView.match(.width, value: 32)
            constraints += handleViewContainer.match(.height, value: 32)
        }
    }
}

