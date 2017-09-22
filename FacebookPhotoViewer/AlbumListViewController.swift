//
//  AlbumListViewController.swift
//  FacebookPhotoViewer
//
//  Created by Konstantin Konstantinov on 9/15/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import FBSDKLoginKit

class AlbumListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let fbHandler = FBHandler()
    let loginManager = FBSDKLoginManager()
    
    @IBOutlet weak var albumsTable: UITableView!
    
    @IBAction func logOutButtonTouch(_ sender: UIButton) {
        loginManager.logOut()
        performSegue(withIdentifier: "ShowLogin", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbHandler.fetchAlbums()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: Notification.Name("AlbumsFetched"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: Notification.Name("CoverPhotoFetched"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // User is not logged in
        if FBSDKAccessToken.current() == nil {
            performSegue(withIdentifier: "ShowLogin", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhotos" {
            let photosViewController = segue.destination as? PhotosViewController
            if photosViewController != nil {
                if let senderCell = sender as? AlbumTableViewCell {
                    photosViewController!.albumID = senderCell.albumID
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AlbumsFetched"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("CoverPhotoFetched"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fbHandler.albumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell", for: indexPath) as? AlbumTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let album = fbHandler.albumList[indexPath.row]
        cell.nameLabel.text = album.name
        cell.photoImageView.image = album.coverPhotoImage
        cell.albumID = album.id
        
        return cell
    }
    
    func updateTable() {
        DispatchQueue.main.async() {
            self.albumsTable.reloadData()
        }
    }

}

