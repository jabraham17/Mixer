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
    func showSelected(show: Show)
}

//view controller for the menu view
class MenuVC: UITableViewController {
    
    //refrence to protocol
    weak var passingDelegate: MenuVCDelegate?
    
    //all shows are stored here
    //TODO: temp code until prooper storgae created
    var shows: [Show] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //reload the data
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    //create the cells with the row name in it
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")!
        let rowNum = indexPath.row
        let show = shows[rowNum]
        cell.textLabel?.text = show.name
        return cell
    }
    //if selected, open the show
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showSelected = shows[indexPath.row]
        dismiss(animated: true, completion: {
            self.passingDelegate?.showSelected(show: showSelected)
        })
    }
    //add a new show
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        shows.append(Show())
        tableView.reloadData()
    }
}
