//
//  SinglePhotoViewController.swift
//  FacebookPhotoViewer
//
//  Created by Konstantin Konstantinov on 9/22/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import UIKit

class SinglePhotoViewController: UIViewController {
    
    /// Image URL that is passed by previous controller
    var photoImageURL: URL?
    
    /// Image view that is displayed
    let photoImageView = UIImageView()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photoImageURL = photoImageURL {
            photoImageView.downloadedFrom(url: photoImageURL)
            photoImageView.contentMode = .scaleAspectFit
            photoImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            view.addSubview(photoImageView)
        }
    }
    
    override func viewWillLayoutSubviews() {
        // Handle image rotation
        photoImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }

}
