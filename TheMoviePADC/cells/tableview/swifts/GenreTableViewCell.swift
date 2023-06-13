//
//  GenreTableViewCell.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 08/04/2023.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionViewMovie: UICollectionView!
    @IBOutlet weak var collectionViewGenre: UICollectionView!
    
    var genreList: [GenreVO]? {
        didSet{
            if let _ = genreList {
                collectionViewGenre.reloadData()
                collectionViewMovie.reloadData()
                
                genreList?.removeAll(where: { genreVO in
                    let genreId = genreVO.id
                    let result = movieListByGenre.filter { (key,value) in
                        genreId == key
                    }
                    return result.count == 0
                })
                
                self.onTapGenre(genreId: genreList?.first?.id ?? 0)
            }
        }
    }
    var allMovieAndSeries: [Result] = []{
        didSet{
            
            allMovieAndSeries.forEach { movieSeries in
                movieSeries.genreIDS?.forEach({ genreID in
                    
                    let key = genreID
                    
                    if var _ = movieListByGenre[key] {
                        movieListByGenre[key]!.insert(movieSeries)
                    }else {
                        movieListByGenre[key] = [movieSeries]
                        
                        
                    }
                })
            }
            
            
            self.onTapGenre(genreId: genreList?.first?.id ?? 0)
        }
    }
    
    
    var movieList : [Result] = [] //movie result
    private var  movieListByGenre : [Int: Set<Result> ] = [:]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionViewGenre.dataSource = self
        collectionViewGenre.delegate = self
        collectionViewGenre.registerForCell(identifier: GenreCollectionViewCell.identifier)
        
        
        
        
        
        collectionViewMovie.dataSource = self
        collectionViewMovie.delegate = self
        collectionViewMovie.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension GenreTableViewCell:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewMovie {
            return movieList.count
        }
        return genreList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewMovie {
            let cell = collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as! PopularFilmCollectionViewCell
            cell.data = movieList[indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueCell(identifier: GenreCollectionViewCell.identifier, indexPath: indexPath) as! GenreCollectionViewCell
            
            
            cell.data = genreList?[indexPath.row]
            
            cell.onTapItem = { genreId in
                self.onTapGenre(genreId: genreId)
                
            }
            return cell
        }
        
    }
    
    func onTapGenre(genreId: Int){
        self.genreList?.forEach {(genreVO) in
            if genreId == genreVO.id {
                genreVO.isSelected = true
            }else {
                genreVO.isSelected = false
            }
            
        }
        
        self.movieList = self.movieListByGenre[genreId].map({ result in
            var list : [Result] = []
            list.append(contentsOf: result)
            
            return list
        }) ?? [Result]()
        
        self.collectionViewGenre.reloadData()
        self.collectionViewMovie.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == collectionViewMovie {
            return CGSize(width: collectionView.frame.width/3, height: 225)
        }
        
        
        return CGSize(width: widthOfString(text: genreList?[indexPath.row].name ?? "", font: UIFont(name: "Geeza Pro Regular", size: 14) ?? UIFont.systemFont(ofSize: 14))+20, height: CGFloat(45))
    }
    
    func widthOfString (text:String,font:UIFont) -> CGFloat{
        let fontAttributes = [NSAttributedString.Key.font : font]
        let textSize = text.size(withAttributes: fontAttributes)
        return textSize.width
    }
    
    
    
}
