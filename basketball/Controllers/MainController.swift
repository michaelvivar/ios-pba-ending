//
//  MainController.swift
//  basketball
//
//  Created by Michael Vivar on 24/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class MainController: TableController<Card, UICardRowView>, UICardRowDelegate, DataCardDelegate {
    
    var active: Bool = false
    
    func reload(with data: [Card]) {
        self.data = data
        tableView.reloadData()
    }
    
    func refresh() {
        tableView.reloadData()
        /*
        if let rows = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: rows, with: .top)
        }
        */
    }
    
    var cards: [Card]?

    override func viewDidLoad() {
        active = true
        super.viewDidLoad()
        setupNavigationBar()
        setupNavigationCreateButton()
        //setupDownloadButton()
        setTitle(title: "GAMES")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [unowned self] _ in
            self.data = self.cards
            print("Data: Loaded!")
        })
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.rowHeight = 80
        tableView.backgroundColor = UIColor.Hex("EEEEEE")
        tableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
    }
    
    func setupNavigationCreateButton() {
        let createButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.create))
        createButton.title = ""
        createButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = createButton
    }
    
    func setupDownloadButton() {
        let downloadButton = UIButton(type: .system)
        downloadButton.setImage(#imageLiteral(resourceName: "download"), for: .normal)
        downloadButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        downloadButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: downloadButton)
    }
    
    @objc func sync() {
        
    }
    
    @objc func create() {
        navigate(page: Page.Form, data: nil)
    }
    
    func didSelectRow(card: Card) {
        navigate(page: Page.Card, data: card)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 30, 0)
        cell.layer.transform = transform
        cell.alpha = 0.5
        UIView.animate(withDuration: 0.75, animations: {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UICardRowView
        if let card = data?[indexPath.row] {
            cell.item = card
            cell.delegate = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let card = data?[indexPath.row] {
            let edit = UIContextualAction(style: .normal, title: "") { [unowned self] (contextialAction, view, actionPerformed: (Bool) -> Void) in
                self.navigate(page: Page.Form, data: card)
                actionPerformed(true)
            }
            edit.backgroundColor = UIColor.Hex("6BB495")
            edit.image = UIImage(named: "edit.png")
            return UISwipeActionsConfiguration(actions: [edit])
        }
        return UISwipeActionsConfiguration(actions: [])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if let card = data?[indexPath.row] {
            if (card.status == false) {
                return UISwipeActionsConfiguration(actions: [delete(card: card, indexPath: indexPath), logs(card)])
            }
            else {
                return UISwipeActionsConfiguration(actions: [share(card), logs(card)])
            }
        }
        return UISwipeActionsConfiguration(actions: [])
    }
    
    private func confirmDelete(card: Card, indexPath: IndexPath) {
        if let visitor = card.teams["visitor"], let home = card.teams["home"] {
            let game = visitor.uppercased() + " vs " + home.uppercased()
            let alert = UIAlertController(title: game, message: card.date.format("EEEE MMM dd, yyyy"), preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] (action) in
                card.delete({ [unowned self] in
                    if let index = self.data?.firstIndex(where: { $0.id == card.id }) {
                        self.data?.remove(at: index)
                        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.right)
                    }
                })
            }
            alert.addAction(cancel)
            alert.addAction(delete)
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func delete(card: Card, indexPath: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .normal, title: "") { [unowned self] (contextialAction, view, actionPerformed: (Bool) -> Void) in
            self.confirmDelete(card: card, indexPath: indexPath)
            actionPerformed(true)
        }
        delete.backgroundColor = UIColor.Hex("E23729")
        delete.image = UIImage(named: "delete.png")
        return delete
    }
    
    private func logs(_ card: Card) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "") { [unowned self] (contextialAction, view, actionPerformed: (Bool) -> Void) in
            self.navigate(page: Page.Logs, data: card)
            actionPerformed(true)
        }
        action.backgroundColor = UIColor.Hex("136F9A")
        action.image = UIImage(named: "logs.png")
        return action
    }
    
    private func share(_ card: Card) -> UIContextualAction {
        var game: String = card.game
        if let visitor = card.teams["visitor"], let home = card.teams["home"] {
            game = visitor.uppercased() + "vs" + home.uppercased()
        }
        let share = UIContextualAction(style: .normal, title: "") { (contextialAction, view, actionPerformed: (Bool) -> Void) in
            UIPasteboard.general.string = "https://basketball-ending.tk/nba/" + game.removeSpaces() + "/" + card.id
            actionPerformed(true)
        }
        share.backgroundColor = UIColor.Hex("1E879C")
        share.image = UIImage(named: "share.png")
        return share
    }
}
