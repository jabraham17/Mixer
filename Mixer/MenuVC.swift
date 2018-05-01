//
//  Menu.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/27/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit
import SideMenu

//prootcoll to pass sleected shows
protocol MenuVCDelegate: class {
    func showSelected(index: Int)
}

//view controller for the menu view
class MenuVC: UITableViewController {
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    //refrence to protocol
    weak var passingDelegate: MenuVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //sort shows by last run date
        DataManager.instance.shows.sort(by: { (s1, s2) in
            return s1.dateLastEdit > s2.dateLastEdit
        })
        DataManager.instance.save()
        //reload the data
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.instance.shows.count
    }
    //create the cells with the row name in it
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")!
        let rowNum = indexPath.row
        cell.textLabel?.text = DataManager.instance.shows[rowNum].name
        return cell
    }
    //if selected, open the show
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: {
            self.passingDelegate?.showSelected(index: indexPath.row)
        })
    }
    //returns true if its possible to edit table
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
    //do not allow moving of cells
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    //create actions to edit cell, this is just a delete button
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //get the row
        let row = indexPath.row
        //get the cell data at the row
        let cellData = tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "New Show"
        //create the delete button
        let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete", handler:
            //handler for button
            {(action, indexPath) in
                //check if user is sure they want to delete cell
                //create alert
                let alert = UIAlertController(title: "Delete?", message: "Are your sure you want to delete \(cellData)? This cannot be undone.", preferredStyle: .alert)
                //add delete button
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler:
                    //handler for the delete button
                    {(alert) in
                        DataManager.instance.shows.remove(at: row)
                        DataManager.instance.save()
                        tableView.reloadData()
                }))
                //add cancel button
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
                    //handler for the cancel button
                    {(alert) in
                        //reload the current row to dismiss delete button
                        tableView.reloadRows(at: [indexPath], with: .right)
                }))
                //show the alert
                self.present(alert, animated: true, completion: nil)
        })
        return [deleteButton]
    }
    //add a new show
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        DataManager.instance.shows.append(Show())
        DataManager.instance.save()
        tableView.reloadData()
    }
    //edit the show list to remove a show
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        //get text of button
        let title = sender.title
        if(title == "Edit") {
            sender.title = "Done"
            addButton.isEnabled = false
            tableView.setEditing(true, animated: true)
        }
        else if(title == "Done") {
            sender.title = "Edit"
            addButton.isEnabled = true
            tableView.setEditing(false, animated: true)
            
            //save data
            DataManager.instance.save()
            tableView.reloadData()
        }
    }
}
