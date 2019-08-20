//
//  AppDelegate.swift
//  basketball
//
//  Created by Michael Vivar on 24/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit
import Firebase
import Firestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var listener: FIRListenerRegistration!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        let seeding = false
        
        CardRepository.shared.read({ [unowned self] cards in
            if (seeding) {
                print("Seeding...")
                Seeder().initialize({ data in
                    print("Seeding: Done!")
                    self.setupController(data)
                })
            }
            else {
                self.setupController(cards)
            }
        })
        
        return true
    }
    
    func setupController(_ cards: [Card]) {
        window = UIWindow()
        window?.makeKeyAndVisible()
        let controller = MainController()
        window?.rootViewController = UINavigationController(rootViewController: controller)
        CardRepository.shared.delegate = controller
        controller.cards = cards
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        listener.remove()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let controller = UIApplication.mainController() as? MainController, let active = UIApplication.activeController() {
            if (controller == active) {
                // controller.refresh()
                addListener({ data in
                    CardRepository.shared.read({ cards in
                        controller.reload(with: cards);
                    })
                })
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }

    // MARK: - Core Data stack
    /*
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "basketball")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    */
    
    func addListener(_ then: @escaping(_ cards: [Card]) -> Void) {
        listener = Store.firestore.addSnapshotListener({
            snapshot, error in
            if let error = error {
                print(error)
            }
            else {
                if let snapshot = snapshot {
                    let cards: [Card]? = snapshot.documents.compactMap({ doc in
                        let data = doc.data() as [String: Any]
                        guard let game = data["game"] as? String else { return nil }
                        guard let date = data["date"] as? Date else { return nil }
                        guard let time = data["time"] as? String else { return nil }
                        guard let bet = data["bet"] as? Int else { return nil }
                        guard let status = data["status"] as? Bool else { return nil }
                        guard let progress = data["progress"] as? Int else { return nil }
                        guard let prizes = data["prizes"] as? [String : Any] else { return nil }
                        guard let firstQtr = prizes["first"] as? Int else { return nil }
                        guard let secondQtr = prizes["second"] as? Int else { return nil }
                        guard let thirdQtr = prizes["third"] as? Int else { return nil }
                        guard let fourthQtr = prizes["fourth"] as? Int else { return nil }
                        guard let reverse = prizes["reverse"] as? Int else { return nil }
                        let deleted = (data["deleted"] as? Bool) ?? false
                        let id = deleted ? "" : doc.documentID
                        let card = Card(id: id, game: game, date: date, time: time,
                                        bet: bet, status: status, progress: progress,
                                        prizes: Prizes(firstQtr: firstQtr, secondQtr: secondQtr, thirdQtr: thirdQtr, fourthQtr: fourthQtr, reverse: reverse),
                                        slots: nil, logs: nil
                        )
                        return card
                    })
                    if let cards = cards {
                        let filtered = cards.filter({ $0.id != "" })
                        DataManager.save(filtered, name: "cards", folder: nil, completion: {
                            then(filtered)
                        })
                    }
                }
            }
        })
    }
}

