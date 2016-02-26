import Foundation
import UIKit

public protocol TableRowProtocol: class, AnyObject {

    func cellForTableView(tableView: UITableView) -> UITableViewCell?

    func heightForCell() -> CGFloat

    func select()

    var shouldDeselectAfterSelection: Bool { get }

    var tableSection: TableSection? { get set }
}

public class TableRow: TableRowProtocol {
    private let cellIdentifier: String
    private var bundle: NSBundle?
    private var configureClosure: ((cell:UITableViewCell) -> ())?
    private var onSelectionClosure: ((row:TableRow) -> ())?

    public private(set) var cell: UITableViewCell?
    public weak var tableSection: TableSection?
    public var height: Float?
    public var shouldDeselectAfterSelection: Bool = true

    public init(cellIdentifier: String, inBundle bundle: NSBundle? = nil) {
        self.cellIdentifier = cellIdentifier
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

    public func select() {
        if let closure = onSelectionClosure {
            closure(row: self)
        }
    }

    public func configureCell(closure: (cell:UITableViewCell) -> ()) {
        configureClosure = closure
        callConfigureCellClosure()
    }

    public func onSelect(closure: (row:TableRow) -> ()) {
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

        let dequeued = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if dequeued != nil {
            return dequeued
        } else {
            let nib: UINib = UINib(nibName: cellIdentifier, bundle: bundle)
            tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
            return cell
        }
    }
}

