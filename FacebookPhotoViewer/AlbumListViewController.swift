//
//  AlbumListViewController.swift
//  FacebookPhotoViewer
//
//  Created by Konstantin Konstantinov on 9/15/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import UIKit

class AlbumListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let fbHandler = FBHandler()
    
    @IBOutlet weak var albumsTable: UITableView!
    
    let list = ["Test 1", "Test 2", "Test 3"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "AlbumCell")
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fbHandler.fetchAlbums()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

