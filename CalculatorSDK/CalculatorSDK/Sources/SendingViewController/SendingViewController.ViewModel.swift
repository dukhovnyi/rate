//
//  SendingViewController.ViewModel.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 17.11.2022.
//

import Foundation

extension Calculator.SendingViewController {

    final class ViewModel {

        enum State {
            case loading, error, ready
        }

        var state = State.loading
        var currencies = [Calculator.Currency]()

        func fetchCurrencies() {

            guard
                let url = Bundle(for: Self.self).url(forResource: "preset", withExtension: "json"),
                let jsonData = try? Data(contentsOf: url),
                let currencies = try? JSONDecoder().decode([Calculator.Currency].self, from: jsonData)
            else {
                self.state = .error
                return
            }

            self.currencies = currencies
            self.state = .ready
        }
    }
}
