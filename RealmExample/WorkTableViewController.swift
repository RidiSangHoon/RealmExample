import UIKit
import RealmSwift

// MARK: - MODEL

final class Work: Object {
    @objc dynamic var name: String?
    @objc dynamic var insertDate: String?
}

class WorkTableViewCell: UITableViewCell {
    @IBOutlet weak var workNameLabel: UILabel!
}

class WorkTableViewController: UITableViewController {

    @IBOutlet var table: UITableView!
    
    let realm = try! Realm()
    var workArray = [Work]()
    var selectedIndex: Int = -1
    var delegate: InsertWorkDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.tableFooterView = UIView(frame: .zero)
        
        workArray = Array(realm.objects(Work.self).sorted(byKeyPath: "insertDate"))
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Work Insert" {
            (segue.destination as! InsertWorkViewController).delegate = self
        }
    }
}

// MARK: - UITableViewDataSource

extension WorkTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkTableViewCell") as! WorkTableViewCell
        cell.workNameLabel.text = workArray[indexPath.row].name
        return cell 
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            realm.beginWrite()
            realm.delete(workArray[indexPath.row])
            try! realm.commitWrite()
            workArray = workArray.filter { $0 != workArray[indexPath.row]}
            table.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate

extension WorkTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
}

// MARK: - InsertWorkDelegate

extension WorkTableViewController: InsertWorkDelegate {
    func workInserted(work: Work) {
        workArray.append(work)
        tableView.reloadData()
    }
}
