//
//  RootViewController.swift
//  Playbook
//
//  Created by Yurii Dukhovnyi on 19.11.2022.
//

import CommonUI
import CalculatorSDK
import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        guard
            let fromUrl = Bundle(for: RootViewController.self).url(forResource: "currency_from", withExtension: "json"),
            let toUrl = Bundle(for: RootViewController.self).url(forResource: "currency_to", withExtension: "json"),
            let fromData = try? Data(contentsOf: fromUrl),
            let toData = try? Data(contentsOf: toUrl)
        else {
            fatalError("mocks are not found.")
        }

        let from = try! JSONDecoder().decode(Calculator.Currency.self, from: fromData)
        let to = try! JSONDecoder().decode(Calculator.Currency.self, from: toData)

        Calculator.register(assetBuilder: .mock)
        let vc = calculator.makeComparisonViewController(
            viewModel: .init(
                from: from,
                to: to,
                supportedCurrencies: .mock,
                getFxRate: { from, to, amount, completion in
                    completion(
                        .success(.init(from: from.code, to: to.code, rate: 1.1, fromAmount: amount, toAmount: amount * 1.1))
                    )
                }
            )
        )

        view.addSubview(vc.contentView)
        vc.contentView.layoutIn(
            view.safeAreaLayoutGuide,
            edges: [.top, .horizontal]
        ).activate()
        addChild(vc)
    }

    // MARK: - Private

    private let calculator = Calculator()
}

extension AssetBuilder {

    static let mock: Self = .init(
        fontBuilder: { face, size in
            switch face {
            case .bold:
                return .boldSystemFont(ofSize: size)
            case .regular:
                return .systemFont(ofSize: size)
            }
        },
        imageBuilder: { .init(named: $0) }
    )
}
