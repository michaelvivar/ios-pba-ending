//
//  LogsController.swift
//  basketball
//
//  Created by Michael Vivar on 24/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//


import UIKit

class LogsController: TableController<Log, UILogRowView> {
    
    deinit {
        print("De Init: LogsController")
    }
    
    var card: Card! {
        didSet {
            logs = card.logs
        }
    }
    
    var logs: [Log]?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let visitor = card.teams["visitor"], let home = card.teams["home"] {
            setTitle(title: visitor.uppercased() + " vs " + home.uppercased())
        }
        else {
            setTitle(title: "LOGS")
        }
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [unowned self] _ in
            self.data = self.logs
            self.styles()
        })
    }

    func styles() {
        view.backgroundColor = UIColor.Hex("EEEEEE")
        tableView.backgroundColor = UIColor.Hex("EEEEEE")
        tableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        //tableView.layer.cornerRadius = 5
        tableView.layer.shadowColor = UIColor.gray.cgColor
        tableView.layer.shadowOffset = CGSize(width: 1, height: 1)
        tableView.layer.shadowRadius = 2
        tableView.layer.shadowOpacity = 0.2
        tableView.rowHeight = 40
    }
}
