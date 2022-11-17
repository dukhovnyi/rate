//
//  TableHeaderView.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 17.11.2022.
//

import CommonUI
import UIKit

final class TableHeaderView: View {

    let header = UIView().make {
        $0.backgroundColor = .white.withAlphaComponent(0.8)
    }
    let titleLabel = UILabel().make {
        $0.text = "All countries"
        $0.font = assetBuilder.font(
            face: .bold,
            size: 16
        )
    }

    init(
        model: Model
    ) {
        self.model = model
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func setup() {
        super.setup()

        addSubview(header)
        header.addSubview(titleLabel)
    }

    override func defineLayout() {
        super.defineLayout()

        var constraints = [NSLayoutConstraint](); defer { constraints.activate() }

        constraints += header.layoutInSuperview()
        constraints += titleLabel.layoutInSuperview(
            insets: .init(top: 8, left: 16, bottom: 8, right: 0)
        )

        updateUi()
    }

    func updateUi() {

        titleLabel.text = model.title
    }

    // MARK: - Private

    private let model: Model
}

extension TableHeaderView {

    struct Model {
        
        let title: String
    }
}
