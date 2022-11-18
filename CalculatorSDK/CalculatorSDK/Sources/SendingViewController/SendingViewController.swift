//
//  SendingViewController.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import CommonUI
import UIKit

extension Calculator {

    final class SendingViewController: ViewController<SendingView> {

        init(
            viewModel: ViewModel
        ) {
            self.viewModel = viewModel
            super.init()
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            contentView.tableView.dataSource = self
            contentView.tableView.delegate = self
            contentView.tableView.rowHeight = UITableView.automaticDimension
        }

        // MARK: - Private

        private let viewModel: ViewModel
    }
}

extension Calculator.SendingViewController: UITableViewDataSource, UITableViewDelegate {

    typealias Cell = Calculator.SendingViewControllerCell

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        viewModel.currencies.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier) as? Cell ?? Cell(reuseIdentifier: Cell.reuseIdentifier)
        cell.currency = viewModel.currencies[indexPath.row]
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {

        TableHeaderView(model: .init(title: "All countries"))
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        viewModel.didSelect?(viewModel.currencies[indexPath.row])
        dismiss(animated: true)
    }
}
