import Foundation
import UIKit
import Quick
import Nimble

import TableViewModel

class TableSectionSpec: QuickSpec {
    override func spec() {
        describe("TableSection") {
            var section: TableSection!

            beforeEach {
                section = TableSection()
            }

            context("when a row is added to the section") {
                var row: TableRow!

                beforeEach {
                    row = TableRow(cellIdentifier: "", inBundle: NSBundle(forClass: self.dynamicType))
                    section.addRow(row)
                }

                it("sets the tableSection property in the row") {
                    expect(row.tableSection) === section
                }

                context("when the row is removed from the section") {
                    beforeEach {
                        section.removeRow(row)
                    }

                    it("sets the tableSection property of the row to nil") {
                        expect(row.tableSection).to(beNil())
                    }
                }

                context("when all rows are removed from the section") {
                    beforeEach {
                        section.removeAllRows()
                    }

                    it("sets the tableSection property of the row to nil") {
                        expect(row.tableSection).to(beNil())
                    }
                }
            }

            context("when removeRow is called with a row that wasn't added to the section") {
                var sectionOfRow: TableSection!
                var row: TableRow!

                beforeEach {
                    sectionOfRow = TableSection()
                    row = TableRow(cellIdentifier: "")
                    sectionOfRow.addRow(row)

                    section.removeRow(row)
                }

                it("doesn't change tableSection property value of the row") {
                    expect(row.tableSection) === sectionOfRow
                }
            }

            context("when multiple rows are added to the section") {
                var row1: TableRow!
                var row2: TableRow!

                beforeEach {
                    row1 = TableRow(cellIdentifier: "")
                    row2 = TableRow(cellIdentifier: "")

                    section.addRows([row1, row2])
                }

                it("sets the tableSection property of each row") {
                    expect(row1.tableSection) === section
                    expect(row2.tableSection) === section
                }

                context("when multiple rows are removed from the section") {
                    beforeEach {
                        section.removeRows([row1, row2])
                    }

                    it("sets the table section of each row to nil") {
                        expect(row1.tableSection).to(beNil())
                        expect(row2.tableSection).to(beNil())
                    }
                }
            }

            context("when a row is inserted to the section") {
                var row1: TableRow!
                var row2: TableRow!

                beforeEach {
                    row1 = TableRow(cellIdentifier: "")
                    row2 = TableRow(cellIdentifier: "")

                    section.addRow(row2)
                    section.insertRow(row1, atIndex: 0)
                }

                it("sets the tableSection property of the inserted row") {
                    expect(row1.tableSection) === section
                }
            }
        }
    }
}