//
//  MoreSettingsViewController.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 8/22/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

class MoreSettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        navigationItem.title = "Settings"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
}
