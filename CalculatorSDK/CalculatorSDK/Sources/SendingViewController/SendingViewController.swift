//
//  SendingViewController.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import CommonUI
import UIKit

extension Calculator {

    final public class SendingViewController: ViewController<SendingView> {

        public override init() {
            self.viewModel = .init()
            super.init()

            viewModel.fetchCurrencies()
        }

        public override func viewDidLoad() {
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

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        viewModel.currencies.count
    }

    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier) as? Cell ?? Cell(reuseIdentifier: Cell.reuseIdentifier)
        cell.currency = viewModel.currencies[indexPath.row]
        return cell
    }

    public func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {

        TableHeaderView(model: .init(title: "All countries"))
    }
}
