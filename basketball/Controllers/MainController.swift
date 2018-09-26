//
//  MainController.swift
//  basketball
//
//  Created by Michael Vivar on 24/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class MainController: TableController, DataManagerDelegate {
    func reload(with data: Any) {
        if let card: Card = data as? Card {
            if let index = cards?.firstIndex(where: { $0.id == card.id}) {
                cards?[index] = card
            }
        }
        //cards = DataManager.all(Card.self)
        tableView.reloadData()
    }
    
    var cards: [Card]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setTitle(title: "GAMES")
        setupTableView()
        
        //Card(id: "HYRDE", game: "Ginebra vs Magnolia", date: Date(), time: "5 PM", bet: 100, status: true, progress: 0, prizes: Prizes(first: 1000, second: 2000, third: 3000, fourth: 4000, reverse: 5000), slots: nil, logs: nil).save()
    }
    
    /*
    // MARK: - Navigation
    */
}

extension MainController {
    
    func setupTableView() {
        tableView.reloadData()
        tableView.register(UICardRowView.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = cards {
            return data.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cards?[indexPath.row].game
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = cards {
            navigate(page: Page.Card, data: data[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if let card = cards?[indexPath.row] {
            if (card.status == false) {
                return UISwipeActionsConfiguration(actions: [])
            }
            else {
                return UISwipeActionsConfiguration(actions: [logs(card)])
            }
        }
        return UISwipeActionsConfiguration(actions: [])
    }
    
    private func logs(_ card: Card) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Logs") { [unowned self] (contextialAction, view, actionPerformed: (Bool) -> Void) in
            self.navigate(page: Page.Logs, data: card)
            actionPerformed(true)
        }
        action.backgroundColor = UIColor.Hex("136F9A")
        return action
    }
}
