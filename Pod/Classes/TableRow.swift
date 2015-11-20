import Foundation
import UIKit

@objc public protocol TableRow {
    func cellFor(tableView: UITableView) -> UITableViewCell?

    func heightForRow() -> CGFloat

    optional func didSelectCell()

    optional func shouldDeselectCellAfterSelection() -> Bool
}

public class AutomaticTableRow<T: UITableViewCell>: NSObject, TableRow {

    private let nibName: String
    private var cell: T?
    private var bundleOrNil: NSBundle?
    private var configureCellClosure: ((cell:T) -> ())?
    private var selectionHandlerClosure: (() -> ())?
    private var height: CGFloat?

    init(nibName: String, bundle: NSBundle? = nil) {
        self.nibName = nibName
        self.bundleOrNil = bundle
        self.configureCellClosure = nil
    }

    public func cellFor(tableView: UITableView) -> UITableViewCell? {
        self.cell = TableCellLoader.cellFromNibName(nibName, forTableView: tableView, fromBundle: bundleOrNil) as! T

        if let cell = self.cell {
            height = cell.frame.height

            if let configure = configureCellClosure {
                configure(cell: cell)
            }
        }

        return cell
    }

    public func heightForRow() -> CGFloat {
        guard let height = self.height else {
            return 44
        }

        return height
    }

    public func didSelectCell() {
        if let closure = self.selectionHandlerClosure {
            closure()
        }
    }

    public func configureCell(closure: (cell:T) -> ()) {
        self.configureCellClosure = closure

        guard let cell = self.cell else {
            return
        }

        closure(cell: cell)
    }

    public func didSelect(closure: () -> ()) {
        self.selectionHandlerClosure = closure
    }
}