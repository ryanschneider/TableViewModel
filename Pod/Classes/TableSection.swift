import Foundation
import UIKit

public class TableSection: NSObject {

    internal var rows: NSMutableArray

    public internal(set) var tableView: UITableView?
    public internal(set) weak var tableViewModel: TableViewModel?

    public var rowAnimation: UITableViewRowAnimation

    public var headerView: UIView?
    public var headerHeight: Float = 0
    public var headerTitle: String? = nil

    public init(rowAnimation: UITableViewRowAnimation = UITableViewRowAnimation.Fade) {
        rows = NSMutableArray()
        self.rowAnimation = rowAnimation

        super.init()

        addObserver(self, forKeyPath: "rows", options: NSKeyValueObservingOptions.New, context: nil)
    }

    deinit {
        removeObserver(self, forKeyPath: "rows")
    }

    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String:AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let indexSet: NSIndexSet = change?[NSKeyValueChangeIndexesKey] as! NSIndexSet else {
            return
        }

        guard let tableViewModel = self.tableViewModel else {
            return
        }

        guard let kind: NSKeyValueChange = NSKeyValueChange(rawValue: change?[NSKeyValueChangeKindKey] as! UInt) else {
            return
        }

        guard let tableView = self.tableView else {
            return
        }

        let sectionIndex = tableViewModel.indexOfSection(self)

        var indexPaths = Array<NSIndexPath>()
        indexSet.enumerateIndexesUsingBlock {
            (idx, _) in

            let indexPath: NSIndexPath = NSIndexPath(forRow: idx, inSection: sectionIndex)
            indexPaths.append(indexPath)
        }

        tableView.beginUpdates()
        switch kind {
        case .Insertion:
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
        case .Removal:
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
        default:
            return
        }
        tableView.endUpdates()
    }

    public func addRow(row: TableRowProtocol) {
        assignTableSectionOfRow(row)
        observableRows().addObject(row)
    }

    public func addRows(rowsToAdd: Array<TableRowProtocol>) {
        rowsToAdd.map(assignTableSectionOfRow)
        let rowObjects = rowsToAdd.map {
            row in
            return row as AnyObject
        }
        let rowsProxy = self.observableRows()
        let range = NSMakeRange(self.rows.count, rowObjects.count)
        let indexes = NSIndexSet(indexesInRange: range)
        rowsProxy.insertObjects(rowObjects, atIndexes: indexes)
    }

    public func insertRow(row: TableRowProtocol, atIndex index: Int) {
        assignTableSectionOfRow(row)
        observableRows().insertObject(row, atIndex: index)
    }

    public func removeRow(row: TableRowProtocol) {
        removeTableSectionOfRow(row)
        observableRows().removeObject(row)
    }

    public func removeRows(rowsToRemove: Array<TableRowProtocol>) {
        rowsToRemove.map(removeTableSectionOfRow)
        let rowsProxy = self.observableRows()
        var indexes = NSMutableIndexSet()
        for row in rowsToRemove {
            let index = self.indexOfRow(row)
            indexes.addIndex(index)
        }
        rowsProxy.removeObjectsAtIndexes(indexes)
    }

    public func removeAllRows() {
        let allRows = self.rows.map {
            row in
            return row as! TableRowProtocol
        }
        allRows.map(removeTableSectionOfRow)
        let rowsProxy = self.observableRows()
        let range = NSMakeRange(0, rowsProxy.count)
        let indexes = NSIndexSet(indexesInRange: range)
        rowsProxy.removeObjectsAtIndexes(indexes)
    }

    public func numberOfRows() -> Int {
        return rows.count
    }

    public func rowAtIndex(index: Int) -> TableRowProtocol {
        return rows.objectAtIndex(index) as! TableRowProtocol
    }

    public func indexOfRow(row: TableRowProtocol) -> Int {
        return rows.indexOfObject(row)
    }

    private func assignTableSectionOfRow(row: TableRowProtocol) -> AnyObject {
        row.tableSection = self
        return row as! AnyObject
    }

    private func removeTableSectionOfRow(row: TableRowProtocol) {
        guard self.indexOfRow(row) != NSNotFound else {
            return
        }
        row.tableSection = nil
    }

    private func observableRows() -> NSMutableArray {
        return mutableArrayValueForKey("rows")
    }
}
