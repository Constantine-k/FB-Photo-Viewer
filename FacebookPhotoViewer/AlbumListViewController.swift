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
        performSegue(withIdentifier: "showLoginView", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User is not logged in
        if FBSDKAccessToken.current() == nil {
            performSegue(withIdentifier: "showLoginView", sender: nil)
        }
        
        fbHandler.fetchAlbums()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: Notification.Name("AlbumsFetched"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: Notification.Name("CoverPhotoFetched"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AlbumsFetched"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("CoverPhotoFetched"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fbHandler.albumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumTableViewCell", for: indexPath) as? AlbumTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let album = fbHandler.albumList[indexPath.row]
        cell.nameLabel.text = album.name
        cell.photoImageView.image = album.coverPhotoImage
        
        return cell
    }
    
    func updateTable() {
        DispatchQueue.main.async() {
            self.albumsTable.reloadData()
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

