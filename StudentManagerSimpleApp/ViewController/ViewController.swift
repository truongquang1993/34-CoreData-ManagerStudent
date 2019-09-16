//
//  ViewController.swift
//  StudentManagerSimpleApp
//
//  Created by Trương Quang on 9/16/19.
//  Copyright © 2019 truongquang. All rights reserved.
//

import UIKit
import CoreData

extension NSNotification.Name {
    static let passDataFromDetailVC = NSNotification.Name(rawValue: "passDataFromDetailVC")
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var noDataView: UIView!
    @IBOutlet weak var bottomSlideViewDelete: NSLayoutConstraint!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var addInforBtn: UIBarButtonItem!
    
    var showing = false {
        didSet {
            UIView.animate(withDuration: 0.2
                , animations: {
                    self.bottomSlideViewDelete.constant = self.showing ? 0 : -(self.viewDelete.bounds.width * 2)
                    self.view.layoutIfNeeded()
            })
        }
    }
    
    let heightForRow: CGFloat = 72.00
    var listInforContact = [InforContact]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managerObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managerObjectContext = appDelegate.persistentContainer.viewContext
        
        title = "Contacts"
        showing = false
        navigationItem.leftBarButtonItem = editButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(addInfor), name: .passDataFromDetailVC, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        loadData()
        checkNoData()
    }
    
    fileprivate func loadData() {
        let inforFetchRequest: NSFetchRequest<InforContact> = InforContact.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        inforFetchRequest.sortDescriptors = [sortDescriptor]
        do {
            listInforContact = try managerObjectContext?.fetch(inforFetchRequest) ?? []
        } catch {
            print(error)
        }
    }
    
    fileprivate func checkNoData() {
        if listInforContact.count == 0 {
            tableView.tableFooterView = noDataView
            navigationItem.leftBarButtonItem?.isEnabled = false
            setEditing(false, animated: true)
        } else {
            tableView.tableFooterView = UIView()
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
        tableView.allowsMultipleSelectionDuringEditing = true
        if isEditing {
            showing = true
            addInforBtn.isEnabled = false
        } else{
            showing = false
            addInforBtn.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc2 = segue.destination as? DetailViewController{
            vc2.moc = managerObjectContext
            if let indexPath = tableView.indexPathForSelectedRow{
                vc2.inforContact = listInforContact[indexPath.row]
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isEditing {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func didTapDelete(_ sender: Any) {
        guard let arrayOfIndexPathForSelectedRow = tableView.indexPathsForSelectedRows?.sorted().reversed() else {return}
        for i in arrayOfIndexPathForSelectedRow {
            deleteRowAtIndexPath(indexPath: i)
        }
        checkNoData()
    }
    
    @IBAction func didTapDeleteAll(_ sender: Any) {
        for i in 0..<listInforContact.count {
            managerObjectContext?.delete(listInforContact[i])
        }
        appDelegate.saveContext()
        listInforContact.removeAll()
        tableView.reloadData()
        checkNoData()
    }
    
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {
    }
    
    @objc func addInfor(notification: Notification) {
        let inforContact = notification.object as? InforContact
        if let indexPath = tableView.indexPathForSelectedRow {
            listInforContact[indexPath.row] = inforContact!
        } else {
            listInforContact.append(inforContact!)
        }
        appDelegate.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listInforContact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.inforContact = listInforContact[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRowAtIndexPath(indexPath: indexPath)
            checkNoData()
        }
    }
    
    fileprivate func deleteRowAtIndexPath(indexPath: IndexPath) {
        managerObjectContext?.delete(listInforContact[indexPath.row])
        listInforContact.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        appDelegate.saveContext()
    }
}
