//
//  AlbumController.swift
//  albums
//
//  Created by Kenny on 2/10/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

class AlbumController {
    
    class func testDecodingExampleAlbum() {
        let decoder = JSONDecoder()
        let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json")
        do {
            let jsonData = try Data(contentsOf: urlPath!)
            let album = try decoder.decode(Album.self, from: jsonData)
            print(album)
        } catch {
            print(error)
        }
    }
    
    class func testEncodingExampleAlbum() {
        var album: Album!
        let decoder = JSONDecoder()
        let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json")
        do {
            let jsonData = try Data(contentsOf: urlPath!)
            album = try decoder.decode(Album.self, from: jsonData)
            print(album)
        } catch {
            print(error)
        }
        let encoder = JSONEncoder()
        print(String(data: try! encoder.encode(album), encoding: .utf8))
    }
}
