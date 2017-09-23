//
//  PhotosViewController.swift
//  FacebookPhotoViewer
//
//  Created by Konstantin Konstantinov on 9/16/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let fbHandler = FBHandler()
    
    var albumID: String?
    
    @IBOutlet weak var PhotosCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fbHandler.fetchAlbums()
        if let albumID = albumID {
            fbHandler.fetchPhotos(by: albumID)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateCollection), name: Notification.Name("PhotosFetched"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCollection), name: Notification.Name("PhotoURLFetched"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSinglePhoto" {
            let singlePhotoViewController = segue.destination as? SinglePhotoViewController
            if singlePhotoViewController != nil {
                if let senderCell = sender as? PhotosCollectionViewCell {
                    if let imageURL = senderCell.photosFullImageURL {
                        let photoData = try? Data(contentsOf: imageURL)
                        if let photoData = photoData {
                            singlePhotoViewController!.photoImage = UIImage(data: photoData)
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PhotosFetched"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PhotoURLFetched"), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 4
        let spaceBetweenCells: CGFloat = 1
        let dimension = collectionView.bounds.width / cellsAcross - spaceBetweenCells
        
        return CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fbHandler.photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as? PhotosCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of PhotosCollectionViewCell")
        }
        
        let photo = fbHandler.photoList[indexPath.row]
        cell.photosImage.image = photo.thumbnailImage
        cell.photosFullImageURL = photo.imageURL
        
        return cell
    }
    
    func updateCollection() {
        DispatchQueue.main.async() {
            self.PhotosCollectionView.reloadData()
        }
    }

}
