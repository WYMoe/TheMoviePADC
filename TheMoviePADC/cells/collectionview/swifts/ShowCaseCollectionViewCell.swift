//
//  ShowCaseCollectionViewCell.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 08/04/2023.
//

import UIKit

class ShowCaseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageViewBackdrop: UIImageView!
    
    @IBOutlet weak var labelContentTitle: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    
    var data : Result? {
        didSet{
            if let data = data {
               
                let title = data.originalTitle ?? data.originalName
                let backdropPath = "\(AppConstants.baseImageUrl)\(data.backdropPath!)"
                let releaseDate = data.releaseDate
                labelContentTitle.text = title
                imageViewBackdrop.sd_setImage(with: URL(string: backdropPath))
                labelReleaseDate.text = releaseDate
                
              
               
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
