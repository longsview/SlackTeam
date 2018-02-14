//
//  UserListViewController.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/9/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import UIKit
import CoreData

protocol UserListViewModelProtocol {
    var filterString: String? { get set }
    var sortString: String { get set }
    var userCount: Int { get }
    
    func userAtIndex(_ index: Int) -> User?
    func reload()
}

protocol UserListViewDelegate: NSFetchedResultsControllerDelegate {
    func loaded()
}

class UserListViewController: UITableViewController, UserListViewDelegate {

    var searchController: UISearchController! = nil
    var viewModel: UserListViewModelProtocol?
    var connectionErrorView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = UserListViewModel(view: self)
        
        // initialize the search controller and search bar apperance
        //
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barStyle = .black
            
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: UIImage(named: "slack")))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sort"), style: .plain, target: self, action: #selector(sort))
        
        initializeConnectionErrorView()
        
        // registers peek and pop if available
        //
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        // listen for connection changes in order to
        // notify the user
        //
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(connectionEstablished),
                                               name: ConnectionChanged.connected.notificationName(),
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(disconnected),
                                               name: ConnectionChanged.disconnected.notificationName(),
                                               object: nil)
    }

    deinit {
        NotificationCenter.removeObserver(self, forKeyPath: ConnectionChanged.connected.rawValue)
        NotificationCenter.removeObserver(self, forKeyPath: ConnectionChanged.disconnected.rawValue)
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        
        // check if we need to push down the no connection view
        //
        if !ConnectionManager.shared.hasConnection {
            toggleNoConnectionView(true)
        }
        
        super.viewWillAppear(animated)
    }

    func initializeConnectionErrorView() {
        connectionErrorView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        guard let connectionErrorView = connectionErrorView else { return }
        connectionErrorView.translatesAutoresizingMaskIntoConstraints = false
        connectionErrorView.backgroundColor = .red
        connectionErrorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let noConnectionLabel = UILabel()
        connectionErrorView.addSubview(noConnectionLabel)
        noConnectionLabel.translatesAutoresizingMaskIntoConstraints = false
        noConnectionLabel.textColor = .white
        noConnectionLabel.text = "No Connection"
        noConnectionLabel.textAlignment = .center
        noConnectionLabel.bounds = connectionErrorView.bounds

        noConnectionLabel.centerXAnchor.constraint(equalTo: connectionErrorView.centerXAnchor).isActive = true
        noConnectionLabel.widthAnchor.constraint(equalTo: connectionErrorView.widthAnchor).isActive = true
        noConnectionLabel.heightAnchor.constraint(equalTo: connectionErrorView.heightAnchor).isActive = true
        noConnectionLabel.topAnchor.constraint(equalTo: connectionErrorView.topAnchor).isActive = true
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let user = viewModel?.userAtIndex(indexPath.row) else { return }
                if let controller = (segue.destination as! UINavigationController).topViewController as? UserViewController {
                    controller.detailItem = user
                }
            }
        }
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.userCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let user = viewModel?.userAtIndex(indexPath.row) else { return cell }
        configureCell(cell, withEvent: user)
        return cell
    }

    func configureCell(_ cell: UITableViewCell, withEvent event: User) {
        guard let userCell = cell as? UserCell else { return }
        userCell.userRealName.text = event.realName
        userCell.userTitle.text = event.title
        
        if let slackName = event.name {
            userCell.userSlackName.text = "@" + slackName
        }
        
        if let colorR = event.colorR?.floatValue, let colorG = event.colorG?.floatValue, let colorB = event.colorB?.floatValue {
            cell.backgroundColor = UIColor(red: CGFloat(colorR),
                                           green: CGFloat(colorG),
                                           blue: CGFloat(colorB),
                                           alpha: 0.1)
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

    func loaded() {
        // remove any loading state here
    }

    func toggleNoConnectionView(_ state: Bool) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.tableHeaderView = state ? self?.connectionErrorView : nil
            if state {
                strongSelf.connectionErrorView?.widthAnchor.constraint(equalTo: strongSelf.tableView.widthAnchor).isActive = true
            }
        }
    }
    
    @objc
    func connectionEstablished() {
        toggleNoConnectionView(false)
        // if we have reconnected reload the data
        //
        viewModel?.reload()
    }

    @objc
    func disconnected() {
        toggleNoConnectionView(true)
    }
}

extension UserListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
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
}

extension UserListViewController {
    @objc
    func sort() {
        // add an action sheet with the different types of sorting supported
        //
        let sheet = UIAlertController(title: NSLocalizedString("SORT BY", comment: "Sort"),
                                      message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Full Name", style: .default, handler: { [weak self] action in
            self?.viewModel?.sortString = "realName"
            self?.tableView.reloadData()
        }))
        sheet.addAction(UIAlertAction(title: "Slack Name", style: .default, handler: { [weak self] action in
            self?.viewModel?.sortString = "name"
            self?.tableView.reloadData()
        }))
        sheet.addAction(UIAlertAction(title: "First Name", style: .default, handler: { [weak self] action in
            self?.viewModel?.sortString = "firstName"
            self?.tableView.reloadData()
        }))
        sheet.addAction(UIAlertAction(title: "Last Name", style: .default, handler: { [weak self] action in
            self?.viewModel?.sortString = "lastName"
            self?.tableView.reloadData()
        }))
        sheet.addAction(UIAlertAction(title: "Title", style: .default, handler: { [weak self] action in
            self?.viewModel?.sortString = "title"
            self?.tableView.reloadData()
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        
        if let popoverPresentationController = sheet.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.barButtonItem = navigationItem.rightBarButtonItem
        }
        present(sheet, animated: true)
    }
}

extension UserListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.filterString = searchController.searchBar.text
        tableView.reloadData()
    }
}

extension UserListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView?.indexPathForRow(at: location),
            let cell = tableView?.cellForRow(at: indexPath),
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? UserViewController,
            let detail = viewModel?.userAtIndex(indexPath.row) else { return nil }
        
        detailVC.detailItem = detail
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 600)
        previewingContext.sourceRect = cell.frame
        
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        showDetailViewController(viewControllerToCommit, sender: self)
    }
}
