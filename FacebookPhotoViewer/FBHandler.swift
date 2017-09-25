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
    
    /// Total cover images quantity for current user
    var coversQuantity: Int?
    /// Number of fetched by request cover images for current user
    var coversFetched = 0
    
    /// Total images quantity for current album or covers for current user
    var imagesQuantity: Int?
    /// Number of fetched by request images for current album
    var imagesFetched = 0
    
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
                    self.coversQuantity = resultDictionaryData.count
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
                if let error = error?.localizedDescription {
                    print("Error: \(error)")
                }
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
                    for (imageIndex, imageAttributes) in resultImages.enumerated() {
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
                            default:
                                break
                            }
                        }
                    }
                }
            } else {
                if let error = error?.localizedDescription {
                    print("Error: \(error)")
                }
            }
            
            for (albumIndex, albumItem) in self.albumList.enumerated() {
                if albumItem.coverPhotoID == id {
                    self.albumList[albumIndex].coverPhotoURL = imageURL
                }
            }
            
            self.coversFetched += 1
            if let coversQuantity = self.coversQuantity,
                coversQuantity == self.coversFetched {
                NotificationCenter.default.post(name: Notification.Name("CoverPhotoFetched"), object: nil)
                self.coversFetched = 0
            }
            
        }
    }
    
    /// Fetch photo list via Graph Request and save it in `photoList`
    func fetchPhotos(by id: String) {
        FBSDKGraphRequest(graphPath: "/\(id)/photos", parameters: nil, httpMethod: "GET").start {
            (connection, result, error) in
            if error == nil {
                if let resultDictionary = result as? [String: Any],
                    let resultDictionaryData = resultDictionary["data"] as? [[String: Any]] {
                    self.imagesQuantity = resultDictionaryData.count
                    for photoAttributes in resultDictionaryData {
                        if let photoID = photoAttributes["id"],
                            let photoTime = photoAttributes["created_time"] {
                            self.photoList.append(Photo(id: String(describing: photoID), createdTime: String(describing: photoTime), imageURL: nil, thumbnailImageURL: nil))
                            self.fetchPhotoURL(by: String(describing: photoID))
                        }
                    }
                }
            } else {
                if let error = error?.localizedDescription {
                    print("Error: \(error)")
                }
            }
            NotificationCenter.default.post(name: Notification.Name("PhotosFetched"), object: nil)
        }
    }
    
    /// Fetch photo URL by id via Graph Request and save it in `photoList`
    func fetchPhotoURL(by id: String, lastImage: Bool = false, thumbnailSize: PhotoSize = .small) {
        var imageURL: URL?,
            thumbnailImageURL: URL?
        FBSDKGraphRequest(graphPath: id, parameters: ["fields":"images"], httpMethod: "GET").start {
            (connection, result, error) in
            if error == nil {                
                if let result = result as? [String: Any],
                    let resultImages = result["images"] as? [[String: Any]] {
                    for (imageIndex, imageAttributes) in resultImages.enumerated() {
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
                            default:
                                break
                            }
                        }
                    }
                }
            } else {
                if let error = error?.localizedDescription {
                    print("Error: \(error)")
                }
            }
            
            for (photoIndex, photoItem) in self.photoList.enumerated() {
                if photoItem.id == id {
                    self.photoList[photoIndex].imageURL = imageURL
                    self.photoList[photoIndex].thumbnailImageURL = thumbnailImageURL
                }
            }
            
            self.imagesFetched += 1
            if let imagesQuantity = self.imagesQuantity,
                imagesQuantity == self.imagesFetched {
                NotificationCenter.default.post(name: Notification.Name("PhotoURLFetched"), object: nil)
                self.imagesFetched = 0
            }
            
        }
    }
    
}

extension UIImageView {
    /// Downloads an image from URL and sets it to image object
    func downloadedFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    /// Downloads an image from URL and sets it to image object
    func downloadedFrom(link: String) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url)
    }
}
