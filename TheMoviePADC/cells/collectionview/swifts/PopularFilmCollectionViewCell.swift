
//
//  PopularFilmCollectionViewCell.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 07/04/2023.
//

import UIKit

class PopularFilmCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageViewBackdrop: UIImageView!
    @IBOutlet weak var labelContentTitle: UILabel!
    
    @IBOutlet weak var labelRating: UILabel!
    
    @IBOutlet weak var ratingStar: RatingControl!
    
    
    var data : Result? {
        didSet{
            if let data = data {
                
                let title = data.originalTitle ?? data.originalName
               
                let posterPath = "\(AppConstants.baseImageUrl)\(data.posterPath ?? "")"
           
                labelContentTitle.text = title
                imageViewBackdrop.sd_setImage(with: URL(string: posterPath))
                let voteAverage = data.voteAverage ?? 0.0
                labelRating.text = "\(voteAverage)"
                ratingStar.starCount = Int(voteAverage*0.5)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
