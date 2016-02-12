import Foundation
import UIKit
import TableViewModel

class DynamicHeightRow: TableRow, DynamicHeightCellDelegate {

    public init() {
        super.init(cellNibName: "DynamicHeightCell")
    }

    public override func cellForTableView(tableView: UITableView) -> UITableViewCell? {
        let cellOrNil = super.cellForTableView(tableView)

        guard let cell = cellOrNil else {
            return nil
        }

        guard let dynamicHeightCell = cell as? DynamicHeightCell else {
            return cell
        }

        dynamicHeightCell.delegate = self

        return cell
    }

    public func cellDidUpdateHeight(cell: DynamicHeightCell) {
        self.height = Float(cell.frame.height)

        guard let cell = self.cell else {
            return
        }

        let indexPath = self.tableSection?.tableView?.indexPathForCell(cell)
        if indexPath != nil {
            self.tableSection?.tableView?.reloadRowsAtIndexPaths([indexPath!], withRowAnimation:UITableViewRowAnimation.Fade)
        }
    }
}