import UIKit
import TableViewModel

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var tableViewModel: TableViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewModel = TableViewModel(tableView: tableView)

        let tableSection = TableSection(tableViewModel: tableViewModel)
        tableViewModel.addSection(tableSection)

        let row1 = TableRow(nibName: "TestCell1")
        tableSection.addRow(row1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

