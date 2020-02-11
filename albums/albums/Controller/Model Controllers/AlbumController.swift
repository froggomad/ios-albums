//
//  AlbumController.swift
//  albums
//
//  Created by Kenny on 2/10/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

class AlbumController {
    
    //=======================
    // MARK: - Properties
    var albums: [Album] = []
    let baseUrl = URL(string: "https://lambda-intermediate-codable.firebaseio.com/")!
    typealias CompleteWithError = (Error?) -> ()
    
    //=======================
    // MARK: - Create
    func createAlbum(artist: String,
                     coverArt: [URL],
                     genres: [String],
                     id: UUID,
                     name: String,
                     songs: [Album.Song]) {
        
        let album = Album(artist: artist,
                      coverArt: coverArt,
                      genres:genres,
                      id:id,
                      name:name,
                      songs:songs)
        albums.append(album)
        putAlbum(album) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    //=======================
    // MARK: - Read/Get
    func getAlbums(complete: @escaping CompleteWithError) {
        var request = URLRequest(url: baseUrl.appendingPathExtension("json"))
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                complete(error)
                return
            }
            if let data = data {
                print(String(data: data, encoding: .utf8))
                let decoder = JSONDecoder()
                do {
                    let albums = try decoder.decode([String:Album].self, from: data)
                    self.albums = albums.map { $1 }
                } catch {
                    complete(error)
                    return
                }
                print(self.albums)
                complete(nil)
            } else {
                let error = NSError(domain: "AlbumController.getAlbums.decode", code: 999)
                complete(error)
            }
        }.resume()
    }
    
    //=======================
    // MARK: - Update/PUT
    func putAlbum(_ album: Album, complete: @escaping CompleteWithError) {
        let url = baseUrl
        .appendingPathComponent(album.id.uuidString)
        .appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(album)
        } catch {
            print(error)
            complete(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                complete(error)
                return
            }
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                print("error: \(response.statusCode)")
                complete(error)
            } else {
                complete(nil)
            }
        }.resume()
    }
    
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
            print(String(describing: album))
        } catch {
            print(error)
        }
        let encoder = JSONEncoder()
        #warning("unstable! testing only!")
        print(String(data: try! encoder.encode(album), encoding: .utf8)!)
    }
}
