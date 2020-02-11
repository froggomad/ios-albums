//
//  AlbumsTableViewController.swift
//  albums
//
//  Created by Kenny on 2/10/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class AlbumsTableViewController: UITableViewController {

    //=======================
    // MARK: - Properties
    var albumController: AlbumController = AlbumController()
    enum SegueIdentifiers: String {
        case barButton = "ButtonDetailSegue"
        case cell = "AddAlbumSegue"
    }
    enum CellIdentifier: String {
        case id = "genericCell"
    }
    
    //=======================
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        albumController.getAlbums { error in
            if let error = error {
                print(error)
            }
            print(self.albumController.albums)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    //=====================================
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumController.albums.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.id.rawValue, for: indexPath)
        cell.textLabel?.text = albumController.albums[indexPath.row].name
        cell.detailTextLabel?.text = albumController.albums[indexPath.row].artist
        return cell
    }
    
    //=======================
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AlbumDetailTableViewController else { return }
        destination.albumController = albumController
        if segue.identifier == SegueIdentifiers.barButton.rawValue {
            let indexPath = tableView.indexPathForSelectedRow
            destination.album = albumController.albums[indexPath?.row ?? 0]
        }
    }
}
