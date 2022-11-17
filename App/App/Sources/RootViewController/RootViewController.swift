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

#if DEBUG

extension Calculator.Currency {

    static let zloty: Self = .init(
        name: "Zloty",
        img: "PL - Poland",
        code: "PLN",
        sending: 0...100,
        receiving: 0...100,
        defaultSending: 30
    )

    static let hryvna: Self = .init(
        name: "Hryvna",
        img: "UA - Ukraine",
        code: "UAH",
        sending: 0...300,
        receiving: 0...300,
        defaultSending: 40
    )

}

#endif

