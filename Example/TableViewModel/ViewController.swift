import UIKit
import TableViewModel

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var tableViewModel: TableViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewModel = TableViewModel(tableView: self.tableView)

        prototypeSection = TableSection()
        prototypeSection.headerTitle = "Prototype Cells"
        prototypeSection.headerHeight = 30
        tableViewModel.addSection(prototypeSection)

        let staticPrototypeRow = TableRow(cellIdentifier: "StaticPrototypeCell")
        prototypeSection.addRow(staticPrototypeRow)

        let customPrototypeRow = TableRow(cellIdentifier: "CustomPrototypeCell")
        customPrototypeRow.configureCell {
            cell in
            let customCell = cell as! CustomPrototypeCell
            customCell.label.text = "Custom label text"
        }
        prototypeSection.addRow(customPrototypeRow)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

