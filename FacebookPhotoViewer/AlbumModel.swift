//
//  AlbumModel.swift
//  FacebookPhotoViewer
//
//  Created by Konstantin Konstantinov on 9/19/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import UIKit

struct AlbumList {
    let id: String,
    name: String,
    coverPhotoID: String
    var coverPhotoURL: URL?
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

struct AlbumPhoto {
    let id: String,
    name: String,
    createdTime: String
}
