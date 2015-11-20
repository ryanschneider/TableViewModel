import Foundation
import UIKit

@objc public class TableViewModel: NSObject, UITableViewDataSource {

    let tableView: UITableView

    public init(tableView: UITableView) {
        self.tableView = tableView

        super.init()

        self.tableView.dataSource = self;
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
