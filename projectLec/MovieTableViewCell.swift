//
//  MovieTableViewCell.swift
//  projectLec
//
//  Created by Nabilla Driesandia Azarine on 19/01/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblGenre: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
