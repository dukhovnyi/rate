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

        let vc = calculator.makeComparisonViewController(
            viewModel: .init(
                from: .zloty,
                to: .hryvna,
                supportedCurrencies: .mock,
                getFxRate: { from, to, amount, completion in

                    var components = URLComponents(string: "https://my.transfergo.com/api/fx-rates")
                    components?.queryItems = [
                        .init(name: "from", value: from.code),
                        .init(name: "to", value: to.code),
                        .init(name: "amount", value: "\(amount)")
                    ]

                    guard
                        let url = components?.url,
                        let jsonData = try? Data(contentsOf: url),
                        let fxRate = try? JSONDecoder().decode(Calculator.FxRate.self, from: jsonData)
                    else {
                        completion(.failure(URLError(_nsError: .init())))
                        return
                    }

                    completion(.success(fxRate))
                })
        )

        add(viewController: vc, toContainer: contentView.row)
    }

    // MARK: - Private

    private let calculator: Calculator
}

extension Calculator.Currency {

    static let zloty: Self = [Calculator.Currency].mock.first(where: { $0.code == "PLN" })!
    static let hryvna: Self = [Calculator.Currency].mock.first(where: { $0.code == "UAH" })!

}
