//
//  PopularFilmTableViewCell.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 07/04/2023.
//

import UIKit

class PopularFilmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var collectionViewMovies: UICollectionView!
    var delegate: MovieItemDelegate? = nil
    var seriesDelegate : SeriesItemDelegate? = nil
    var data : MovieList? {
        didSet{
            if data != nil {
                collectionViewMovies.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionViewMovies.dataSource = self
        collectionViewMovies.delegate = self
        collectionViewMovies.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


extension PopularFilmTableViewCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as! PopularFilmCollectionViewCell
        cell.data = data?.results?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(120.0), height:CGFloat(collectionView.frame.height * 0.9))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      delegate?.onTapMovie(id: data?.results?[indexPath.row].id ?? -1)
      seriesDelegate?.ontapSerie(id: data?.results?[indexPath.row].id ?? -1)
    }
    
    
}
