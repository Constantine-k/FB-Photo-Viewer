//
//  AlbumTableViewCell.swift
//  FacebookPhotoViewer
//
//  Created by Konstantin Konstantinov on 9/18/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
