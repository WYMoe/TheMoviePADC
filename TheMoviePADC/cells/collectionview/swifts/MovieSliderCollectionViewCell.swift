//
//  MovieSliderCollectionViewCell.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 05/04/2023.
//

import UIKit
import SDWebImage

class MovieSliderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewBackdrop: UIImageView!
    @IBOutlet weak var labelContentTitle: UILabel!
    
    var data : Result? {
        didSet{
            if let data = data {
                let title = data.originalTitle
                let backdropPath = "\(AppConstants.baseImageUrl)\(data.backdropPath!)"
                
                labelContentTitle.text = title
                imageViewBackdrop.sd_setImage(with: URL(string: backdropPath))
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
