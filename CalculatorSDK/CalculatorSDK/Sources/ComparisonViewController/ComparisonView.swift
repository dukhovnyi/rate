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
            top,
            bottom
        )

        let top: ComparisonRowView
        let bottom: ComparisonRowView

        let rateValueView = RateValueView()

        required init() {
            fatalError("init() has not been implemented")
        }
        
        init(
            model: Model
        ) {
            self.model = model

            self.top = ComparisonRowView(model: model.from).make {
                $0.model.kind = .sending
                $0.layer.cornerRadius = 16
                $0.layer.shadowRadius = 16
                $0.layer.shadowColor = UIColor.black.cgColor
                $0.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
                $0.layer.shadowOpacity = 0.2
                $0.layer.masksToBounds = false
            }
            self.bottom = ComparisonRowView(model: model.to).make {
                $0.model.kind = .receiving
            }

            super.init()
        }

        public override func setup() {

            super.setup()

            addSubview(overlayView)
            overlayView.addSubview(container)
            overlayView.addSubview(rateValueView)
        }

        public override func defineLayout() {

            super.defineLayout()

            var constraints = [NSLayoutConstraint](); defer { constraints.activate() }

            constraints += overlayView.layoutInSuperview(
                insets: .init(top: 16, left: 20, bottom: 20, right: 16),
                priority: .defaultHigh
            )

            constraints += container.layoutInSuperview()
            constraints += top.heightAnchor.constraint(equalTo: bottom.heightAnchor)
            constraints += rateValueView.layoutInSuperviewCenter()
        }
    }
}

extension Calculator.ComparisonView {

    struct Model {
        let from: Calculator.ComparisonRowView.Model
        let to: Calculator.ComparisonRowView.Model
    }
}
