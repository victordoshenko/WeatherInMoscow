//
//  ViewController3.swift
//  HomeWork14
//
//  Created by Victor Doshchenko on 22.02.2020.
//  Copyright © 2020 Victor Doshchenko. All rights reserved.
//

import UIKit
import CoreData

class ViewController3: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var items: [TaskTodo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

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
            
            self.saveTask(info: text)

            self.tableView.insertRows(at: [IndexPath.init(row: self.items.count-1, section: 0)], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    func saveTask(info: String) {
      
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "TaskTodo", in: context)
      let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! TaskTodo
      taskObject.info = info
      
      do {
        try context.save()
        items.append(taskObject)
      } catch {
        print(error.localizedDescription)
      }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      
      let fetchRequest: NSFetchRequest<TaskTodo> = TaskTodo.fetchRequest()
      
      do {
        items = try context.fetch(fetchRequest)
      } catch {
        print(error.localizedDescription)
      }
    }

}

extension ViewController3: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count != 0 {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].info
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            context.delete(items[indexPath.row] as NSManagedObject)
            items.remove(at: indexPath.row)
            do {
              try context.save()
              self.tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
              print(error.localizedDescription)
            }
        }
    }

}
