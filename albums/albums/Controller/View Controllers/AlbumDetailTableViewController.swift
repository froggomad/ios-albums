//
//  AlbumDetailTableViewController.swift
//  albums
//
//  Created by Kenny on 2/10/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class AlbumDetailTableViewController: UITableViewController {
    //=======================
    // MARK: - Outlets
    @IBOutlet weak var albumNameTextField: UITextField!
    @IBOutlet weak var albumArtistTextField: UITextField!
    @IBOutlet weak var albumGenresTextField: UITextField!
    @IBOutlet weak var albumURLsTextField: UITextField!
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = albumNameTextField?.text,
            !name.isEmpty,
            let artist = albumArtistTextField?.text,
            !artist.isEmpty,
            let genres = albumGenresTextField?.text,
            !genres.isEmpty,
            let urls = albumURLsTextField?.text,
            !urls.isEmpty
        else { return }
        let urlStringArr = urls.components(separatedBy: ",")
        let urlArr = urlStringArr.compactMap { URL(string: $0) }
        
        let genreArr = genres.components(separatedBy: ",")
        if let album = album {
            albumController?.update(album: album, artist: artist, coverArt: urlArr, genres: genreArr, id: album.id, name: name, songs: tempSongs)
        } else {
            albumController?.createAlbum(artist: artist, coverArt: urlArr, genres: genreArr, id: UUID(), name: name, songs: tempSongs)
        }
        navigationController?.popViewController(animated: true)
    }
    //=======================
    // MARK: - Properties
    var album: Album? {
        didSet {
            updateViews()
        }
    }
    var albumController: AlbumController?
    var tempSongs: [Album.Song] = []
    enum CellIdentifier: String {
        case id = "SongTableViewCell"
    }
    
    //=======================
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func prettyPrintURLs() -> String {
        guard let album = album else { return "error"}
        var returnString = ""
        for (index, url) in album.coverArt.enumerated() {
            if index != album.genres.count - 1 {
                returnString.append("\(url), ")
            } else {
                returnString.append("\(url)")
            }
            
        }
        return returnString
    }
    
    func prettyPrintGenres() -> String {
        guard let album = album else { return "error"}
        var returnString = ""
        for (index, genre) in album.genres.enumerated() {
            if index != album.genres.count - 1 {
                returnString.append("\(genre), ")
            } else {
                returnString.append("\(genre)")
            }
        }
        return returnString
    }
    
    func updateViews() {
        guard let album = album else {
            title = "New Album"
            return
        }
        albumNameTextField?.text = album.name
        albumArtistTextField?.text = album.artist
        albumGenresTextField?.text = prettyPrintGenres()
        albumURLsTextField?.text = prettyPrintURLs()
        title = album.name
        self.tempSongs = album.songs
    }

    //=======================
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempSongs.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.id.rawValue, for: indexPath) as? SongTableViewCell else { return UITableViewCell()}
        if album?.songs.count != indexPath.row {
            cell.song = album?.songs[indexPath.row]
            cell.delegate = self
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == tempSongs.count - 1 {
            return 140
        } else {
            return 100
        }
    }

}

extension AlbumDetailTableViewController: SongTableViewCellDelegate {
    func addSong(with title: String, duration: String) {
        guard let song = albumController?.createSong(duration: duration, id: UUID(), title: title) else { return }
        tempSongs.append(song)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: tempSongs.count, section: 0), at: .top, animated: true)
    }
}


