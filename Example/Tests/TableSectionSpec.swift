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
                    row = TableRow(nibName: "SampleCell1", inBundle: NSBundle(forClass: self.dynamicType))
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
            }

            context("when removeRow is called with a row that wasn't added to the section") {
                var sectionOfRow: TableSection!
                var row: TableRow!

                beforeEach {
                    sectionOfRow = TableSection()
                    row = TableRow(nibName: "SampleCell1")
                    sectionOfRow.addRow(row)

                    section.removeRow(row)
                }

                it("doesn't change tableSection property value of the row") {
                    expect(row.tableSection) === sectionOfRow
                }
            }
        }
    }
}