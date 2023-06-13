//
//  ShowCaseTableViewCell.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 08/04/2023.
//

import UIKit

class ShowCaseTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMoreShowcases: UILabel!
    @IBOutlet weak var lblShowcases: UILabel!
    @IBOutlet weak var collectionViewShowCases: UICollectionView!
   
   
    var data : MovieList? {
        didSet{
            if data != nil {
                collectionViewShowCases.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMoreShowcases.underlineText(text: "MORE SHOWCASES")
        collectionViewShowCases.dataSource = self
        collectionViewShowCases.delegate = self
        collectionViewShowCases.register(UINib(nibName: String(describing: ShowCaseCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ShowCaseCollectionViewCell.self))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension ShowCaseTableViewCell:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShowCaseCollectionViewCell.self), for: indexPath) as! ShowCaseCollectionViewCell
        
        cell.data = data?.results?[indexPath.row]
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-50 , height: 180)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        (scrollView.subviews[(scrollView.subviews.count-1)]).subviews[0].backgroundColor = UIColor(named: "color_yellow")
    }
    
    
}
