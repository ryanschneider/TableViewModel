import Foundation
import UIKit
import TableViewModel

class DynamicHeightRow: TableRow, DynamicHeightCellDelegate {

    private var dynamicHeightCell: DynamicHeightCell?

    public init() {
        super.init(nibName: "DynamicHeightCell")
    }

    public override func cellForTableView(tableView: UITableView) -> UITableViewCell? {
        let cellOrNil = super.cellForTableView(tableView)

        guard let cell = cellOrNil else {
            return nil
        }

        guard let dynamicHeightCell = cell as? DynamicHeightCell else {
            return cell
        }

        self.dynamicHeightCell = dynamicHeightCell
        dynamicHeightCell.delegate = self

        return cell
    }

    public func cellDidUpdateHeight(cell: DynamicHeightCell) {
        self.height = Float(cell.frame.height)

        guard let cell = self.dynamicHeightCell else {
            return
        }

        let indexPath = self.tableSection?.tableView?.indexPathForCell(cell)
        if indexPath != nil {
            self.tableSection?.tableView?.reloadRowsAtIndexPaths([indexPath!], withRowAnimation:UITableViewRowAnimation.Fade)
        }
    }
}