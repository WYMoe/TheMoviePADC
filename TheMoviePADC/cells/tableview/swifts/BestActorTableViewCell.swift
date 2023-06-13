//
//  BestActorTableViewCell.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 09/04/2023.
//

import UIKit

class BestActorTableViewCell: UITableViewCell, ActorActionDelegate {
    func onTapFavourite(isFavourite: Bool) {
        debugPrint("isFavourite: \(isFavourite)")
    }
    

   
    @IBOutlet weak var lblMoreActors: UILabel!
    
    @IBOutlet weak var collectionViewActors: UICollectionView!
    
    var delegate : ViewMoreDelegate? = nil


    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("view more taped")
        delegate?.onTapMoreActor()
        
    }

    var actorList: ActorList? {
        didSet{
            if actorList != nil {
                collectionViewActors.reloadData()
                print(actorList?.results)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMoreActors.underlineText(text: "MORE ACTORS")
        collectionViewActors.dataSource = self
        collectionViewActors.delegate = self
        collectionViewActors.register(UINib(nibName: String(describing: ActorCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ActorCollectionViewCell.self))
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        lblMoreActors.isUserInteractionEnabled = true
        lblMoreActors.addGestureRecognizer(tap)

       

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  
}


extension BestActorTableViewCell:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
        actorList?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ActorCollectionViewCell.self), for: indexPath) as? ActorCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
  //      cell.data = self.data?.results?[indexPath.row]
        cell.actorInfo = self.actorList?.results?[indexPath.row]
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth : CGFloat = 120.0
        let itemHeight: CGFloat = itemWidth *
        1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
}
