//
//  MovieShowTimeTableViewCell.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 07/04/2023.
//

import UIKit

class MovieShowTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSeeMore: UILabel!
    @IBOutlet weak var viewForBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
 //       viewForBackground.layer.cornerRadius = 20
//        viewForBackground.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
        
        labelSeeMore.underlineText(text: "SEE MORE")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
