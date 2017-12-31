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
    
    //refrence to protocol
    weak var passingDelegate: MenuVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    //add a new show
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        DataManager.instance.shows.append(Show())
        tableView.reloadData()
    }
}
