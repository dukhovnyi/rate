## Rate iOS

The application fetches exchange rate based on selected currencies.

## Author

Yurii Dukhovnyi

## Requirements

- iOS 13+
- Xcode 14+
- Swift 5.7

## Dependencies

Implementation doesn't use any 3rd party depenedncy for optimisation application size and avoid any security issues.

## Structure

The Xcode workspace contains 3 standalone projects:

- [CommonUI](CommonUI) - contains reusable components and mechanisms for building UI.
- [CommonKit](CommonKit) - contains reusable mechanisms and extensions. For example API client.
- [CalculatorSDK](CalculatorSDK) - contains calculator feature with UI. It provides interfaces for creation view controller based on view model. To achive flexibility and make it possible easy to test, view model allows injecting fetch rate.
- [App](App) - UIKit application that imports CalculatorSDK, initializes instance, and presents necessary UI.

## How to run

Use App.xcworkspace to open it in Xcode. To run application use target - App.

## Technical decissions

- The minimal supported version is iOS 13. This decission has been made based on [Apple report](https://developer.apple.com/support/app-store/) and aimed to cover biggest part of devices.
  UI built used UIKit to achieve biggest scallability and have oportunity to reuse it in UIKit & SwiftUI applications.

- Application doesn't use png files, but pdf files to keep assets in vector and achieve necessary quality during scaling.

- All resources like fonts and images are not embedded into SDKs but only in application bundle. It means that final application could easily changes any resource in bundle or fetch them from remote source (like API). See [AssetBuilder](CommonUI/CommonUI/Sources/AssetBuilder.swift)

- Since CalculatorSDK has no complex user flow it has been developed with data-driven approach. It means that [ComparisonViewController](CalculatorSDK/CalculatorSDK/Sources/ComparisonViewController/ComparisonViewController.swift) on changing view model initializes property structures for child views and passes it down based on actual view state.

## Tech Debts

- The project has no logging mechanisms that should be done and located in CommonKit project.
- The project implemented in MVP maneer, so it covers main flows and doesn't handle use casses that are related to unstable network connections, API stoutdown, currency converting specific, etc. These use cases could be handled during implementation of unit/UI tests.

## Testing

TBD

## CI/CD

TBD
