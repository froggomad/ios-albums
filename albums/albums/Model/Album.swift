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
    let id: [UUID]
    let name: String
    let songs: [Song]
    
    
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
            title = try songContainer.decode(String.self, forKey: .title)
            id = try songContainer.decode(UUID.self, forKey: .id)
            duration = try songContainer.decode(Double.self, forKey: .duration)
        }
    }
}
