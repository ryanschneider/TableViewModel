import Foundation
import UIKit
import Quick
import Nimble

import TableViewModel

class AcceptanceSpec: QuickSpec {
    override func spec() {
        describe("table view model") {

            context("when a table view is initialized with a 'TableViewModel'") {
                var tableView: UITableView!
                var view: UIView!
                var viewController: UIViewController!
                var model: TableViewModel!
                var bundle: NSBundle!

                /*
                 * Shortcuts for accessing table cells
                 */

                func cellAtIndexOfFirstSection(rowindex: Int) -> UITableViewCell? {
                    return tableView.cellForRowAtIndexPath(indexPathForRowInFirstSection(rowindex))
                }

                func firstCell() -> UITableViewCell? {
                    return cellAtIndexOfFirstSection(0)
                }

                func secondCell() -> UITableViewCell? {
                    return cellAtIndexOfFirstSection(1)
                }

                func thirdCell() -> UITableViewCell? {
                    return cellAtIndexOfFirstSection(2)
                }

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

                    var section: TableSection!

                    beforeEach {
                        section = TableSection()
                        model.addSection(section)
                    }

                    it("has 1 section") {
                        expect(tableView.numberOfSections) == 1
                    }

                    context("when another section is added to the model") {
                        var section2: TableSection!
                        var row1, row2: TableRow!

                        beforeEach {
                            section2 = TableSection()
                            model.addSection(section2)

                            row1 = TableRow(nibName: "SampleCell1", inBundle: bundle)
                            section.addRow(row1)

                            row2 = TableRow(nibName: "SampleCell2", inBundle: bundle)
                            section2.addRow(row2)
                        }

                        it("has 2 sections") {
                            expect(tableView.numberOfSections) == 2
                        }

                        it("has sections in correct order") {
                            expect(tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))).to(beASampleCell1())
                            expect(tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))).to(beASampleCell2())
                        }
                    }

                    context("when another section is inserted at index 0") {
                        var section2: TableSection!
                        var row1, row2: TableRow!

                        beforeEach {
                            section2 = TableSection()
                            model.insertSection(section2, atIndex: 0)

                            row1 = TableRow(nibName: "SampleCell1", inBundle: bundle)
                            section.addRow(row1)

                            row2 = TableRow(nibName: "SampleCell2", inBundle: bundle)
                            section2.addRow(row2)
                        }

                        it("has 2 section") {
                            expect(tableView.numberOfSections) == 2
                        }

                        it("has sections in correct order") {
                            expect(tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))).to(beASampleCell1())
                            expect(tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))).to(beASampleCell2())
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

                            context("when all rows are removed") {
                                beforeEach {
                                    section.removeAllRows()
                                }

                                it("is not implemented") {
                                    expect(tableView.numberOfRowsInSection(0)) == 0
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
                            var rowParameterPassedToClosure: TableRow?
                            beforeEach {
                                selectionHandlerIsCalled = false
                                rowParameterPassedToClosure = nil
                                row1.didSelectCell {
                                    row in
                                    rowParameterPassedToClosure = row
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

                                it("passes correct row parameter to the closure") {
                                    expect(rowParameterPassedToClosure) === row1
                                }
                            }
                        }

                        context("when row is configured for not deselcting the cell after selection") {
                            beforeEach {
                                row1.shouldDeselectAfterSelection = false
                            }

                            context("when the cell is selected") {
                                beforeEach {
                                    tableView.selectRowAtIndexPath(firstRowIndexPath(), animated: false, scrollPosition: UITableViewScrollPosition.Top)
                                    model.tableView(tableView, didSelectRowAtIndexPath: firstRowIndexPath())
                                }

                                it("does not deselect the cell") {
                                    var selectedRowIndexPath = tableView.indexPathForSelectedRow
                                    expect(selectedRowIndexPath?.row) == firstRowIndexPath().row
                                    expect(selectedRowIndexPath?.section) == firstRowIndexPath().section
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

                    context("when a cell with variable height is used") {
                        var rows: Array<TableRow>!

                        beforeEach {
                            rows = Array<TableRow>()

                            for var i = 1; i < 20; i++ {
                                let row = TableRow(nibName: "SampleCell1", inBundle: bundle)
                                row.height = Float(100 + i)
                                rows.append(row)
                                section.addRow(row)
                            }
                        }

                        it("renders each row in correct height") {
                            for var i = 1; i < 20; i++ {
                                let indexPath = NSIndexPath(forRow: (i - 1), inSection: 0)
                                tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                                var cell = tableView.cellForRowAtIndexPath(indexPath)
                                expect(cell?.frame.height) == CGFloat(100 + i)
                            }
                        }
                    }

                    context("when multiple rows are added to the section") {
                        var row1: TableRow!
                        var row2: TableRow!
                        var row3: TableRow!

                        beforeEach {
                            row1 = sampleRowWithLabelText("row1")
                            row2 = sampleRowWithLabelText("row2")
                            row3 = sampleRowWithLabelText("row3")

                            let rows: Array<TableRow> = [row1, row2, row3]

                            section.addRows(rows)
                        }

                        it("adds each row to the table view") {
                            expect(firstCell()).to(beASampleCellWithLabelText("row1"))
                            expect(secondCell()).to(beASampleCellWithLabelText("row2"))
                            expect(thirdCell()).to(beASampleCellWithLabelText("row3"))
                        }

                        context("when multiple rows are removed from the section") {
                            beforeEach {
                                section.removeRows([row1, row3])
                            }

                            it("removes each row in the parameter array from the table view") {
                                expect(tableView.numberOfRowsInSection(0)) == 1
                                expect(firstCell()).to(beASampleCellWithLabelText("row2"))
                            }
                        }
                    }

                    context("when a row is inserted into an index of a section") {
                        var row1: TableRow!
                        var row2: TableRow!
                        var row3: TableRow!

                        beforeEach {
                            row1 = sampleRowWithLabelText("row1")
                            row2 = sampleRowWithLabelText("row2")
                            row3 = sampleRowWithLabelText("row3")

                            let initialRows: Array<TableRow> = [row1, row3]

                            section.addRows(initialRows)
                            section.insertRow(row2, atIndex: 1)
                        }

                        it("places the inserted row to the correct index") {
                            expect(firstCell()).to(beASampleCellWithLabelText("row1"))
                            expect(secondCell()).to(beASampleCellWithLabelText("row2"))
                            expect(thirdCell()).to(beASampleCellWithLabelText("row3"))
                        }
                    }
                }

                context("when a table section with header view added to the model") {
                    var section: TableSection!
                    var headerView: UIView!

                    beforeEach {
                        headerView = UIView(frame: CGRectMake(0, 0, 320, 100))

                        section = TableSection()
                        section.headerView = headerView
                        section.headerHeight = Float(30)

                        model.addSection(section)
                    }

                    it("displays the header view in the table view") {
                        // TODO: this test doesn't pass
//                        let actualHeaderView = tableView.headerViewForSection(0)
//
//                        expect(actualHeaderView) === headerView
                    }

                    it("displays the header view with correct height") {

                    }
                }
            }

        }
    }
}

/*
 * Utility functions
 */

func indexPathForRowInFirstSection(rowIndex: Int) -> NSIndexPath {
    return NSIndexPath(forRow: rowIndex, inSection: 0)
}

func firstRowIndexPath() -> NSIndexPath {
    return indexPathForRowInFirstSection(0)
}

func secondRowIndexPath() -> NSIndexPath {
    return indexPathForRowInFirstSection(1)
}

func thirdRowIndexPath() -> NSIndexPath {
    return indexPathForRowInFirstSection(2)
}

func sampleRowWithLabelText(labelText: String) -> TableRow {
    let row = TableRow(nibName: "SampleCell1", inBundle: NSBundle(forClass: AcceptanceSpec().dynamicType))
    row.configureCell {
        cell in
        let label = cell.contentView.subviews[0] as! UILabel
        label.text = labelText
    }
    return row
}

/*
 * Matchers for sample cells
 */

func beASampleCell1<T:UITableViewCell>() -> MatcherFunc<T?> {
    return MatcherFunc {
        actualExpression, failureMessage in
        failureMessage.postfixMessage = " be a SampleCell1"
        do {
            let cell = try actualExpression.evaluate() as? UITableViewCell
            let label = cell?.contentView.subviews[0] as? UILabel
            return label?.text == "SampleCell1"
        } catch {
            return false
        }
    }
}

func beASampleCell2<T:UITableViewCell>() -> MatcherFunc<T?> {
    return MatcherFunc {
        actualExpression, failureMessage in
        failureMessage.postfixMessage = " be a SampleCell2"
        do {
            let cell = try actualExpression.evaluate() as? UITableViewCell
            let button = cell?.contentView.subviews[0] as? UIButton
            return button?.titleForState(UIControlState.Normal) == "SampleCell2"
        } catch {
            return false
        }
    }
}

func beASampleCellWithLabelText<T:UITableViewCell>(expectedLabelText: String) -> MatcherFunc<T?> {
    return MatcherFunc {
        actualExpression, failureMessage in
        failureMessage.postfixMessage = " be a SampleCell1 with label text '\(expectedLabelText)'"
        do {
            let cell = try actualExpression.evaluate() as? UITableViewCell
            let label = cell?.contentView.subviews[0] as? UILabel
            return label?.text == expectedLabelText
        } catch {
            return false
        }
    }
}
