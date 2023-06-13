//
//  ActorCollectionViewCell.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 09/04/2023.
//

import UIKit

class ActorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivHeart: UIImageView!
    
    @IBOutlet weak var ivHeartFill: UIImageView!
    
    @IBOutlet weak var imageViewActorProfile: UIImageView!
    @IBOutlet weak var labelKnowForDepartment: UILabel!
    @IBOutlet weak var labelActorName: UILabel!
    var delegate : ActorActionDelegate? = nil

    
//    var data : ActorInfo? {
//        didSet{
//            if data != nil {
//                let profilePath = "\(AppConstants.baseImageUrl)/\(data?.profilePath ?? "" )"
//                imageViewActorProfile.sd_setImage(with: URL(string:profilePath ),completed: nil)
//                labelActorName.text = data?.name
//                labelKnowForDepartment.text = data?.knownForDepartment?.rawValue
//                
//            }
//        }
//    }
    
//    var castInfo : CastInfo? {
//        didSet{
//            if castInfo != nil {
//                let profilePath = "\(AppConstants.baseImageUrl)/\(castInfo?.profilePath ?? "" )"
//                imageViewActorProfile.sd_setImage(with: URL(string:profilePath))
//                labelActorName.text = castInfo?.name
//                labelKnowForDepartment.text = castInfo?.knownForDepartment
//            }
//        }
//    }
    
    var actorInfo : ActorInfo? {
        didSet{
            if actorInfo != nil {
                let profilePath = "\(AppConstants.baseImageUrl)/\(actorInfo?.profilePath ?? "" )"
                imageViewActorProfile.sd_setImage(with: URL(string:profilePath))
                labelActorName.text = actorInfo?.name
                labelKnowForDepartment.text = actorInfo?.knownForDepartment
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initGustureRecognizers()
        // Initialization code
       
    }
    
     func initGustureRecognizers(){
        
       
        let tapGestureRecognizerUnFav = UITapGestureRecognizer(target: self, action: #selector(onTapHeart))
        
        ivHeart.isUserInteractionEnabled = true
        ivHeart.addGestureRecognizer(tapGestureRecognizerUnFav)
        
        let tapGestureRecognizerFav = UITapGestureRecognizer(target: self, action: #selector(onTapHeartFill))
        ivHeartFill.isUserInteractionEnabled = true
        ivHeartFill.addGestureRecognizer(tapGestureRecognizerFav)
        // debugPrint(tapGestureRecognizerFav)
    }
    
    @objc func onTapHeart(){
        ivHeart.isHidden = true
        ivHeartFill.isHidden = false
       
        delegate?.onTapFavourite(isFavourite: false)
       
    }
    
    @objc func onTapHeartFill(){
        ivHeartFill.isHidden = true
        ivHeart.isHidden = false
        delegate?.onTapFavourite(isFavourite: true)
        
    }
    

}
