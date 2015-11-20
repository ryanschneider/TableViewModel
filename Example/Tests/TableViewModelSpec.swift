import Foundation
import UIKit
import Quick
import Nimble

import TableViewModel

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

                context("when a section is added to the model") {

                    var tableSection: TableSection!

                    beforeEach {
                        tableSection = TableSection()
                        tableViewModel.addSection(tableSection)
                    }

                    it("has 1 section") {
                        expect(tableView.numberOfSections) == 1
                    }

                    context("when the section is removed from model") {
                        beforeEach {
                            tableViewModel.removeSection(tableSection)
                        }

                        it("has 0 sections") {
                            expect(tableView.numberOfSections) == 0
                        }
                    }
                }
            }

        }
    }
}