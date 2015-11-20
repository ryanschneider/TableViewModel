import Foundation
import UIKit

public protocol TableSection {

    func addRow(row: TableRow)

    func addMultipleRows(rows: Array<TableRow>)

    func insertRow(row: TableRow, atIndex: Int)

    func insertMultipleRows(rows: Array<TableRow>, atIndexes: NSIndexSet)

    func removeRow(row: TableRow)

    func removeRowAtIndex(index: Int)

    func removeMultipleRows(rows: Array<TableRow>)

    func removeMultipleRowsAtIndexes(indexes: NSIndexSet)

    func removeAllRows()

    func numberOfRows() -> Int

    func rowAtIndex(index: Int) -> TableRow

    func didSelectRowAtIndex(index: Int)
}

public class AutoUpdateTableSection: NSObject, TableSection {

    private let rows = NSMutableArray()

    private let tableView: UITableView
    private weak var tableController: TableViewModel?

    public var rowAnimation: UITableViewRowAnimation

    public init(tableView: UITableView, tableController: TableViewModel) {
        self.tableView = tableView
        self.tableController = tableController

        rowAnimation = UITableViewRowAnimation.Fade

        super.init()

        addObserver(self, forKeyPath: "rows", options: NSKeyValueObservingOptions.New, context: nil)
    }

    deinit {
        removeObserver(self, forKeyPath: "rows")
    }

    public func addRow(row: TableRow) {
        observableRows().addObject(row as! NSObject)
    }

    public func createRow<T: UITableViewCell>(nibName nibName: String, fromBundle bundleOrNil: NSBundle? = nil) -> AutomaticTableRow<T> {
        let row = AutomaticTableRow<T>(nibName: nibName, bundle: bundleOrNil)
        self.addRow(row)
        return row
    }

    public func addMultipleRows(rows: Array<TableRow>) {
        let range = NSMakeRange(self.observableRows().count, rows.count)
        let indexes = NSIndexSet(indexesInRange: range)
        self.insertMultipleRows(rows, atIndexes: indexes)
    }

    public func insertRow(row: TableRow, atIndex index: Int) {
        self.observableRows().insertObject(row, atIndex: index)
    }

    public func insertMultipleRows(rows: Array<TableRow>, atIndexes indexes: NSIndexSet) {
        self.observableRows().insertObjects(rows, atIndexes: indexes)
    }

    public func removeRow(row: TableRow) {
        self.observableRows().removeObject(row)
    }

    public func removeRowAtIndex(index: Int) {
        self.observableRows().removeObjectAtIndex(index)
    }

    public func removeMultipleRows(rowsToRemove: Array<TableRow>) {
        let indexes = NSMutableIndexSet()
        for row in rowsToRemove {
            let index = self.indexOfRow(row)
            indexes.addIndex(index)
        }
        self.removeMultipleRowsAtIndexes(indexes)
    }

    public func removeAllRows() {
        self.removeMultipleRows(NSArray(array: self.rows) as! Array<TableRow>)
    }

    public func removeMultipleRowsAtIndexes(indexes: NSIndexSet) {
        self.observableRows().removeObjectsAtIndexes(indexes)
    }

    public func indexOfRow(row: TableRow) -> Int {
        return self.observableRows().indexOfObject(row)
    }

    private func observableRows() -> NSMutableArray {
        return mutableArrayValueForKey("rows")
    }

    public func numberOfRows() -> Int {
        return rows.count
    }

    public func rowAtIndex(index: Int) -> TableRow {
        return rows[index] as! TableRow
    }

    public func didSelectRowAtIndex(index: Int) {
        let row = rowAtIndex(index)
        row.didSelectCell?()
    }

    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String:AnyObject]?, context: UnsafeMutablePointer<Void>) {
        var indexPaths = Array<NSIndexPath>()
        let indexSet: NSIndexSet = change?[NSKeyValueChangeIndexesKey] as! NSIndexSet
        indexSet.enumerateIndexesUsingBlock {
            (idx, _) in

            let indexPath: NSIndexPath = NSIndexPath(forRow: idx, inSection: self.tableController!.indexOfSection(self))
            indexPaths.append(indexPath)
        }

        self.tableView.beginUpdates()
        if let kind: NSKeyValueChange = NSKeyValueChange(rawValue: change?[NSKeyValueChangeKindKey] as! UInt) {
            switch kind {
            case .Insertion:
                tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
            case .Removal:
                tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
            default:
                return
            }
        }
        tableView.endUpdates()
    }
}