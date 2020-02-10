//
//  Album.swift
//  albums
//
//  Created by Kenny on 2/10/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

struct Album: Decodable {
    
    let artist: String
    let coverArt: [URL]
    let genres: [String]
    let id: UUID
    let name: String
    let songs: [Song]
    
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
    
    init(from decoder: Decoder) throws {
        do {
            let albumContainer = try decoder.container(keyedBy: AlbumKeys.self)
            artist = try albumContainer.decode(String.self, forKey: .artist)
            
            var coverArtContainer = try albumContainer.nestedUnkeyedContainer(forKey: .coverArt)
            var coverArtUrls = [URL]()
            let urlContainer = try coverArtContainer.nestedContainer(keyedBy: CoverArtKey.self)
            while !coverArtContainer.isAtEnd {
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
    
    
    
    struct Song: Decodable {
        let duration: Double
        /*
         "duration" : {
         "duration" : "3:25"
         }
         */
        let id: UUID
        let title: String
        
        enum SongKeys: String, CodingKey {
            case id
            case title
            case duration
        }
        
        enum DurationKeys: String, CodingKey {
            case duration
        }
        
        init(from decoder: Decoder) throws {
            let songContainer = try decoder.container(keyedBy: SongKeys.self)
            do {
                title = try songContainer.decode(String.self, forKey: .title)
                id = try songContainer.decode(UUID.self, forKey: .id)
                duration = try songContainer.decode(Double.self, forKey: .duration)
            } catch {
                throw error
            }
        }
    }
}
