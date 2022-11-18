//
//  RootViewController.swift
//  App
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import CalculatorSDK
import CommonKit
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

        let vc = calculator.makeComparisonViewController(
            viewModel: .init(
                from: .zloty,
                to: .hryvna,
                supportedCurrencies: .mock,
                getFxRate: { [weak self] from, to, amount, completion in

                    let req = ApiRequestBuilder.fxRate(
                        from: from.code,
                        to: to.code,
                        amount: amount
                    )

                    self?.cancellable?()

                    self?.cancellable = self?.api.request(req) { result in
                        completion(result)
                    }
                })
        )

        add(viewController: vc, toContainer: contentView.row)
    }

    // MARK: - Private

    private let calculator: Calculator
    private let api = Api.Live(baseUrl: .transferGo)
    private var cancellable: (() -> Void)?
}

extension Calculator.Currency {

    static let euro: Self = [Calculator.Currency].mock.first(where: { $0.code == "EUR" })!
    static let krone: Self = [Calculator.Currency].mock.first(where: { $0.code == "DKK" })!
    static let zloty: Self = [Calculator.Currency].mock.first(where: { $0.code == "PLN" })!
    static let hryvna: Self = [Calculator.Currency].mock.first(where: { $0.code == "UAH" })!
}

enum ApiRequestBuilder {

    static func fxRate(
        from: String,
        to: String,
        amount: Float
    ) -> Api.Request<Calculator.FxRate> {

        .init(
            .get,
            endpoint: .relative("/api/fx-rates"),
            query: [
                .init(name: "from", value: from),
                .init(name: "to", value: to),
                .init(name: "amount", value: "\(amount)")
            ]
        )
    }
}
