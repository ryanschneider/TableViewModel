import Foundation
import UIKit
import Quick
import Nimble

import TableViewModel

class TableViewModelSpec: QuickSpec {
    override func spec() {
        describe("TableVieWModel") {
            var tableView: UITableView!
            var tableViewModel: TableViewModel!

            beforeEach {
                tableView = UITableView()

                tableViewModel = TableViewModel(tableView: tableView)
            }

            context("when a section is added to the table view model") {
                var section: TableSection!

                beforeEach {
                    section = TableSection()
                    tableViewModel.addSection(section)
                }

                it("sets itself to the tableViewModel property of the section") {
                    expect(section.tableViewModel) === tableViewModel
                }

                it("sets its tableView to the tableView property of the section") {
                    expect(section.tableView) === tableView
                }

                context("when the added section is removed from the table view vmodel") {
                    beforeEach {
                        tableViewModel.removeSection(section)
                    }

                    it("sets the tableViewModel property of the section to nil") {
                        expect(section.tableViewModel).to(beNil())
                    }

                    it("sets the tableView property of the section to nil") {
                        expect(section.tableView).to(beNil())
                    }
                }

                context("when a section is inserted to the table view model") {
                    var insertedSection: TableSection!

                    beforeEach {
                        insertedSection = TableSection()
                        tableViewModel.insertSection(insertedSection, atIndex: 0)
                    }

                    it("sets itself to the tableViewModel property of the inserted section") {
                        expect(insertedSection.tableViewModel) === tableViewModel
                    }

                    it("sets itstableView to the tableView property of the section") {
                        expect(insertedSection.tableView) === tableView
                    }
                }

            }

            context("when removeSection is called with a section that wasn't added to the tableViewModel") {
                var section: TableSection!
                var tableViewOfSection: UITableView!
                var tableViewModelOfSection: TableViewModel!

                beforeEach {
                    section = TableSection()

                    tableViewOfSection = UITableView()
                    tableViewModelOfSection = TableViewModel(tableView: tableViewOfSection)

                    tableViewModelOfSection.addSection(section)

                    tableViewModel.removeSection(section)
                }

                it("does not change tableView and tableViewModel property values of the section") {
                    expect(section.tableView) === tableViewOfSection
                    expect(section.tableViewModel) === tableViewModelOfSection
                }
            }

        }
    }
}