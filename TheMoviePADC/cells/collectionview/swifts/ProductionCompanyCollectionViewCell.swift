//
//  ProductionCompanyCollectionViewCell.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 08/06/2023.
//

import UIKit

class ProductionCompanyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelCompanyName: UILabel!
    @IBOutlet weak var imageViewBackdrop: UIImageView!
    var data:ProductionCompany? {
        didSet{
            if let data = data {
                let backdropPath = "\(AppConstants.baseImageUrl)/\(data.logoPath ?? "" )"
                imageViewBackdrop.sd_setImage(with: URL(string:backdropPath ),completed: nil)
                if data.logoPath == nil || data.logoPath!.isEmpty {
                    labelCompanyName.text = data.name
                }else {
                    labelCompanyName.text = ""
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
