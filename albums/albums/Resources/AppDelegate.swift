//
//  AppDelegate.swift
//  albums
//
//  Created by Kenny on 2/10/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let albumController = AlbumController()
        
        albumController.createAlbum(artist: "me",
                                    coverArt: [URL(string: "www.google.com")!],
                                    genres: ["Nothing"],
                                    id: UUID(), name: "a name",
                                    songs: [Album.Song(duration: "3:05",
                                                       id: UUID(),
                                                       title: "A Song")]
        )
        
        albumController.getAlbums { (error) in
            if let error = error {
                print(error)
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

