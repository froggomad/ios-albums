//
//  SongTableViewCell.swift
//  albums
//
//  Created by Kenny on 2/10/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

protocol SongTableViewCellDelegate: class {
    func addSong(with title: String, duration: String)
}

class SongTableViewCell: UITableViewCell {
    //=======================
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var addSongButton: UIButton!
    
    //=======================
    // MARK: - IBActions
    @IBAction func addSongButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text,
            !title.isEmpty,
            let duration = durationTextField.text,
            !duration.isEmpty
        else { return }
        delegate?.addSong(with: title, duration: duration)
    }
    
    //=======================
    // MARK: - Properties
    var song: Album.Song? {
        didSet {
            updateViews()
        }
    }
    weak var delegate: SongTableViewCellDelegate?
    
    //=======================
    // MARK: - View Lifecycle
    override func prepareForReuse() {
        titleTextField?.text = ""
        durationTextField?.text = ""
        addSongButton.isHidden = false
    }
    
    func updateViews() {
        if let song = song {
            titleTextField?.text = song.title
            durationTextField?.text = song.duration
            addSongButton.isHidden = true
        }
    }

}
