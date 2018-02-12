//
//  MasterViewController.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/9/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    var searchController: UISearchController! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize the search controller and search bar apperance
        //
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
        let navigationBarAppearace = UINavigationBar.appearance()
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            navigationBarAppearace.barTintColor = UIColor(red: 71.0/255.0, green: 65.0/255.0, blue: 90.0/255.0, alpha: 1.0)
        } else {
            navigationBarAppearace.tintColor = UIColor.black
            navigationBarAppearace.barTintColor = UIColor(red: 97.0/255.0, green: 92.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        }
        searchController.searchBar.tintColor = UIColor.black
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        WebService.getUsers(managedObjectContext) { (users, error) in
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withEvent: event)
        return cell
    }

    func configureCell(_ cell: UITableViewCell, withEvent event: User) {
        guard let userCell = cell as? UserCell else { return }
        userCell.userRealName.text = event.realName
        userCell.userTitle.text = event.title
        
        if let slackName = event.name {
            userCell.userSlackName.text = "@" + slackName
        }
        
        if let colorR = event.colorR?.floatValue,
            let colorG = event.colorG?.floatValue,
            let colorB = event.colorB?.floatValue {
            cell.backgroundColor = UIColor(red: CGFloat(colorR),
                                           green: CGFloat(colorG),
                                           blue: CGFloat(colorB),
                                           alpha: 0.25)
            userCell.userImageView.backgroundColor = UIColor(red: CGFloat(colorR),
                                                             green: CGFloat(colorG),
                                                             blue: CGFloat(colorB),
                                                             alpha: 1.0)
        }
        
        // set and cache the user profile image on the cell
        //
        guard let icon192 = event.icon192, let imageUrl = URL(string:icon192) else { return }
        userCell.userImageView.setImageWith(imageUrl, placeholderImage:nil)
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<User> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                   managedObjectContext: self.managedObjectContext,
                                                                   sectionNameKeyPath: nil,
                                                                   cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<User>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                guard let cell = tableView.cellForRow(at: indexPath!) else { return }
                configureCell(cell, withEvent: anObject as! User)
            case .move:
                guard let cell = tableView.cellForRow(at: indexPath!) else { return }
                configureCell(cell, withEvent: anObject as! User)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         tableView.reloadData()
     }
     */

}

extension MasterViewController: UISearchControllerDelegate {
    
}

extension MasterViewController: UISearchBarDelegate {
    
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        do {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "Master")
            guard let searchString = searchController.searchBar.text, !searchString.isEmpty else {
                fetchedResultsController.fetchRequest.predicate = nil
                try fetchedResultsController.performFetch()
                tableView.reloadData()
                return
            }

            let predicate = NSPredicate(format: "name contains[cd] %@ OR realName contains[cd] %@ OR title contains[cd] %@",
                                        searchString, searchString, searchString)
            fetchedResultsController.fetchRequest.predicate = predicate
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
