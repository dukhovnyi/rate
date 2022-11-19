//
//  PlaybookUITests.swift
//  PlaybookUITests
//
//  Created by Yurii Dukhovnyi on 19.11.2022.
//

import CalculatorSDK
import XCTest

final class PlaybookUITests: XCTestCase {

    let from: Calculator.Currency = {
        let fromUrl = Bundle(for: PlaybookUITests.self).url(forResource: "currency_from", withExtension: "json")!
        let fromData = try! Data(contentsOf: fromUrl)
        return try! JSONDecoder().decode(Calculator.Currency.self, from: fromData)
    }()
    let to: Calculator.Currency = {
        let toUrl = Bundle(for: PlaybookUITests.self).url(forResource: "currency_to", withExtension: "json")!
        let toData = try! Data(contentsOf: toUrl)
        return try! JSONDecoder().decode(Calculator.Currency.self, from: toData)
    }()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testDefault() throws {

        let app = XCUIApplication()
        app.launch()

        XCTAssert(app.staticTexts["Sending from"].exists)
        XCTAssert(app.staticTexts["Receiver gets"].exists)

        let receivingValue = from.defaultSending * 1.1

        XCTAssert(app.staticTexts["row-sending"].staticTexts["currency-code"].label == from.code)
        XCTAssert((app.staticTexts["row-sending"].textFields["amount-view-value"].value as? String) == String(format: "%.2f", from.defaultSending))
        XCTAssert(app.staticTexts["row-receiving"].staticTexts["currency-code"].label == to.code)
        XCTAssert((app.staticTexts["row-receiving"].textFields["amount-view-value"].value as? String) == String(format: "%.2f", receivingValue))

        XCTAssert(app.staticTexts["1 \(from.code) ~ 1.1 \(to.code)"].exists)
    }

    func testSwap() throws {

        let app = XCUIApplication()
        app.launch()

        let receivingValue = from.defaultSending * 1.1

        app.buttons["swap-view"].tap()
        let receivingValueAfterSwap = receivingValue * 1.1

        XCTAssert(app.staticTexts["row-sending"].staticTexts["currency-code"].label == to.code)
        XCTAssert((app.staticTexts["row-sending"].textFields["amount-view-value"].value as? String) == String(format: "%.2f", receivingValue))
        XCTAssert(app.staticTexts["row-receiving"].staticTexts["currency-code"].label == from.code)
        XCTAssert((app.staticTexts["row-receiving"].textFields["amount-view-value"].value as? String) == String(format: "%.2f", receivingValueAfterSwap))
    }

    func testEdit() throws {

        let app = XCUIApplication()
        app.launch()

        let newSending: Float = 77
        app.staticTexts["row-sending"].textFields["amount-view-value"].tap()
        app.staticTexts["row-sending"].textFields["amount-view-value"].press(forDuration: 2)
        app.staticTexts["row-sending"].textFields["amount-view-value"].typeText("\(newSending)")
        app.buttons["root-view"].tap()

        XCTAssert((app.staticTexts["row-receiving"].textFields["amount-view-value"].value as? String) == String(format: "%.2f", newSending * 1.1))
    }

    func testMinLimit() throws {

        let app = XCUIApplication()
        app.launch()

        let newSending: Float = from.sendingLimits.lowerBound - 1
        app.staticTexts["row-sending"].textFields["amount-view-value"].tap()

        app.staticTexts["row-sending"].textFields["amount-view-value"].clearAndType(text: "\(newSending)")
        app.buttons["root-view"].tap()

        XCTAssert((app.staticTexts["row-receiving"].textFields["amount-view-value"].value as? String) == "-")
        XCTAssert(app.staticTexts["error-message"].label == "Minimum sending amount \(from.sendingLimits.lowerBound) \(from.code)")
    }

    func testMaxLimit() throws {

        let app = XCUIApplication()
        app.launch()

        let newSending: Float = from.sendingLimits.upperBound + 1
        app.staticTexts["row-sending"].textFields["amount-view-value"].tap()
        app.staticTexts["row-sending"].textFields["amount-view-value"].press(forDuration: 2)
        app.staticTexts["row-sending"].textFields["amount-view-value"].typeText("\(newSending)")
        app.buttons["root-view"].tap()

        XCTAssert((app.staticTexts["row-receiving"].textFields["amount-view-value"].value as? String) == "-")
        XCTAssert(app.staticTexts["error-message"].label == "Maximum sending amount \(from.sendingLimits.upperBound) \(from.code)")
    }
}

extension XCUIElement {
    /// Removes any current text in the field before typing in the new value
    ///  - Parameter text: the text to enter into the field
    ///
    func clearAndType(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        self.typeText(deleteString)
        self.typeText(text)
    }
}
