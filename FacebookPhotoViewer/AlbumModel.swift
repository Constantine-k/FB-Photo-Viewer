//
//  AlbumModel.swift
//  FacebookPhotoViewer
//
//  Created by Konstantin Konstantinov on 9/19/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import UIKit

struct Album {
    let id: String,
        name: String,
        coverPhotoID: String
    var coverPhotoURL: URL?
    // !!!!!
    var coverPhotoImage: UIImage? {
        if let coverPhotoURL = coverPhotoURL {
            let photoData = try? Data(contentsOf: coverPhotoURL)
            if let photoData = photoData {
                return UIImage(data: photoData)
            }
        }
        return nil
    }
}

struct Photo {
    let id: String,
        createdTime: String
    var imageURL: URL?,
        thumbnailImageURL: URL?
    var image: UIImage? {
        if let imageURL = imageURL {
            let photoData = try? Data(contentsOf: imageURL)
            if let photoData = photoData {
                return UIImage(data: photoData)
            }
        }
        return nil
    }
    var thumbnailImage: UIImage? {
        if let imageURL = thumbnailImageURL {
            let photoData = try? Data(contentsOf: imageURL)
            if let photoData = photoData {
                return UIImage(data: photoData)
            }
        }
        return nil
    }
}
