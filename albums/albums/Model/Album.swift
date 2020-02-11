//
//  Album.swift
//  albums
//
//  Created by Kenny on 2/10/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

struct Album: Codable {
    //=======================
    // MARK: - Properties
    let artist: String
    let coverArt: [URL]
    let genres: [String]
    let id: UUID
    let name: String
    let songs: [Song]
    
    //=======================
    // MARK: - CodingKeys
    enum AlbumKeys: String, CodingKey {
        case artist
        case coverArt
        case genres
        case id
        case name
        case songs
    }
    
    enum CoverArtKey: String, CodingKey {
        case url
    }
    
    //=======================
    // MARK: - Decoder Init
    init(from decoder: Decoder) throws {
        do {
            let albumContainer = try decoder.container(keyedBy: AlbumKeys.self)
            artist = try albumContainer.decode(String.self, forKey: .artist)
            
            var coverArtContainer = try albumContainer.nestedUnkeyedContainer(forKey: .coverArt)
            var coverArtUrls = [URL]()
            while !coverArtContainer.isAtEnd {
                let urlContainer = try coverArtContainer.nestedContainer(keyedBy: CoverArtKey.self)
                coverArtUrls.append(try urlContainer.decode(URL.self, forKey: .url))
            }
            coverArt = coverArtUrls
            
            genres = try albumContainer.decode([String].self, forKey: .genres)
            id = try albumContainer.decode(UUID.self, forKey: .id)
            name = try albumContainer.decode(String.self, forKey: .name)
            songs = try albumContainer.decode([Song].self, forKey: .songs)
        } catch {
            throw error
        }
    }
    //=======================
    // MARK: - Standard Init
    init(artist: String,
         coverArt: [URL],
         genres: [String],
         id: UUID,
         name: String,
         songs: [Song]) {
        self.artist = artist
        self.coverArt = coverArt
        self.genres = genres
        self.id = id
        self.name = name
        self.songs = songs
    }
    
    //=======================
    // MARK: - Encoding strategy
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AlbumKeys.self)
        var coverArtDict = [[String:URL]]()
        for url in coverArt {
            coverArtDict.append(["url":url])
        }
        
        do {
            try container.encode(coverArtDict, forKey: .coverArt)
            try container.encode(artist, forKey: .artist)
            try container.encode(genres, forKey: .genres)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(songs,forKey: .songs)
        } catch {
            throw error
        }
    }
    
    struct Song: Codable {
        //=======================
        // MARK: - Properties
        let duration: String
        let id: UUID
        let title: String
        
        //=======================
        // MARK: - CodingKeys
        enum SongKeys: String, CodingKey {
            case id
            case title = "name"
            case duration
        }
        
        enum TitleKey: String, CodingKey {
            case title
        }
        
        enum DurationKey: String, CodingKey {
            case duration
        }
        
        //=======================
        // MARK: - Decoder Init
        init(from decoder: Decoder) throws {
            let songContainer = try decoder.container(keyedBy: SongKeys.self)
            do {
                let titleContainer = try songContainer.nestedContainer(keyedBy: TitleKey.self, forKey: .title)
                title = try titleContainer.decode(String.self, forKey: .title)
                id = try songContainer.decode(UUID.self, forKey: .id)
                
                let durationContainer = try songContainer.nestedContainer(keyedBy: DurationKey.self, forKey: .duration)
                duration = try durationContainer.decode(String.self, forKey: .duration)
            } catch {
                throw error
            }
        }
        
        //=======================
        // MARK: - Standard Init
        init(duration: String,
             id: UUID,
             title: String) {
            self.duration = duration
            self.id = id
            self.title = title
        }
        
        //=======================
        // MARK: - Encoding Strategy
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: SongKeys.self)
            let durationDict = [SongKeys.duration.rawValue:duration]
            let titleDict = [TitleKey.title.rawValue:title]
            
            do {
                try container.encode(titleDict, forKey: .title)
                try container.encode(id, forKey: .id)
                try container.encode(durationDict, forKey: .duration)
            } catch {
                throw error
            }
        }
    }
}
