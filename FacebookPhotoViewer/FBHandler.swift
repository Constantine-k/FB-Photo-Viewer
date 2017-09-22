//
//  FBHandler.swift
//  FacebookPhotoViewer
//
//  Created by Konstantin Konstantinov on 9/16/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import Foundation

import FBSDKCoreKit
import FBSDKLoginKit

class FBHandler {
    
    enum PhotoSize: Int {
        case small = 225
        case medium
        case full
    }
    
    /// List of all user's albums
    var albumList = [Album]()
    /// List of user's photos for current album
    var photoList = [Photo]()
    
    /// Fetch album list via Graph Request and save it in `albumList`
    func fetchAlbums() {
        FBSDKGraphRequest(graphPath: "/me/albums", parameters: ["fields":"id,name,cover_photo, images"], httpMethod: "GET").start {
            (connection, result, error) in
            if error == nil {
                if let resultDictionary = result as? [String: Any],
                    let resultDictionaryData = resultDictionary["data"] as? [[String: Any]] {
                    for albumAttributes in resultDictionaryData {
                        if let albumID = albumAttributes["id"],
                            let albumName = albumAttributes["name"],
                            let albumCoverPhotoDictionary = albumAttributes["cover_photo"] as? [String: Any] {
                            if let albumCoverPhotoID = albumCoverPhotoDictionary["id"] {
                                self.albumList.append(Album(id: String(describing: albumID), name: String(describing: albumName), coverPhotoID: String(describing: albumCoverPhotoID), coverPhotoURL: nil))
                                self.fetchCoverPhotoURL(by: String(describing: albumCoverPhotoID))
                            }
                        }
                    }
                }
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        NotificationCenter.default.post(name: Notification.Name("AlbumsFetched"), object: nil)
        }
    }
    
    /// Fetch album cover photo URL by album id via Graph Request and save it in `albumList`
    func fetchCoverPhotoURL(by id: String, size: PhotoSize = .small) {
        var imageURL: URL?
        FBSDKGraphRequest(graphPath: id, parameters: ["fields":"images"], httpMethod: "GET").start {
            (connection, result, error) in
            if error == nil {
                if let result = result as? [String: Any],
                    let resultImages = result["images"] as? [[String: Any]] {
                    imageLoop: for (imageIndex, imageAttributes) in resultImages.enumerated() {
                        if imageIndex == 0 {
                            if let imageSource = imageAttributes["source"] as? String {
                                imageURL = URL(string: imageSource)
                            }
                        } else {
                            switch size {
                            case .small:
                                if let imageWidth = imageAttributes["width"] as? Int,
                                    let imageSource = imageAttributes["source"] as? String {
                                    if imageWidth == size.rawValue {
                                        imageURL = URL(string: imageSource)
                                    }
                                }
                                break imageLoop
                            default:
                                break
                            }
                        }
                    }
                }
            } else {
                print("Error: \(error!.localizedDescription)")
            }
            
            for (albumIndex, albumItem) in self.albumList.enumerated() {
                if albumItem.coverPhotoID == id {
                    self.albumList[albumIndex].coverPhotoURL = imageURL
                }
            }
            
            NotificationCenter.default.post(name: Notification.Name("CoverPhotoFetched"), object: nil)
            
        }
    }
    
    /// Fetch photo list via Graph Request and save it in `photoList`
    func fetchPhotos(by id: String) {
        FBSDKGraphRequest(graphPath: "/\(id)/photos", parameters: nil, httpMethod: "GET").start {
            (connection, result, error) in
            if error == nil {
                if let resultDictionary = result as? [String: Any],
                    let resultDictionaryData = resultDictionary["data"] as? [[String: Any]] {
                    for photoAttributes in resultDictionaryData {
                        if let photoID = photoAttributes["id"],
                            let photoTime = photoAttributes["created_time"] {
                            self.photoList.append(Photo(id: String(describing: photoID), createdTime: String(describing: photoTime), imageURL: nil, thumbnailImageURL: nil))
                            self.fetchPhotoURL(by: String(describing: photoID))
                        }
                    }
                }
            } else {
                print("Error: \(error!.localizedDescription)")
            }
            NotificationCenter.default.post(name: Notification.Name("PhotosFetched"), object: nil)
        }
    }
    
    /// Fetch photo URL by id via Graph Request and save it in `photoList`
    func fetchPhotoURL(by id: String, thumbnailSize: PhotoSize = .small) {
        var imageURL: URL?,
            thumbnailImageURL: URL?
        FBSDKGraphRequest(graphPath: id, parameters: ["fields":"images"], httpMethod: "GET").start {
            (connection, result, error) in
            if error == nil {                
                if let result = result as? [String: Any],
                    let resultImages = result["images"] as? [[String: Any]] {
                    imageLoop: for (imageIndex, imageAttributes) in resultImages.enumerated() {
                        if imageIndex == 0 {
                            if let imageSource = imageAttributes["source"] as? String {
                                imageURL = URL(string: imageSource)
                                thumbnailImageURL = URL(string: imageSource)
                            }
                        } else {
                            switch thumbnailSize {
                            case .small:
                                if let imageWidth = imageAttributes["width"] as? Int,
                                    let imageSource = imageAttributes["source"] as? String {
                                    if imageWidth == thumbnailSize.rawValue {
                                        thumbnailImageURL = URL(string: imageSource)
                                    }
                                }
                                break imageLoop
                            default:
                                break
                            }
                        }
                    }
                }
            } else {
                print("Error: \(error!.localizedDescription)")
            }
            
            for (photoIndex, photoItem) in self.photoList.enumerated() {
                if photoItem.id == id {
                    self.photoList[photoIndex].imageURL = imageURL
                    self.photoList[photoIndex].thumbnailImageURL = thumbnailImageURL
                }
            }
            
            NotificationCenter.default.post(name: Notification.Name("PhotoURLFetched"), object: nil)
            
        }
    }
    
}

