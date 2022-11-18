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

    typealias Pair = (Calculator.Currency, Calculator.Currency)

    override init() {

        self.calculator = Calculator()
        Calculator.register(assetBuilder: .default())

        super.init()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        contentView.tableView.dataSource = self

        dataSource.append(contentsOf: [
            (.zloty, .hryvna),
            (.euro, .krone),
            (.pound, .kuna),
        ])
    }

    // MARK: - Private

    private let calculator: Calculator
    private let api = Api.Live(baseUrl: .transferGo)

    private var dataSource = [Pair]()
}

extension RootViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let pair = dataSource[indexPath.row]
        add(
            viewController: makeComparisonViewController(pair),
            toContainer: cell.contentView
        )
        return cell
    }

    private func makeComparisonViewController(
        _ pair: Pair
    ) -> Calculator.ComparisonViewController {

        var cancellable: (() -> Void)?

        return calculator.makeComparisonViewController(
            viewModel: .init(
                from: pair.0,
                to: pair.1,
                supportedCurrencies: .mock,
                getFxRate: { [weak self] from, to, amount, completion in

                    let req = ApiRequestBuilder.fxRate(
                        from: from.code,
                        to: to.code,
                        amount: amount
                    )

                    cancellable?()

                    cancellable = self?.api.request(req) { result in
                        completion(result)
                    }
                })
        )
    }
}

extension Calculator.Currency {

    static let euro: Self = [Calculator.Currency].mock.first(where: { $0.code == "EUR" })!
    static let krone: Self = [Calculator.Currency].mock.first(where: { $0.code == "DKK" })!
    static let zloty: Self = [Calculator.Currency].mock.first(where: { $0.code == "PLN" })!
    static let hryvna: Self = [Calculator.Currency].mock.first(where: { $0.code == "UAH" })!
    static let pound: Self = [Calculator.Currency].mock.first(where: { $0.code == "GBP" })!
    static let kuna: Self = [Calculator.Currency].mock.first(where: { $0.code == "HRK" })!
}
