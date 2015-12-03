import Foundation
import UIKit

class DynamicHeightCell : UITableViewCell {
    @IBAction func buttonTap(sender: AnyObject) {
        self.frame.size.height = self.frame.height * 1.5
    }
}
