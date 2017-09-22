//
//  PhotosCollectionViewCell.swift
//  FacebookPhotoViewer
//
//  Created by Konstantin Konstantinov on 9/21/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photosImage: UIImageView!
    
    /// Full size image URL
    var photosFullImageURL: URL?
    
}
