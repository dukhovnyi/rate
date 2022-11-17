//
//  SendingViewController.ViewModel.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 17.11.2022.
//

import Foundation

extension Calculator.SendingViewController {

    struct ViewModel {

        var currencies = [Calculator.Currency]()
        var didSelect: ((Calculator.Currency) -> Void)?
    }
}
