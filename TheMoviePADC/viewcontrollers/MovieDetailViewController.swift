//
//  MovieDetailViewController.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 15/04/2023.
//

import Foundation
import UIKit
class MovieDetailViewController : UIViewController, ActorActionDelegate , SimilarMovieDelegate {
   
    
    
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var ivBack: UIImageView!
    @IBOutlet weak var collectionViewActors: UICollectionView!
    @IBOutlet weak var collectionViewSimilarMovie: UICollectionView!
    @IBOutlet weak var collectionProductionCompanies: UICollectionView!
    
    @IBAction func onClickPlayTrailer(_ sender: UIButton) {
       
    }
    
    @IBOutlet weak var imageViewMoviePoster: UIImageView!
    @IBOutlet weak var labelReleaseYear: UILabel!
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var labelMovieDescription: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var viewRatingCount: RatingControl!
    @IBOutlet weak var labelVoteCount: UILabel!
    @IBOutlet weak var labelAboutMovieTitle: UILabel!
    @IBOutlet weak var labelGenreCollectionString: UILabel!
    @IBOutlet weak var labelProductionCountryString: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelAboutMovieDescription: UILabel!
    
    
    
    
    
    
    
    
    private let networkAgent = MovieDetailModelImpl.shared
    private var productionCompanies: [ProductionCompany] = [ ]
    private var creditList : CreditList?
    private var similarMovieList : MovieList?
    private var trailerList: [MovieTrailerInfo]?
    var movieID : Int = -1
  //  var delegate: MovieItemDelegate?
    var similarMoviedelegate: SimilarMovieDelegate?
    
    deinit {
        print("released")
    }
    
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
      //  fetchMovieTrailers(id: movieID)
       
    }
    
    
    func fetchMovieDetail(id:Int){
        networkAgent.getMovieDetailById(id: id) { [weak self](data) in
            guard let self = self else {return}
            switch data {
            case .success(let movieDetailById):
                self.bindData(data: movieDetailById)
            case .failure(let message):
                print(message)
            }
      
           
        }

        
    }
    
    
    

    func fetchCreditList(id:Int){
        networkAgent.getCreditById(id: id) { [weak self](data) in
            guard let self = self else {return}
            
            switch data {
            case .success(let creditList):
                self.creditList = creditList
                self.collectionViewActors.reloadData()
                self.collectionViewSimilarMovie.reloadData()
            case .failure(let message):
                print(message)
            }
         
        }
    }
    
    func fetchSimilarMovie(id:Int){
        
        networkAgent.getSimilarMovieById(id: id) { [weak self](data) in
            guard let self = self else {return}
            
            switch data {
            case .success(let similarMovieList):
                self.similarMovieList = similarMovieList
                self.collectionViewSimilarMovie.reloadData()
            case .failure(let message):
                print(message)
            }
            
        }

    }
    
    func fetchMovieTrailers(id:Int){
        
        networkAgent.getMovieTrailersById(id: id) { [weak self](data) in
            guard let self = self else {return}
            switch data {
            case .success(let movieTrailerList):
                self.trailerList = movieTrailerList.trailers
            case .failure(let message):
                print(message)
            }
          
        }

        

    }
    private func bindData(data: MovieDetail){
        productionCompanies = data.productionCompanies ?? [ProductionCompany]()
        collectionProductionCompanies.reloadData()
        let posterPath = "\(AppConstants.baseImageUrl)/\(data.backdropPath ?? "" )"
        
        imageViewMoviePoster.sd_setImage(with: URL(string:posterPath ),completed: nil)
        
        labelReleaseYear.text = String(data.releaseDate?.split(separator: "-")[0] ?? "")
        labelMovieTitle.text = data.originalTitle
        navigationItem.title = data.originalTitle
        navigationItem.leftBarButtonItem?.title  = "back"
        labelMovieDescription.text = data.overview
        let runTimeHr = Int((data.runtime ?? 0)/60)
        let runTimeMin = (data.runtime ?? 0)%60
        labelDuration.text = "\(runTimeHr)hr \(runTimeMin)mins "
        labelRating.text = "\(String(format: "%.2f",data.voteAverage ?? 0))"
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
    
    func onTapSimilarMovie(id: Int) {
        
        self.navigateToSimilarMovieViewController(movieId: id)
    }
    
 
    func onTapFavourite(isFavourite: Bool) {
        
    }
    
  
    
  
}


extension MovieDetailViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionProductionCompanies {
            return productionCompanies.count // todo
        }else if collectionView == collectionViewActors {
            
           

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
        
        
        else if collectionView == collectionViewSimilarMovie{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self), for: indexPath) as? PopularFilmCollectionViewCell else { return UICollectionViewCell() }
           
            
            cell.data = self.similarMovieList?.results?[indexPath.row]
          
            return cell

        }else {
            return UICollectionViewCell()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewSimilarMovie {

            self.similarMoviedelegate = self
            self.similarMoviedelegate?.onTapSimilarMovie(id: similarMovieList?.results?[indexPath.row].id ?? -1)
          
            
          
        }
        
    }

    
}
