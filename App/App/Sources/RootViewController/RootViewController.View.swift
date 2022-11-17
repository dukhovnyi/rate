//
//  RootViewController.View.swift
//  App
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import CommonUI
import UIKit

extension RootViewController {

    final class RootView: View {

        let contentView = UIView()

        let row = UIView()

        let requestButton = UIButton(type: .system).make {
            $0.setTitleColor(.darkGray, for: .normal)
            $0.backgroundColor = .init(hex: "#EDF0F4")
            $0.setTitle("Request", for: .normal)
            $0.setImage(.init(named: "arrow-down"), for: .normal)
            $0.tintColor = .darkGray
            $0.titleLabel?.font = .interOrDefault(face: .bold, size: 16)
            $0.imageEdgeInsets = .init(top: 0, left: -32, bottom: 0, right: 0)
            $0.layer.cornerRadius = 12
            $0.isEnabled = false
        }
        let sendButton = UIButton(type: .system).make {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .init(hex: "#317FF5")
            $0.setTitle("Send", for: .normal)
            $0.tintColor = .white
            $0.setImage(.init(named: "arrow-up"), for: .normal)
            $0.titleLabel?.font = .interOrDefault(face: .bold, size: 16)
            $0.imageEdgeInsets = .init(top: 0, left: -32, bottom: 0, right: 0)
            $0.layer.cornerRadius = 12
        }
        lazy var buttonsStack = UIStackView.make(.horizontal, spacing: 16, distribution: .fillEqually)(
           requestButton,
           sendButton
       )

        override func setup() {
            super.setup()
            addSubview(contentView)
            contentView.addSubview(row)
            addSubview(buttonsStack)
        }

        override func defineLayout() {
            super.defineLayout()

            backgroundColor = .white
            var constraints = [NSLayoutConstraint](); defer { constraints.activate() }

            constraints += contentView.layoutInSuperview()
            constraints += buttonsStack.layoutIn(
                safeAreaLayoutGuide,
                edges: .horizontal,
                insets: .init(top: 0, left: 16, bottom: 16, right: 16)
            )
            constraints += buttonsStack.layoutIn(
                safeAreaLayoutGuide,
                edges: .bottom,
                insets: .init(top: 0, left: 0, bottom: 16, right: 0)
            )
            constraints += buttonsStack.match(.height, value: 48)

            constraints += row.layoutIn(safeAreaLayoutGuide, edges: [.horizontal, .top])
        }
    }
}
