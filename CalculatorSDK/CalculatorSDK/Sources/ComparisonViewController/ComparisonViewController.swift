//
//  ComparisonViewController.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 17.11.2022.
//

import CommonUI
import UIKit

extension Calculator {

    public final class ComparisonViewController: ViewController<ComparisonView> {

        init(viewModel: ViewModel) {

            self.viewModel = viewModel
            super.init()
        }

        public override func viewDidLoad() {

            super.viewDidLoad()
            let gesture = UITapGestureRecognizer(
                target: self,
                action: #selector(changeCurrency)
            )
            gesture.numberOfTapsRequired = 1
            contentView.rateValueView.addGestureRecognizer(gesture)
            contentView.rateValueView.isUserInteractionEnabled = true
            self.gesture = gesture
        }

        var gesture: UITapGestureRecognizer?

        // MARK: - Private

        public override func loadView() {
            view = ComparisonView(
                model: .init(
                    from: .init(
                        kind: .sending,
                        currency: viewModel.from,
                        value: Float(viewModel.from.defaultSending),
                        isValidInput: true,
                        onCurrencyChange: { [weak self] in
                            self?.presentCurrencyChooser(currencyDidChange: { [weak self] newCurrency in
                                self?.viewModel.from = newCurrency
                            })
                        }
                    ),
                    to: .init(
                        kind: .receiving,
                        currency: viewModel.to,
                        value: nil,
                        isValidInput: true,
                        onCurrencyChange: { [weak self] in
                            self?.presentCurrencyChooser(currencyDidChange: { [weak self] newCurrency in
                                self?.viewModel.to = newCurrency
                            })
                        }
                    ),
                    onSwap: { [weak self] in

                        guard let self else { return }

                        let from = self.viewModel.from
                        self.viewModel.from = self.viewModel.to
                        self.viewModel.to = from
                    }
                )
            )

            updateUi()
        }

        private var viewModel: ViewModel {
            didSet {
                updateUi()
            }
        }

        @objc func changeCurrency(_ gesture: UITapGestureRecognizer) {
            contentView.sending.model.onCurrencyChange?()
        }

        private func updateUi() {

            contentView.rateValueView.state = .loading
            viewModel.getFxRate(viewModel.from, viewModel.to, 100) { [weak self] result in

                guard let self else { return }

                switch result {
                case .failure:
                    break

                case .success(let fxRate):
                    self.contentView.rateValueView.state = .value("1 \(fxRate.from) ~ \(fxRate.rate) \(fxRate.to)")
                    self.contentView.sending.model.currency = self.viewModel.supportedCurrencies.first(where: { $0.code == fxRate.from })!
                    self.contentView.sending.model.value = fxRate.fromAmount

                    self.contentView.receiving.model.currency = self.viewModel.supportedCurrencies.first(where: { $0.code == fxRate.to })!
                    self.contentView.receiving.model.value = fxRate.toAmount
                }
            }
        }

        private func presentCurrencyChooser(currencyDidChange: @escaping (Calculator.Currency) -> Void) {

            let viewController = SendingViewController(
                viewModel: .init(
                    currencies: .mock,
                    didSelect: currencyDidChange
                )
            )
            present(viewController, animated: true)
        }
    }
}

extension Calculator.ComparisonViewController {

    public struct ViewModel {

        public typealias Currency = Calculator.Currency
        public typealias FxRate = Calculator.FxRate

        public typealias GetFxRate = (
            _ from: Currency,
            _ to: Currency,
            _ amount: UInt,
            _ completion: @escaping (Result<FxRate, Error>) -> Void
        ) -> Void

        public let supportedCurrencies: [Currency]
        public var from: Currency
        public var to: Currency
        public let getFxRate: GetFxRate

        public init(
            from: Currency,
            to: Currency,
            supportedCurrencies: [Calculator.Currency],
            getFxRate: @escaping GetFxRate
        ) {
            self.from = from
            self.to = to
            self.supportedCurrencies = supportedCurrencies
            self.getFxRate = getFxRate
        }
    }
}
