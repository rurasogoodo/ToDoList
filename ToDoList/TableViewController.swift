//
//  TableViewController.swift
//  ToDoList
//
//  Created by Nick_Romanenko on 1/21/19.
//  Copyright © 2019 Nick_Romanenko. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBAction func pushEditAction(_ sender: UIBarButtonItem) {
        tableView.setEditing(!self.tableView.isEditing, animated: true)
        
        //выполнить блок кода в основном потоке приложения через заданное время
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func pushAddAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Create new item", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "New item name"
        }
        
        //кнопка_1 алерт-контроллера
        let alertAction1 = UIAlertAction(title: "Cencel", style: .default) { (action) in
            //тут ничего, так как при нажатии на "Cencel" алерт-контроллер будет просто закрываться
        }
        
        //кнопка_2 алерт-контроллера
        let alertAction2 = UIAlertAction(title: "Create", style: .cancel) { (action) in
            let newItem = alertController.textFields![0].text
            
            if newItem == "" {
                return
            } else {
                addItem(nameItem: newItem!)
                self.tableView.reloadData()
            }
            //addItem(nameItem: newItem!)
            //self.tableView.reloadData()
        }
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView() //чтобы "футер таблицы"(пустые ячейки) не появлялись на экране
        tableView.backgroundColor = UIColor.groupTableViewBackground //меняем цвет "бэкграунда" таблицы на серый(можно это сделать и через сторибоард)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    //устанавливаем количество секций в таблице
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //устанавливаем количество строк (равной длине масива) в таблице
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ToDoItems.count
    }

    //настраиваем "шаблон" ячейки в таблице
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let currentItem = ToDoItems[indexPath.row]
        cell.textLabel?.text = currentItem["Name"] as? String
        
        if (currentItem["isCompleted"] as? Bool) == true {
            cell.imageView?.image = #imageLiteral(resourceName: "check")
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "uncheck")
        }
        
        if tableView.isEditing {
            cell.textLabel?.alpha = 0.4
            cell.imageView?.alpha = 0.4
        } else {
            cell.textLabel?.alpha = 1
            cell.imageView?.alpha = 1
        }
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeItem(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    //функция - вызывается при выборе ячейки таблицы
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if changeState(at: indexPath.row) {
            tableView.cellForRow(at: indexPath)?.imageView?.image = #imageLiteral(resourceName: "check")
        } else {
            tableView.cellForRow(at: indexPath)?.imageView?.image = #imageLiteral(resourceName: "uncheck")
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        moveItem(fromIndex: fromIndexPath.row, toIndex: to.row)
        tableView.reloadData()
    }
    
    //"какой значок (вставить/удалить/без значка) вставить перед строкой таблицы при активации редактирования"
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .none
        } else {
            return .delete
        }
    }

    //"следует ли делать отступ при редактировании строчек таблицы"
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
