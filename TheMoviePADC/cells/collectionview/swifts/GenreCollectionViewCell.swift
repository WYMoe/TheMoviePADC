//
//  GenreCollectionViewCell.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 08/04/2023.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewForOverlay: UIView!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var onTapItem:(Int)->Void = {_ in
        
    }
    
    var data: GenreVO? = nil{
        didSet{
//            lblGenre.text = data?.name
//            (data?.isSelected ?? false) ? (viewForOverlay.isHidden = false): (viewForOverlay.isHidden = true)
            if let genre = data {
                            lblGenre.text = genre.name
                            (genre.isSelected) ? (viewForOverlay.isHidden = false): (viewForOverlay.isHidden = true)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureForContainer = UITapGestureRecognizer(target: self, action: #selector(didTapItem))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tapGestureForContainer)
    }
    
    @objc func didTapItem(){
        onTapItem(data?.id ?? 0)
    }

}
