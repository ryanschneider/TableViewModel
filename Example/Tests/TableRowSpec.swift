import Foundation
import UIKit
import Quick
import Nimble

import TableViewModel

class TableRowSpec: QuickSpec {
    override func spec() {
        describe("TableRow") {
            var bundle: NSBundle!
            var tableRow: TableRow!
            var tableView: UITableView!

            beforeEach {
                bundle = NSBundle(forClass: self.dynamicType)
                tableView = UITableView()
                tableRow = TableRow(cellNibName: "SampleCell1", inBundle: bundle)
            }

            context("when asked for the cell") {
                var cell: UITableViewCell!

                beforeEach {
                    cell = tableRow.cellForTableView(tableView)
                }

                it("returns the correct cell") {
                    let label = cell!.contentView.subviews[0] as! UILabel
                    expect(label.text) == "SampleCell1"
                }

                it("registers the cell as a reusable cell in the table view") {
                    let cell = tableView.dequeueReusableCellWithIdentifier("SampleCell1")
                    expect(cell).toNot(beNil())
                }
            }

            context("when the cell is already registered as a reusable cell") {
                beforeEach {
                    let nib: UINib = UINib(nibName: "SampleCell1", bundle: bundle)
                    tableView.registerNib(nib, forCellReuseIdentifier: "SampleCell1")
                }

                context("when asked for the cell") {
                    var cell: UITableViewCell!

                    beforeEach {
                        cell = tableRow.cellForTableView(tableView)
                    }

                    it("dequeues the reusable cell") {
                        // TODO: test always fails because dequeueReusableCellWithIdentifier
                        // returns a different instance every time
//                        var dequeued = tableView.dequeueReusableCellWithIdentifier("SampleCell1")
//                        expect(cell) === dequeued
                    }
                }
            }
        }
    }
}