//
//  AlbumController.swift
//  albums
//
//  Created by Kenny on 2/10/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

class AlbumController {
    
    
    #warning("Unsafe handling - testing only!")
    func testDecodingExampleAlbum() {
        let decoder = JSONDecoder()
        let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json")
        let jsonData = try! Data(contentsOf: urlPath!)
        let album = try! decoder.decode(Album.self, from: jsonData)
        print(album)
    }
}
