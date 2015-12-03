import Foundation
import UIKit

public class TableViewModel: NSObject, UITableViewDataSource, UITableViewDelegate {

    public let tableView: UITableView
    public var sectionAnimation: UITableViewRowAnimation

    internal var sections: NSMutableArray

    public init(tableView: UITableView) {
        self.sections = NSMutableArray()
        self.tableView = tableView
        self.sectionAnimation = UITableViewRowAnimation.Fade

        super.init()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()

        addObserver(self, forKeyPath: "sections", options: NSKeyValueObservingOptions.New, context: nil)
    }

    deinit {
        removeObserver(self, forKeyPath: "sections")
    }

    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String:AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let indexSet: NSIndexSet = change?[NSKeyValueChangeIndexesKey] as! NSIndexSet else {
            return
        }

        guard let kind: NSKeyValueChange = NSKeyValueChange(rawValue: change?[NSKeyValueChangeKindKey] as! UInt) else {
            return
        }

        self.tableView.beginUpdates()
        switch kind {
        case .Insertion:
            tableView.insertSections(indexSet, withRowAnimation: self.sectionAnimation)
        case .Removal:
            tableView.deleteSections(indexSet, withRowAnimation: self.sectionAnimation)
        default:
            return
        }
        tableView.endUpdates()
    }

    public func addSection(section: TableSection) {
        section.tableViewModel = self
        section.tableView = tableView
        observableSections().addObject(section)
    }

    public func removeSection(section: TableSection) {
        guard self.indexOfSection(section) != NSNotFound else {
            return
        }

        section.tableViewModel = nil
        section.tableView = nil
        observableSections().removeObject(section)
    }

    public func indexOfSection(section: TableSection) -> Int {
        return sections.indexOfObject(section)
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionAtIndex(section).numberOfRows()
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = rowForIndexPath(indexPath)
        let cell = row.cellForTableView(tableView) as UITableViewCell!

        return cell
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowForIndexPath(indexPath).cellHeight()
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = rowForIndexPath(indexPath)

        row.selected()

        if row.shouldDeselectAfterSelection {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    private func observableSections() -> NSMutableArray {
        return mutableArrayValueForKey("sections")
    }

    private func sectionAtIndex(index: Int) -> TableSection {
        return sections[index] as! TableSection
    }

    private func rowForIndexPath(indexPath: NSIndexPath) -> TableRow {
        let section = sections[indexPath.section] as! TableSection
        let row = section.rowAtIndex(indexPath.row)
        return row
    }
}
