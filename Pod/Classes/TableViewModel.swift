import Foundation
import UIKit

public protocol TableViewModel: UITableViewDelegate, UITableViewDataSource {

    var delegate: TableControllerDelegate? { get set }

    func addSection(section: TableSection)

    func insertSection(section: TableSection, atIndex index: Int)

    func indexOfSection(section: TableSection) -> Int
}

public protocol TableControllerDelegate {
    func tableController(tableController: TableViewModel, didSelectRowAtIndexPath: NSIndexPath)
}

public class AutoUpdateTableViewModel: NSObject, TableViewModel {

    private let sections: NSMutableArray
    private let tableView: UITableView

    public var sectionAnimation: UITableViewRowAnimation
    public var delegate: TableControllerDelegate?

    public init(tableView: UITableView) {
        self.sections = NSMutableArray()
        self.tableView = tableView
        sectionAnimation = UITableViewRowAnimation.Fade
        super.init()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()

        addObserver(self, forKeyPath: "sections", options: NSKeyValueObservingOptions.New, context: nil)
    }

    deinit {
        removeObserver(self, forKeyPath: "sections")
    }

    public func addSection(section: TableSection) {
        observableSections().addObject(section as! NSObject)
    }

    public func insertSection(section: TableSection, atIndex index: Int) {
        observableSections().insertObject(section as! NSObject, atIndex: index)
    }

    public func createSection() -> AutoUpdateTableSection {
        let section = AutoUpdateTableSection(tableView: self.tableView, tableController: self)
        self.addSection(section)
        return section
    }

    public func indexOfSection(section: TableSection) -> Int {
        return sections.indexOfObject(section as! NSObject)
    }

    private func observableSections() -> NSMutableArray {
        return mutableArrayValueForKey("sections")
    }

    private func sectionAtIndex(index: Int) -> TableSection {
        return sections[index] as! TableSection
    }

    private func rowForIndexPath(indexPath: NSIndexPath) -> TableRow {
        let section = sectionAtIndex(indexPath.section)
        return section.rowAtIndex(indexPath.row)
    }

    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String:AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let indexSet: NSIndexSet = change?[NSKeyValueChangeIndexesKey] as! NSIndexSet

        self.tableView.beginUpdates()
        if let kind: NSKeyValueChange = NSKeyValueChange(rawValue: change?[NSKeyValueChangeKindKey] as! UInt) {
            switch kind {
            case .Insertion:
                tableView.insertSections(indexSet, withRowAnimation: self.sectionAnimation)
            case .Removal:
                tableView.deleteSections(indexSet, withRowAnimation: self.sectionAnimation)
            default:
                return
            }
        }
        tableView.endUpdates()
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count;
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionAtIndex(section).numberOfRows()
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return rowForIndexPath(indexPath).cellFor(tableView)!
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowForIndexPath(indexPath).heightForRow()
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.tableController(self, didSelectRowAtIndexPath: indexPath)

        let section = sectionAtIndex(indexPath.section)
        section.didSelectRowAtIndex(indexPath.row)

        let row = section.rowAtIndex(indexPath.row)

        var shouldDeselect = true
        if let shouldDeselectFunction = row.shouldDeselectCellAfterSelection {
            shouldDeselect = shouldDeselectFunction()
        }
        if shouldDeselect {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }

    }
}