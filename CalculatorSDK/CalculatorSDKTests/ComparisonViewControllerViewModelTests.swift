//
//  ComparisonViewControllerViewModelTests.swift
//  CalculatorSDKTests
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import XCTest
@testable import CalculatorSDK

final class ComparisonViewControllerViewModelTests: XCTestCase {

    typealias ViewModel = Calculator.ComparisonViewController.ViewModel

    enum ViewModelCalls {
        case getFxRate
    }

    func testFetch__validValue() throws {

        var calls = [ViewModelCalls]()

        var vm = ViewModel(
            from: .mock(),
            to: .mock(),
            supportedCurrencies: .mock
        ) { from, to, amount, completion in

            calls.append(.getFxRate)
        }

        vm.sendingValue = 1

        vm.fetch(onComplete: { _ in })
        XCTAssertEqual(calls, [.getFxRate])
    }

    func testFetch__invalidValue() throws {

        var calls = [ViewModelCalls]()

        var vm = ViewModel(
            from: .mock(),
            to: .mock(),
            supportedCurrencies: .mock
        ) { from, to, amount, completion in

            calls.append(.getFxRate)
        }

        vm.sendingValue = -1

        vm.fetch(onComplete: { _ in })
        XCTAssertEqual(calls, [])
    }

    func testCheckLimits__validValue() throws {

        var vm = ViewModel(
            from: .mock(sending: 0 ... 5),
            to: .mock(),
            supportedCurrencies: .mock,
            getFxRate: { _, _, _, _ in }
        )

        XCTAssertEqual(
            vm.validate(sendingValue: 3),
            true
        )

        XCTAssertEqual(vm.errorMessage, "")
        XCTAssertEqual(vm.valueIsValid, true)
    }

    func testCheckLimits__outOfLimitsMax() throws {

        var vm = ViewModel(
            from: .mock(code: "TST", sending: 0 ... 5),
            to: .mock(),
            supportedCurrencies: .mock,
            getFxRate: { _, _, _, _ in }
        )

        XCTAssertEqual(
            vm.validate(sendingValue: 6),
            false
        )

        XCTAssertEqual(vm.errorMessage, "Maximum sending amount \(5.0) TST")
        XCTAssertEqual(vm.receivingValue, nil)
        XCTAssertEqual(vm.valueIsValid, false)
    }

    func testCheckLimits__outOfLimitsMin() throws {

        var vm = ViewModel(
            from: .mock(code: "TST", sending: 5 ... 10),
            to: .mock(),
            supportedCurrencies: .mock,
            getFxRate: { _, _, _, _ in }
        )

        XCTAssertEqual(
            vm.validate(sendingValue: 3),
            false
        )

        XCTAssertEqual(vm.errorMessage, "Minimum sending amount \(5.0) TST")
        XCTAssertEqual(vm.receivingValue, nil)
        XCTAssertEqual(vm.valueIsValid, false)
    }

    func testSwap() throws {

        let from: ViewModel.Currency = .mock(code: "FROM", sending: 5 ... 10)
        let to: ViewModel.Currency = .mock(code: "TO", sending: 5 ... 10)

        var vm = ViewModel(
            from: from,
            to: to,
            supportedCurrencies: .mock,
            getFxRate: { _, _, _, _ in }
        )
        vm.sendingValue = 3
        vm.receivingValue = 5

        vm.swap()

        XCTAssertEqual(vm.sending, to)
        XCTAssertEqual(vm.sendingValue, 5)
        XCTAssertEqual(vm.receiving, from)
        XCTAssertEqual(vm.receivingValue, 3)
    }
}
