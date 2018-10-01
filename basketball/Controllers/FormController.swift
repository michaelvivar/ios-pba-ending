//
//  FormController.swift
//  basketball
//
//  Created by Michael Vivar on 27/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit
import Eureka

class FormController: FormViewController {
    
    deinit {
        print("De Init: FormController")
    }
    
    var card: Card?
    var value: Card?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        if let data = card {
            if let visitor = data.teams["visitor"], let home = data.teams["home"] {
                setTitle(title: visitor.uppercased() + " vs " + home.uppercased())
            }
            addSwitchToggle()
        }
        else {
            setTitle(title: "CARD")
            setupButtons()
        }
        createForm()
    }
    
    func setupButtons() {
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveData))
        saveBtn.title = ""
        saveBtn.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = saveBtn
        
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.back))
        backButton.title = ""
        backButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (form.validate().count == 0) {
            if let card = self.card {
                _ = self.validate(then: { value in
                    card.update(game: value.game, date: value.date, time: value.time, bet: value.bet, prizes: value.prizes)
                })
            }
        }
    }
    
    @objc func saveData() {
        if (form.validate().count == 0) {
            _ = self.validate(then: { [unowned self] value in
                CardModel(game: value.game, date: value.date, time: value.time, bet: value.bet, prizes: value.prizes).save({
                    
                    self.back()
                })
            })
        }
    }
    
    @objc func back()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func addSwitchToggle() {
        form +++ Section("")
            <<< SwitchRow("statusRow") {
                $0.title = "Status"
                $0.value = card?.status
                }.onChange({ [unowned self] status in
                    self.toggleStatus()
                })
    }
    
    func toggleStatus() {
        if let card = self.card {
            card.toggle({ [unowned self] card in
                self.card = card
            })
        }
    }
    
    lazy var teams: Dictionary<String, String> = {
        var data = Dictionary<String, String>()
        data["ALA"] = "Alaska"
        data["PIER"] = "Batang Pier"
        data["ELITE"] = "Blackwater"
        data["DYIP"] = "Columbian Dyip"
        data["GIN"] = "Ginebra"
        data["HOTSHOTS"] = "Magnolia"
        data["BOLTS"] = "Meralco"
        data["NLEX"] = "NLEX"
        data["PHX"] = "Phoenix"
        data["ROS"] = "Rain or Shine"
        data["SMB"] = "San Miguel"
        data["TNT"] = "Talk 'n Text"
        return data
    }()
}

extension FormController {
    
    func createForm() {
        let times = ["5 PM", "5:30 PM", "6 PM", "6:30 PM", "7 PM", "7:30 PM", "Other"]
        var customTeamA = false
        var customTeamB = false
        var customTime = false
        if let game = card {
            if (!(teams.contains(where: { $0.value == game.teams["visitor"] }))) {
                customTeamA = true
            }
            if (!(teams.contains(where: { $0.value == game.teams["home"] }))) {
                customTeamB = true
            }
            if (game.time != String("")) {
                if ((times.filter { $0 == game.time }).count == 0) {
                    customTime = true
                }
            }
        }
        
        var options = teams.map({ $0.value }).sorted(by: { a, b in a.compare(b) == .orderedAscending })
        options.append("Other")
        form +++ Section("Game")
            <<< ActionSheetRow<String>("teamARow"){
                $0.title = "Team"
                $0.value = customTeamA ? "Other" : card?.teams["visitor"]
                $0.options = options
                $0.hidden = Condition.function(["teamARow"], { form in
                    if (customTeamA) {
                        return true
                    }
                    else {
                        customTeamA = (form.rowBy(tag: "teamARow") as? ActionSheetRow)?.value == "Other"
                        return customTeamA
                    }
                })
                $0.add(rule: RuleMinLength(minLength: 1))
            }
            <<< TextRow("visitorRow") {
                $0.title = "Team"
                $0.value = customTeamA ? card?.teams["visitor"] : ""
                $0.placeholder = card?.teams["visitor"] ?? "..."
                $0.hidden = Condition.function(["teamARow"], { form in
                    return (customTeamA == false)
                })
                $0.add(rule: RuleMinLength(minLength: 1))
            }
            <<< ActionSheetRow<String>("teamBRow"){
                $0.title = "Versus"
                $0.value = customTeamB ? "Other" : card?.teams["home"]
                $0.options = options
                $0.hidden = Condition.function(["teamBRow"], { form in
                    if (customTeamB) {
                        return true
                    }
                    else {
                        customTeamB = (form.rowBy(tag: "teamBRow") as? ActionSheetRow)?.value == "Other"
                        return customTeamB
                    }
                })
                $0.add(rule: RuleMinLength(minLength: 1))
            }
            <<< TextRow("homeRow") {
                $0.title = "Versus"
                $0.value = customTeamB ? card?.teams["home"] : ""
                $0.placeholder = card?.teams["home"] ?? "..."
                $0.hidden = Condition.function(["teamBRow"], { form in
                    return !(customTeamB)
                })
                $0.add(rule: RuleMinLength(minLength: 1))
            }
            <<< DateRow("dateRow"){
                $0.title = "Date"
                $0.value = card?.date ?? Date()
            }
            <<< ActionSheetRow<String>("timeRow"){
                $0.title = "Time"
                $0.options = times
                $0.value = customTime ? "Other" : (card?.time ?? "7 PM")
                $0.hidden = Condition.function(["timeRow"], { form in
                    if (customTime) {
                        return true
                    }
                    else {
                        customTime = (form.rowBy(tag: "timeRow") as? ActionSheetRow)?.value == "Other"
                        return customTime
                    }
                })
                $0.add(rule: RuleMinLength(minLength: 1))
            }
            <<< TextRow("time2Row") {
                $0.title = "Time"
                $0.value = customTime ? (card?.time ?? "") : ""
                $0.placeholder = card?.time ?? "..."
                $0.hidden = Condition.function(["timeRow"], { form in
                    return !(customTime)
                })
                $0.add(rule: RuleMinLength(minLength: 1))
            }
            +++ Section("Bet")
            <<< IntRow("betRow") {
                $0.title = "Amount"
                $0.value = Int(card?.bet ?? 0)
                $0.placeholder = "0"
            }
            +++ Section("Prizes")
            <<< IntRow("firstQtrRow"){
                $0.title = "1st Qtr"
                $0.value = Int(card?.prizes.first ?? 0)
                $0.placeholder = "0"
                }.onChange { [unowned self] row in
                    let secondRow: IntRow? = self.form.rowBy(tag: "secondQtrRow")
                    secondRow?.value = row.value
                    secondRow?.reload()
                    let thirdRow: IntRow? = self.form.rowBy(tag: "thirdQtrRow")
                    thirdRow?.value = row.value
                    thirdRow?.reload()
            }
            <<< IntRow("secondQtrRow"){
                $0.title = "2nd Qtr"
                $0.value = Int(card?.prizes.second ?? 0)
                $0.placeholder = "0"
                $0.add(rule: RuleRequired())
            }
            <<< IntRow("thirdQtrRow"){
                $0.title = "3rd Qtr"
                $0.value = Int(card?.prizes.third ?? 0)
                $0.placeholder = "0"
            }
            <<< IntRow("fourthQtrRow"){
                $0.title = "4th Qtr"
                $0.value = Int(card?.prizes.fourth ?? 0)
                $0.placeholder = "0"
            }
            <<< IntRow("reverseRow"){
                $0.title = "Reverse"
                $0.value = Int(card?.prizes.reverse ?? 0)
                $0.placeholder = "0"
        }
    }
    
    func validate(then: @escaping(_ card: Card) -> Void) -> Bool {
        var teamA = ""
        var teamB = ""
        var time = ""
        if let _teamA: String = form.rowBy(tag: "teamARow")?.baseValue as? String {
            teamA = _teamA
        }
        if (teamA == "Other") {
            if let _visitor: String = form.rowBy(tag: "visitorRow")?.baseValue as? String {
                teamA = _visitor
            }
            else {
                return false
            }
        }
        if let _teamB: String = form.rowBy(tag: "teamBRow")?.baseValue as? String {
            teamB = _teamB
        }
        if (teamB == "Other") {
            if let _home: String = form.rowBy(tag: "homeRow")?.baseValue as? String {
                teamB = _home
            }
            else {
                return false
            }
        }
        
        if let _time: String = form.rowBy(tag: "timeRow")?.baseValue as? String {
            time = _time
        }
        if (time == "Other") {
            if let _time2: String = form.rowBy(tag: "time2Row")?.baseValue as? String {
                time = _time2
            }
            else {
                return false
            }
        }
        
        if (teamA.isEmpty || teamB.isEmpty || time.isEmpty) {
            return false
        }
        
        guard let date: Date = form.rowBy(tag: "dateRow")?.baseValue as? Date else { return false }
        guard let bet: Int = form.rowBy(tag: "betRow")?.baseValue as? Int else { return false }
        guard let first: Int = form.rowBy(tag: "firstQtrRow")?.baseValue as? Int else { return false }
        guard let second: Int = form.rowBy(tag: "secondQtrRow")?.baseValue as? Int else { return false }
        guard let third: Int = form.rowBy(tag: "thirdQtrRow")?.baseValue as? Int else { return false }
        guard let fourth: Int = form.rowBy(tag: "fourthQtrRow")?.baseValue as? Int else { return false }
        guard let reverse: Int = form.rowBy(tag: "reverseRow")?.baseValue as? Int else { return false }
        
        let game = teamA + " vs " + teamB
        
        let card = Card(id: "", game: game, date: date, time: time, bet: bet, status: true, progress: 0, prizes: Prizes(firstQtr: first, secondQtr: second, thirdQtr: third, fourthQtr: fourth, reverse: reverse), slots: nil, logs: nil)
        
        then(card)
        
        return true
    }
}
