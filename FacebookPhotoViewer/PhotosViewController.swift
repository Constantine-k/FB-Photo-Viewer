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
    
    @IBOutlet weak var PhotosCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fbHandler.fetchAlbums()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: Notification.Name("CoverPhotoFetched"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("CoverPhotoFetched"), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 4
        let spaceBetweenCells: CGFloat = 5
        let dimension = collectionView.bounds.width / cellsAcross - spaceBetweenCells
        
        return CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fbHandler.albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCollectionViewCell", for: indexPath) as? PhotosCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of PhotosCollectionViewCell")
        }
        
        //cell.photosImage
        
        let album = fbHandler.albumList[indexPath.row]
        cell.photosImage.image = album.coverPhotoImage
        
        return cell
    }
    
    func updateTable() {
        DispatchQueue.main.async() {
            self.PhotosCollectionView.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
