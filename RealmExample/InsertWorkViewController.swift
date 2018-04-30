import RealmSwift

protocol InsertWorkDelegate: class {
    func workInserted(work: Work)
}

class InsertWorkViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    
    weak var delegate: InsertWorkDelegate?
    
    @IBAction func insertBtnTapped() {
        let text = inputTextField.text ?? ""
        if text.count == 0 {
            return
        }
        
        
        let work = Work()
        work.name = text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        work.insertDate = dateFormatter.string(from: Date())
        
        delegate?.workInserted(work: work)
        
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(work)
        try! realm.commitWrite()
        
        self.navigationController?.popViewController(animated: true)
    }
}
