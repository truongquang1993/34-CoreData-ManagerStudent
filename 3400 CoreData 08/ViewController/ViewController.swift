//
//  ViewController.swift
//  3400 CoreData 08
//
//  Created by Trương Quang on 7/15/19.
//  Copyright © 2019 truongquang. All rights reserved.
//

import UIKit
import CoreData

extension NSNotification.Name {
    static let passDataVC2 = NSNotification.Name(rawValue: "passDataVC2")
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var outletTableView: UITableView!
    var listInfor = [InforManager]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managerObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managerObjectContext = appDelegate.persistentContainer.viewContext
        
        outletTableView.delegate = self
        outletTableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(addInfor), name: .passDataVC2, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        outletTableView.reloadData()
        loadData()
    }
    
    func loadData() {
        let inforFetchRequest: NSFetchRequest<InforManager> = InforManager.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        inforFetchRequest.sortDescriptors = [sortDescriptor]
        do {
            listInfor = try managerObjectContext?.fetch(inforFetchRequest) ?? []
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listInfor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        cell.inforStudent = listInfor[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc2 = segue.destination as? MyViewController{
            vc2.moc = managerObjectContext
            if let indexPath = outletTableView.indexPathForSelectedRow{
                vc2.inforStudent = listInfor[indexPath.row]
            }
        }
    }
    
    @objc func addInfor(notification: Notification) {
        let inforStudent = notification.object as? InforManager
        if let indexPath = outletTableView.indexPathForSelectedRow {
            listInfor[indexPath.row] = inforStudent!
        } else {
            listInfor.append(inforStudent!)
        }
        appDelegate.saveContext()
    }
    
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            managerObjectContext?.delete(listInfor[indexPath.row])
            listInfor.remove(at: indexPath.row)
            outletTableView.deleteRows(at: [indexPath], with: .automatic)
            appDelegate.saveContext()
        }
    }
    
}

