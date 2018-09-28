//
//  TableController.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class TableController<T, U: UITableRowView<T>>: BaseController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        setupSpinner()
    }
    
    let tableView: UITableView = {
        return UITableView()
    }()
    
    let emptyBox: UIImageView = {
        return UIImageView()
    }()
    
    let spinner: UIActivityIndicatorView = {
        return UIActivityIndicatorView()
    }()
    
    var initialData = true
    
    var data: [T]? {
        didSet {
            if (initialData) {
                initialData = false
                spinner.safeRemove()
                setupEmptyBox()
                setupTableView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((data?.count ?? 0) == 0) {
            tableView.isHidden = true
            emptyBox.isHidden = false
        }
        else {
            tableView.isHidden = false
            emptyBox.isHidden = true
        }
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! U
        cell.item = data![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func setupTableView() {
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.register(U.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension TableController {
    
    func setupEmptyBox() {
        emptyBox.image = UIImage(named: "box")
        view.addSubview(emptyBox)
        emptyBox.translatesAutoresizingMaskIntoConstraints = false
        emptyBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyBox.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyBox.isHidden = true
    }
    
    func setupSpinner() {
        spinner.color = UIColor.blue()
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.startAnimating()
    }
}
