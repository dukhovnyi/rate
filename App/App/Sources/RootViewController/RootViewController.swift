//
//  RootViewController.swift
//  App
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import CalculatorSDK
import CommonUI
import UIKit

final class RootViewController: ViewController<RootViewController.RootView> {

    override init() {

        self.calculator = Calculator()
        Calculator.register(assetBuilder: .default())

        super.init()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        contentView.sendButton.addTarget(
            self,
            action: #selector(sendButtonTouchUpInside),
            for: .touchUpInside
        )
    }

    // MARK: - Private

    private let calculator: Calculator

    @objc
    private func sendButtonTouchUpInside(_ sender: UIButton) {

        present(
            calculator.makeSendingViewController(),
            animated: true
        )
    }
}
