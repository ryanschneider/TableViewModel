import Foundation
import UIKit

public protocol TableRowProtocol {

    func cellForTableView(tableView: UITableView) -> UITableViewCell?

    func heightForCell() -> CGFloat

    func selected()

    var shouldDeselectAfterSelection: Bool { get }

}

public class TableRow: TableRowProtocol {
    private let nibName: String
    private var bundle: NSBundle?
    private var configureClosure: ((cell:UITableViewCell) -> ())?
    private var onSelectionClosure: ((row:TableRow) -> ())?

    public private(set) var cell: UITableViewCell?
    public internal(set) weak var tableSection: TableSection?
    public var height: Float?
    public var shouldDeselectAfterSelection: Bool = true

    public init(cellNibName: String, inBundle bundle: NSBundle? = nil) {
        self.nibName = cellNibName
        self.bundle = bundle
    }

    public func cellForTableView(tableView: UITableView) -> UITableViewCell? {
        self.cell = loadCellForTableView(tableView)

        callConfigureCellClosure()

        guard let cell = self.cell else {
            return nil
        }

        if self.height == nil {
            self.height = Float(cell.frame.height)
        }

        return cell
    }

    public func heightForCell() -> CGFloat {
        if let height = self.height {
            return CGFloat(height)
        }

        return 44
    }

    public func selected() {
        if let closure = onSelectionClosure {
            closure(row: self)
        }
    }

    public func configureCell(closure: (cell:UITableViewCell) -> ()) {
        configureClosure = closure
        callConfigureCellClosure()
    }

    public func onSelection(closure: (row:TableRow) -> ()) {
        onSelectionClosure = closure
    }

    private func callConfigureCellClosure() {
        guard let closure = self.configureClosure else {
            return
        }

        guard let cell = self.cell else {
            return
        }

        closure(cell: cell)
    }

    private func loadCellForTableView(tableViewOrNil: UITableView?) -> UITableViewCell? {
        let tableView: UITableView
        if tableViewOrNil == nil {
            tableView = UITableView()
        } else {
            tableView = tableViewOrNil as UITableView!
        }

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

