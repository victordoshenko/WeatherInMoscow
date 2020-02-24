//
//  ViewController2.swift
//  HomeWork14
//
//  Created by Victor Doshchenko on 21.02.2020.
//  Copyright © 2020 Victor Doshchenko. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController2: UIViewController {
    let realm = try! Realm()
    var items: Results<TodoTask>!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = realm.objects(TodoTask.self)
    }

    @IBAction func addTodo(_ sender: Any) {
        addNewTask()
    }

    func addNewTask() {
        let alert = UIAlertController(title: "Новая задача", message: "Введите название", preferredStyle: .alert)
        
        var alertTextField: UITextField!
        alert.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "Новая задача"
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { action in
            
            guard let text = alertTextField.text , !text.isEmpty else { return }
            
            let task = TodoTask()
            task.info = text
            
            try! self.realm.write {
                self.realm.add(task)
            }

            self.tableView.insertRows(at: [IndexPath.init(row: self.items.count-1, section: 0)], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController2: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count != 0 {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].info
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let editingRow = items[indexPath.row]
            try! self.realm.write {
                self.realm.delete(editingRow)
                self.tableView.reloadData()
            }
        }
    }

}
