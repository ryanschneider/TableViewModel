import Foundation

import TableViewModel

import Quick
import Nimble

class TableViewSpec: QuickSpec {
    override func spec() {
        describe("table view bound to a 'TableViewModel'") {

            context("when it is initialized with a 'TableViewModel'") {
                var tableView: UITableView!
                var view: UIView!
                var viewController: UIViewController!
                var tableViewModel: TableViewModel!

                beforeEach {
                    view = UIView()
                    view.frame = UIScreen.mainScreen().bounds

                    tableView = UITableView()
                    tableView.frame = view.bounds;
                    view.addSubview(tableView)

                    tableViewModel = TableViewModel(tableView: tableView)

                    viewController = UIViewController()
                    viewController.view = view

                    ViewControllerTestingHelper.pushViewController(viewController)
                }

                it("doesn't have any sections") {
                    expect(tableView.numberOfSections) == 0
                }


            }

        }
    }
}