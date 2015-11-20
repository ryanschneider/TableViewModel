import Foundation
import UIKit

public class TableRow {
    private let nibName: String
    private var bundle: NSBundle?
    private var cell: UITableViewCell?

    public init(nibName: String, inBundle bundle: NSBundle? = nil) {
        self.nibName = nibName
        self.bundle = bundle
    }

    public func cellForTableView(tableView: UITableView) -> UITableViewCell? {
        if cell == nil {
            cell = loadCellForTableView(tableView)
        }

        return cell
    }

    private func loadCellForTableView(tableView: UITableView) -> UITableViewCell? {
        let dequeued = tableView.dequeueReusableCellWithIdentifier(nibName)
        if dequeued != nil {
            return dequeued
        } else {
            let nib: UINib = UINib(nibName: nibName, bundle: bundle)
            tableView.registerNib(nib, forCellReuseIdentifier: nibName)
            let cell = tableView.dequeueReusableCellWithIdentifier(nibName)
            return cell
        }
    }
}
