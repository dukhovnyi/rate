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

            contentView.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(endEditing)
                )
            )
            fetchFxRate()
            updateUi()
        }

        public func updateCurrencies(
            sending: Currency,
            receiving: Currency
        ) {
            viewModel.sending = sending
            viewModel.receiving = receiving
            fetchFxRate()
        }

        // MARK: - Private

        private var viewModel: ViewModel {
            didSet {
                updateUi()
            }
        }

        @objc func endEditing() {
            contentView.endEditing(true)
        }

        private func updateUi() {
            
            contentView.props = .init(
                from: .init(
                    kind: .sending,
                    currency: viewModel.sending,
                    value: viewModel.sendingValue,
                    isValidInput: viewModel.valueIsValid,
                    onCurrencyChange: { [weak self] in
                        self?.presentCurrencyChooser(currencyDidChange: { [weak self] newCurrency in
                            self?.viewModel.sending = newCurrency
                            self?.fetchFxRate()
                        })
                    }
                ),
                to: .init(
                    kind: .receiving,
                    currency: viewModel.receiving,
                    value: viewModel.receivingValue,
                    isValidInput: true,
                    onCurrencyChange: { [weak self] in
                        self?.presentCurrencyChooser(currencyDidChange: { [weak self] newCurrency in
                            self?.viewModel.receiving = newCurrency
                            self?.fetchFxRate()
                        })
                    }
                ),
                swap: { [weak self] in
                    
                    guard let self else { return }
                    
                    let from = self.viewModel.sending
                    let receivingValue = self.viewModel.receivingValue
                    self.viewModel.sending = self.viewModel.receiving
                    self.viewModel.receivingValue = self.viewModel.sendingValue
                    self.viewModel.receiving = from
                    self.viewModel.sendingValue = receivingValue ?? self.viewModel.sending.defaultSending

                    guard self.viewModel.checkLimits(sendingValue: self.viewModel.sendingValue) else { return }
                    self.fetchFxRate()
                },
                onAmountChanged: { [weak self] text in

                    guard
                        let self,
                        let newValue = Float(text)
                    else {
                        self?.viewModel.valueIsValid = false
                        self?.viewModel.receivingValue = nil
                        self?.contentView.sending.amount.amount.text = text
                        return
                    }

                    guard self.viewModel.sendingValue != newValue else { return }

                    self.viewModel.sendingValue = newValue
                    
                    guard self.viewModel.checkLimits(sendingValue: newValue) else { return }
                    self.fetchFxRate()
                },
                errorMessage: viewModel.errorMessage,
                fxRateState: viewModel.fxRateState
            )
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

        private func fetchFxRate() {

            viewModel.fxRateState = .loading

            viewModel.fetch { [weak self] result in

                DispatchQueue.main.async { [weak self] in

                    guard let self else { return }

                    switch result {

                    case .failure:
                        self.viewModel.fxRateState = .value("---")
                        self.viewModel.errorMessage = "Unexpected error occured. Please try again later."
                        self.viewModel.receivingValue = nil

                    case .success(let fxRate):
                        self.viewModel.fxRateState = .value("1 \(fxRate.from) ~ \(fxRate.rate) \(fxRate.to)")
                        self.viewModel.receivingValue = fxRate.toAmount
                    }
                }
            }
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
            _ amount: Float,
            _ completion: @escaping (Result<FxRate, Error>) -> Void
        ) -> Void

        let supportedCurrencies: [Currency]
        var sending: Currency
        var receiving: Currency
        var sendingValue: Float
        var receivingValue: Float?
        var valueIsValid = true
        var errorMessage = ""
        var fxRateState = Calculator.RateValueView.State.loading

        public let getFxRate: GetFxRate

        public init(
            from: Currency,
            to: Currency,
            supportedCurrencies: [Calculator.Currency],
            getFxRate: @escaping GetFxRate
        ) {
            self.sending = from
            self.sendingValue = from.defaultSending
            self.receiving = to
            self.supportedCurrencies = supportedCurrencies
            self.getFxRate = getFxRate
        }

        mutating func checkLimits(sendingValue: Float) -> Bool {
            guard
                sending.sendingRange.contains(sendingValue)
            else {
                self.valueIsValid = false
                self.receivingValue = nil
                let code = sending.code
                let max = sending.sendingRange.upperBound
                let min = sending.sendingRange.lowerBound

                self.errorMessage = sendingValue > sending.sendingRange.upperBound
                    ? "Maximum sending amount \(max) \(code)"
                    : "Minimum sending amount \(min) \(code)"
                return false
            }

            self.errorMessage = ""
            self.valueIsValid = true

            return true
        }

        func fetch(onComplete: @escaping (Result<FxRate, Error>) -> Void) {

            guard sendingValue > 0 else { return }

            getFxRate(
                sending,
                receiving,
                sendingValue,
                onComplete
            )
        }
    }
}
