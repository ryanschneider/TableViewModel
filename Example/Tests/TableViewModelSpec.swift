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
                var model: TableViewModel!
                var bundle: NSBundle!

                beforeEach {
                    bundle = NSBundle(forClass: self.dynamicType)

                    view = UIView()
                    view.frame = UIScreen.mainScreen().bounds

                    viewController = UIViewController()
                    viewController.view = view

                    tableView = UITableView()
                    tableView.frame = view.bounds;
                    view.addSubview(tableView)

                    model = TableViewModel(tableView: tableView)

                    ViewControllerTestingHelper.pushViewController(viewController)
                }

                it("doesn't have any sections") {
                    expect(tableView.numberOfSections) == 0
                }

                context("when a section is added to the model") {

                    func firstRowIndexPath() -> NSIndexPath {
                        return NSIndexPath(forRow: 0, inSection: 0)
                    }

                    func secondRowIndexPath() -> NSIndexPath {
                        return NSIndexPath(forRow: 1, inSection: 0)
                    }

                    func firstCell() -> UITableViewCell? {
                        return tableView.cellForRowAtIndexPath(firstRowIndexPath())
                    }

                    func secondCell() -> UITableViewCell? {
                        return tableView.cellForRowAtIndexPath(secondRowIndexPath())
                    }

                    var section: TableSection!

                    beforeEach {
                        section = TableSection(tableViewModel: model)
                        model.addSection(section)
                    }

                    it("has 1 section") {
                        expect(tableView.numberOfSections) == 1
                    }

                    context("when another section is added to the model") {
                        var section2: TableSection!

                        beforeEach {
                            section2 = TableSection(tableViewModel: model)
                            model.addSection(section2)
                        }

                        it("has 2 sections") {
                            expect(tableView.numberOfSections) == 2
                        }
                    }

                    context("when the section is removed from model") {
                        beforeEach {
                            model.removeSection(section)
                        }

                        it("has 0 sections") {
                            expect(tableView.numberOfSections) == 0
                        }
                    }

                    context("when a row is added to the section") {

                        var row1: TableRow!

                        beforeEach {
                            row1 = TableRow(nibName: "SampleCell1", inBundle: bundle)
                            section.addRow(row1)
                        }

                        it("has 1 cell in section") {
                            expect(tableView.numberOfRowsInSection(0)) == 1
                        }

                        it("has the correct cell") {
                            let cell = firstCell()
                            expect(cell).to(beASampleCell1())
                        }

                        context("when another row is added to the section") {
                            var row2: TableRow!

                            beforeEach {
                                row2 = TableRow(nibName: "SampleCell1", inBundle: bundle)
                                section.addRow(row2)
                            }

                            it("has 2 cells in section") {
                                expect(tableView.numberOfRowsInSection(0)) == 2
                            }

                            it("has the correct cells") {
                                let cell1 = firstCell()
                                let cell2 = secondCell()
                                expect(cell1).to(beASampleCell1())
                                expect(cell2).to(beASampleCell1())
                                expect(cell1) !== cell2
                            }

                            context("when the first row is removed") {
                                var cell1, cell2: UITableViewCell!

                                beforeEach {
                                    cell1 = firstCell()
                                    cell2 = secondCell()

                                    section.removeRow(row1)
                                }

                                it("has 1 cell") {
                                    expect(tableView.numberOfRowsInSection(0)) == 1
                                }

                                it("has the correct cell") {
                                    let actualCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
                                    expect(actualCell) === cell2
                                }
                            }
                        }

                        context("when a configuration closure is added to the row after adding the row to the section") {
                            beforeEach {
                                row1.configureCell {
                                    cell in
                                    let label = cell.contentView.subviews[0] as! UILabel
                                    label.text = "Configured the cell"
                                }
                            }

                            it("configures the cell") {
                                let cell = firstCell()
                                let label = cell?.contentView.subviews[0] as! UILabel
                                expect(label.text) == "Configured the cell"
                            }
                        }

                        context("when a configuration closure is added to the row before adding the row to a section") {
                            beforeEach {
                                let row2 = TableRow(nibName: "SampleCell1", inBundle: bundle)
                                row2.configureCell {
                                    cell in
                                    let label = cell.contentView.subviews[0] as! UILabel
                                    label.text = "Configured"
                                }
                                section.addRow(row2)
                            }

                            it("configures the cell") {
                                let cell = secondCell()
                                let label = cell?.contentView.subviews[0] as! UILabel
                                expect(label.text) == "Configured"
                            }
                        }

                        context("when a selection handler is configured for the row") {
                            var selectionHandlerIsCalled: Bool!
                            beforeEach {
                                selectionHandlerIsCalled = false
                                row1.didSelectCell {
                                    selectionHandlerIsCalled = true
                                }
                            }

                            context("when the cell is selected") {
                                beforeEach {
                                    tableView.selectRowAtIndexPath(firstRowIndexPath(), animated: false, scrollPosition: UITableViewScrollPosition.Top)
                                    model.tableView(tableView, didSelectRowAtIndexPath: firstRowIndexPath())
                                }

                                it("calls the selection handler when the cell is selected") {
                                    expect(selectionHandlerIsCalled) == true
                                }

                                it("deselects the cell by default") {
                                    var selectedRowIndexPath = tableView.indexPathForSelectedRow
                                    expect(selectedRowIndexPath).to(beNil())
                                }
                            }
                        }

                        context("when the row is configured for not to deselect after selection") {

                            func selectRowAtIndexPath(indexPath: NSIndexPath) {
                                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)

                                // We need to notify the model manually here because tableView doesn't
                                // call the delegate method after selectRowAtIndexPath
                                model.tableView(tableView, didSelectRowAtIndexPath: firstRowIndexPath())
                            }

                            beforeEach {
                                row1.shouldDeselectAfterSelection = false
                            }

                            context("when the cell is selected") {
                                beforeEach {
                                    selectRowAtIndexPath(firstRowIndexPath())
                                }

                                it("does not deselect the cell") {
                                    var selectedRowIndexPath = tableView.indexPathForSelectedRow
                                    expect(selectedRowIndexPath!.row) == 0
                                    expect(selectedRowIndexPath!.section) == 0
                                }
                            }
                        }
                    }

                    context("when a row with custom height cell added to the section") {
                        beforeEach {
                            let row = TableRow(nibName: "SampleCell2", inBundle: bundle)
                            section.addRow(row)
                        }

                        it("configures correct height for the cell") {
                            let cell = firstCell()
                            expect(cell?.frame.height) == 80
                        }
                    }

                    context("when height of cell is given externally") {
                        beforeEach {
                            let row = TableRow(nibName: "SampleCell2", inBundle: bundle)
                            row.height = 120
                            section.addRow(row)
                        }

                        it("ignores the cell height in the nib") {
                            let cell = firstCell()
                            expect(cell?.frame.height) == 120
                        }
                    }

                    context("when a cell with custom class is used") {

                    }
                }
            }

        }
    }
}

func beASampleCell1<T:UITableViewCell>() -> MatcherFunc<T?> {
    return MatcherFunc {
        actualExpression, failureMessage in
        failureMessage.postfixMessage = " be a SampleCell1"
        do {
            let cell = try actualExpression.evaluate() as! UITableViewCell
            let label = cell.contentView.subviews[0] as! UILabel
            return label.text == "SampleCell1"
        } catch {
            return false
        }
    }
}
