//
//  LogsController.swift
//  basketball
//
//  Created by Michael Vivar on 24/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//


import UIKit

class LogsController: TableController {
    
    var card: Card! {
        didSet {
            logs = card.logs?.sorted(by: { a, b in a.date.compare(b.date) == .orderedDescending })
        }
    }
    
    var logs: [Log]!

    override func viewDidLoad() {
        super.viewDidLoad()

        setTitle(title: "LOGS")
        tableView.register(UITableRowView.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let log = logs[indexPath.row]
        cell.textLabel?.text = log.data.number + ": " + log.action + " - " + log.data.name
        return cell
    }

    /*
    // MARK: - Navigation
    */

}
