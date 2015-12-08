import Foundation
import UIKit

protocol DynamicHeightCellDelegate {
    func cellDidUpdateHeight(cell: DynamicHeightCell)
}

class DynamicHeightCell: UITableViewCell {

    var delegate: DynamicHeightCellDelegate?

    @IBAction func buttonTap(sender: AnyObject) {
        self.frame.size.height = self.frame.height * 1.5
        delegate?.cellDidUpdateHeight(self)
    }
}
