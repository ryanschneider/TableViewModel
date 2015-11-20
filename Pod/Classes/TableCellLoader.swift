import Foundation
import UIKit

public class TableCellLoader {
    public class func cellFromNibName(nibName: NSString, forTableView tableViewOrNil: UITableView? = nil, fromBundle bundleOrNil: NSBundle? = nil) -> UITableViewCell? {
        if let tableView = tableViewOrNil {
            return cellFromNibNameInternal(nibName, forTableView: tableView, fromBundle: bundleOrNil)
        } else {
            return cellFromNibNameInternal(nibName, forTableView: UITableView(), fromBundle: bundleOrNil)
        }
    }

    private class func cellFromNibNameInternal(nibName: NSString, forTableView tableView: UITableView, fromBundle bundleOrNil: NSBundle? = nil) -> UITableViewCell? {
        let cellOrNil = tableView.dequeueReusableCellWithIdentifier(nibName as String)
        if let loadedCell = cellOrNil {
            return loadedCell
        } else {
            let nib: UINib = UINib(nibName: nibName as String, bundle: bundleOrNil)
            tableView.registerNib(nib, forCellReuseIdentifier: nibName as String)
            let cellOrNil = tableView.dequeueReusableCellWithIdentifier(nibName as String)
            if let loadedCell = cellOrNil {
                return loadedCell
            }
        }
        return nil
    }
}