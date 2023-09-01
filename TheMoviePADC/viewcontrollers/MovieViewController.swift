//
//  MovieViewController.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 04/04/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MovieViewController: UIViewController {
   
    
    

    
    //MARK: - IBOutlet
    @IBOutlet weak var tableViewMovies: UITableView!
    
    
    private var refreshControl : UIRefreshControl = {
        let ui = UIRefreshControl()
        ui.tintColor = UIColor(named: "AccentColor")
        return ui
    }()
    
    let disposeBag = DisposeBag()
    
    var viewModel : MovieViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       viewModel = MovieViewModel()
        
       initView()
       bindData()
       viewModel.fetchAllData()
        
        
     
    }
    
    
    private func initView(){
        setupRefreshControl()
        initTableView()
    }
    
    private func setupRefreshControl(){
        refreshControl.tintColor = UIColor.yellow
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                self.handlePullToRefresh()
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Register table view cells
    private func initTableView(){
        
    
        tableViewMovies.refreshControl = refreshControl
       
        
       // tableViewMovies.registerForCell(identifier: TopR)
        tableViewMovies.registerForCell(identifier: MovieSliderTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: PopularFilmTableViewCell.identifier)
        
        tableViewMovies.registerForCell(identifier: MovieShowTimeTableViewCell.identifier)
        
        tableViewMovies.registerForCell(identifier: GenreTableViewCell.identifier)
        
        tableViewMovies.registerForCell(identifier: ShowCaseTableViewCell.identifier)
        
        tableViewMovies.registerForCell(identifier: BestActorTableViewCell.identifier)
    }
    
    private func bindData() {
        viewModel.homeItemList
            .bind(to: tableViewMovies.rx.items(dataSource: initDatSource()))
            .disposed(by: disposeBag)
    }
    
    //MARK: - IBACtion
    @IBAction func btnSearch(_ sender: Any) {
        navigateToSearchView()
    }
    
    @objc func handlePullToRefresh() {
        viewModel.handlePullToRefresh()
    }
    

    //MARK: - View Life Cycle

    private func initDatSource() -> RxTableViewSectionedReloadDataSource<HomeMovieSectionModel> {
        RxTableViewSectionedReloadDataSource<HomeMovieSectionModel>.init { (datasource, tableView, indexPath, item) -> UITableViewCell in
            switch item {
                
            case .upcomingMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
                cell.delegate = self
              
                cell.data = items
                
                print("up coming...")
                return cell
                
                
            case .showcaseMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as ShowCaseTableViewCell
                           cell.data = items
                
                           return cell
                
                
         
                
            case .popularMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                cell.delegate = self
                cell.labelTitle.text = "popular movies".uppercased()
                cell.data = items
                print("pmmm")
                return cell
            
                
            case .popularSeriesSection(let items):
                let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                cell.seriesDelegate = self
                cell.labelTitle.text = "popular series".uppercased()
                cell.data = items
                print("psssss")
                return cell
                
            case .movieShowTimeSection:
                let cell = tableView.dequeueCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath) as MovieShowTimeTableViewCell
                print("showtime")
                return cell
                
            case .movieGenreSection(let items, let allMovies):
                let cell = tableView.dequeueCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as GenreTableViewCell
              
                
                cell.allMovieAndSeries = allMovies.results ?? []
                let resultData : [GenreVO] = items.map { movieGenre in
                    movieGenre.convertToGenreVO()
                }
                resultData.first?.isSelected = true
              
                cell.genreList = resultData
               
                return cell
              
              
            
            
                    
                
            case .bestActorSection(let items):
                let cell = tableView.dequeueCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as BestActorTableViewCell
                cell.delegate = self
               
                cell.actorList = items
                return cell
                
//            default :
//                let cell = tableView.dequeueCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath) as MovieShowTimeTableViewCell
//                print("showtime")
//                return UITableViewCell()
                
          
            }
        }
    }
  
    
   
 
    
    

  
   

  
    
    
}


 //MARK: - Navigation Delegate

 
 
extension MovieViewController : MovieItemDelegate,ViewMoreDelegate,SeriesItemDelegate{
    func onTapMovie(id:Int) {
    
        self.navigateToMovieDetailViewController(movieId: id)
       
    }
    func ontapSerie(id: Int) {
        self.navigateToSeriesDetailViewController(seriesId: id)
    }
    
    func onTapMoreActor() {
        print("from viewcontroller")
      
      //  self.navigateToViewMoreActorViewController(data: popularPeopleList ?? ActorList())
    }
}


// MARK: - UITableviewDataSource
//extension MovieViewController : UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 7
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    // MARK: - Tableview cells
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        
//        switch indexPath.section {
//        case MovieType.MOVIE_SLIDER.rawValue:
//            
//            let cell = tableView.dequeueCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
//            cell.delegate = self
//          
//            cell.data = upcomingMovieList
//            return cell
//        case MovieType.MOVIE_POPULAR.rawValue:
//            let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
//            cell.delegate = self
//            cell.labelTitle.text = "popular movies".uppercased()
//            cell.data = popularMovieList
//            return cell
//        case MovieType.SERIES_POPULAR.rawValue:
//            let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
//            cell.seriesDelegate = self
//            cell.labelTitle.text = "popular series".uppercased()
//            cell.data = popularSeriesList
//            return cell
//        case MovieType.MOVIE_SHOWTIME.rawValue:
//            return tableView.dequeueCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)
//           
//        case MovieType.MOVIE_GENRE.rawValue:
//            let cell = tableView.dequeueCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as GenreTableViewCell
//            
//            
//            var movieList : [Result] = []
//            movieList.append(contentsOf: upcomingMovieList?.results ?? [Result]())
//            movieList.append(contentsOf: popularMovieList?.results ?? [Result]())
//            movieList.append(contentsOf: popularSeriesList?.results ?? [Result]())
//            cell.allMovieAndSeries = movieList
//
//            
//            let resultData: [GenreVO]? = genresMovieList?.genres.map({ movieGenreList -> [GenreVO] in
//                movieGenreList.map { genre in
//                    return genre.convertToGenreVO()
//                }
//          
//            })
//            resultData?.first?.isSelected = true
//            
//            cell.genreList = resultData
//            
//           
//            return cell
//           
//        case MovieType.MOVIE_SHOWCASE.rawValue:
//            
//            let cell = tableView.dequeueCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as ShowCaseTableViewCell
//            cell.data = topRatedMovieList
//            return cell
//        case MovieType.MOVIE_BEST_ACTOR.rawValue:
//            let cell = tableView.dequeueCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as BestActorTableViewCell
//            cell.delegate = self
//           
//            cell.actorList = popularPeopleList
//            return cell
//         
//            
//        default:
//            return UITableViewCell()
//        }
//        
//        
//    }
//    
//}
    
    

