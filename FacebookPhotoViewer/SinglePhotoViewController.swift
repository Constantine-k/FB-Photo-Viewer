//
//  SinglePhotoViewController.swift
//  FacebookPhotoViewer
//
//  Created by Konstantin Konstantinov on 9/22/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import UIKit

class SinglePhotoViewController: UIViewController {
    
    /// Image that is passed by previous controller
    var photoImage: UIImage?
    
    /// Image view that is displayed
    let photoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        photoImageView.contentMode = .scaleAspectFit
        
        if let photoImage = photoImage {
            photoImageView.image = photoImage
            view.addSubview(photoImageView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Handle image rotation
    override func viewWillLayoutSubviews() {
        photoImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }

}
