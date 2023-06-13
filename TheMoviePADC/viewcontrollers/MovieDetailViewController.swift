//
//  MovieDetailViewController.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 15/04/2023.
//

import Foundation
import UIKit
class MovieDetailViewController : UIViewController, ActorActionDelegate {
    func onTapFavourite(isFavourite: Bool) {
        
    }
    
    var movieID : Int = -1
    
    
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var ivBack: UIImageView!
    @IBOutlet weak var collectionViewActors: UICollectionView!
    @IBOutlet weak var collectionViewSimilarMovie: UICollectionView!
    @IBOutlet weak var collectionProductionCompanies: UICollectionView!
    
    @IBAction func onClickPlayTrailer(_ sender: UIButton) {
        let item = trailerList?.first
        let youtubeKey = item?.key
        let youtubeURL = "https://www.youtube.com/watch?v=\(String(describing: youtubeKey))"
    }
    
    @IBOutlet weak var imageViewMoviePoster: UIImageView!
    @IBOutlet weak var labelReleaseYear: UILabel!
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var labelMovieDescription: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var viewRatingCount: RatingControl!
    @IBOutlet weak var labelVoteCount: UILabel!
    
    
    var arr = [1,3,4]
    
   
    
    @IBOutlet weak var labelAboutMovieTitle: UILabel!
    @IBOutlet weak var labelGenreCollectionString: UILabel!
    @IBOutlet weak var labelProductionCountryString: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelAboutMovieDescription: UILabel!
    
    
    
    
    
    
    
    
    let networkAgent = MovieDBNetworkAgent.shared
    
    
    private var productionCompanies: [ProductionCompany] = [ ]
    private var creditList : CreditList?
    private var similarMovieList : MovieList?
    private var trailerList: [MovieTrailerInfo]?
    
    override func viewDidLoad() {
        initGesture()
        btnRate.layer.borderColor = UIColor.white.cgColor
        btnRate.layer.borderWidth = 2
        btnRate.layer.cornerRadius = 20
        
        
        
        collectionProductionCompanies.dataSource = self
        collectionProductionCompanies.delegate = self
        collectionProductionCompanies.register(UINib(nibName: String(describing: ProductionCompanyCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductionCompanyCollectionViewCell.self))
        collectionProductionCompanies.showsHorizontalScrollIndicator = false
        collectionProductionCompanies.showsVerticalScrollIndicator = false
        
        collectionViewActors.dataSource = self
        collectionViewActors.delegate = self
        collectionViewActors.register(UINib(nibName: String(describing: ActorCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ActorCollectionViewCell.self))
        
        collectionViewActors.showsHorizontalScrollIndicator = false
        collectionViewActors.showsVerticalScrollIndicator = false
        
        collectionViewSimilarMovie.dataSource = self
        collectionViewSimilarMovie.delegate = self
        collectionViewSimilarMovie.register(UINib(nibName: String(describing: PopularFilmCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self))
        collectionViewSimilarMovie.showsHorizontalScrollIndicator = false
        collectionViewSimilarMovie.showsVerticalScrollIndicator = false
        
        fetchMovieDetail(id: movieID)
        fetchCreditList(id: movieID)
        fetchSimilarMovie(id: movieID)
        fetchMovieTrailers(id: movieID)
       
    }
    
    
    func fetchMovieDetail(id:Int){
        networkAgent.getMovieDetailById(id: id) { data in
       
            self.bindData(data: data)
      
           
        } failure: { error in
            
        }

        
    }
    

    func fetchCreditList(id:Int){
        networkAgent.getCreditById(id: id) { creditList in
            self.creditList = creditList
            self.collectionViewActors.reloadData()
            self.collectionViewSimilarMovie.reloadData()
        } failure: { error in
            print("movie detail credit error : \(error)")
        }

    }
    
    func fetchSimilarMovie(id:Int){
        
        networkAgent.getSimilarMovieById(id: id) { movieList in
            self.similarMovieList = movieList
            self.collectionViewSimilarMovie.reloadData()
        } failure: { error in
            
        }

    }
    
    func fetchMovieTrailers(id:Int){
        
        networkAgent.getMovieTrailersById(id: id) { movieTrailerList in
            self.trailerList = movieTrailerList.trailers
        } failure: { error in
            
        }

        

    }
    private func bindData(data: MovieDetail){
        productionCompanies = data.productionCompanies ?? [ProductionCompany]()
        collectionProductionCompanies.reloadData()
        let posterPath = "\(AppConstants.baseImageUrl)/\(data.backdropPath ?? "" )"
        
        imageViewMoviePoster.sd_setImage(with: URL(string:posterPath ),completed: nil)
        
        labelReleaseYear.text = String(data.releaseDate?.split(separator: "-")[0] ?? "")
        labelMovieTitle.text = data.originalTitle
        labelMovieDescription.text = data.overview
        let runTimeHr = Int((data.runtime ?? 0)/60)
        let runTimeMin = (data.runtime ?? 0)%60
        labelDuration.text = "\(runTimeHr)hr \(runTimeMin)mins "
        labelRating.text = "\(data.voteAverage ?? 0)"
        viewRatingCount.rating = Int((data.voteAverage ?? 0.0) * 0.5)
        labelVoteCount.text = "\(data.voteCount ?? 0) votes"
       
       
       
        labelAboutMovieTitle.text = data.originalTitle
        
        var genreListStr = ""
        data.genres?.forEach({ item in
            genreListStr += "\(item.name ?? ""), "
        })
        genreListStr.removeLast()
        genreListStr.removeLast()

        labelGenreCollectionString.text = genreListStr
        
        
        var productionCountryListStr = ""
        data.productionCountries?.forEach({ item in
            productionCountryListStr += "\(item.name ?? ""), "
        })
        productionCountryListStr.removeLast()
        productionCountryListStr.removeLast()
        labelProductionCountryString.text = productionCountryListStr
        labelReleaseDate.text = data.releaseDate
        labelAboutMovieDescription.text = data.overview
        
    }
    
  
    func initGesture(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapBackHome))
        
        ivBack.isUserInteractionEnabled = true
        ivBack.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func onTapBackHome(){
        self.dismiss(animated: true,completion: nil)
    }
}


extension MovieDetailViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionProductionCompanies {
            return productionCompanies.count // todo
        }else if collectionView == collectionViewActors {
            
            print(creditList?.cast?.count ?? 0)

            return creditList?.cast?.count ?? 0
        }else if collectionView == collectionViewSimilarMovie{
            return similarMovieList?.results?.count ?? 0
        }
      return  5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionProductionCompanies{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductionCompanyCollectionViewCell.self), for: indexPath) as? ProductionCompanyCollectionViewCell else { return UICollectionViewCell() }
            cell.data = productionCompanies[indexPath.row]
            
            return cell
        }else if collectionView == collectionViewActors{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ActorCollectionViewCell.self), for: indexPath) as? ActorCollectionViewCell else { return UICollectionViewCell() }
      
            cell.delegate = self
            cell.actorInfo = self.creditList?.cast?[indexPath.row].convertToActorInfo()
            
            
            return cell
        }
        
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self), for: indexPath) as? PopularFilmCollectionViewCell else { return UICollectionViewCell() }
          //  cell.delegate = self
            cell.data = self.similarMovieList?.results?[indexPath.row]
          
            return cell

        }


       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionProductionCompanies{
            let itemHeight:CGFloat = collectionView.frame.height
            let itemWidth: CGFloat = itemHeight
            return CGSize(width: itemWidth, height: itemHeight)
        }else if collectionView == collectionViewActors {
            
            let itemWidth:CGFloat = 120
            let itemHeight: CGFloat = itemWidth * 1.5
            return CGSize(width: itemWidth, height: itemHeight)
        }else if collectionView == collectionViewSimilarMovie{
            let itemWidth:CGFloat = 120
            let itemHeight: CGFloat = collectionView.frame.height
            return CGSize(width: itemWidth, height: itemHeight)
        }else {
            return CGSize.zero
        }
    }
    
}
