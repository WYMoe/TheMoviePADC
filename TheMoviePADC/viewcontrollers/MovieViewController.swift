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

class MovieViewController: UIViewController,MovieItemDelegate,ViewMoreDelegate,SeriesItemDelegate {
   
    
    
    //MARK: - IBACtion
    @IBAction func btnSearch(_ sender: Any) {
        print("searched tapped")
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableViewMovies: UITableView!
    private var refreshControl : UIRefreshControl = {
        let ui = UIRefreshControl()
        ui.tintColor = UIColor(named: "AccentColor")
        return ui
    }()
    
    
    //MARK: - Properties
    private var upcomingMovieList: MovieList?
    private var popularMovieList: MovieList?
    private var popularSeriesList: MovieList?
    private var genresMovieList : MovieGenreList?
    private var topRatedMovieList : MovieList?
    private var popularPeopleList : ActorList?
    private let movieModel:MovieModel  = MovieModelImpl.shared
    
    
    let observableUpcomingMovies = RxMovieModelImpl.shared.getUpcomingMovieList()
    let observablePopularMovies = RxMovieModelImpl.shared.getPopularMovieList()
    let observableActorList = RxMovieModelImpl.shared.getPopularPeopleList()
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        registerTableViewCells()
        fetchData()
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.yellow
        let dataSource = initDatSource()
        
        Observable.combineLatest(observablePopularMovies,observableUpcomingMovies, observableActorList)
            .flatMap { (popularMovies,upcomingMovies, actorList) -> Observable<[HomeMovieSectionModel]> in
                    .just(
                        [
                        HomeMovieSectionModel.movieResult(
                                items: [.upcomingMoviesSection(items: upcomingMovies)]),
                            
                        HomeMovieSectionModel.movieResult(
                            items: [ .popularMoviesSection(items: popularMovies)]),
                        
                        HomeMovieSectionModel.actorResult(
                            items: [ .bestActorSection(items: actorList)]),
                        
                        
                     
                    
                    ]
                    
                )
            }
            .bind(to: tableViewMovies.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    private func initDatSource() -> RxTableViewSectionedReloadDataSource<HomeMovieSectionModel> {
        RxTableViewSectionedReloadDataSource<HomeMovieSectionModel>.init { (datasource, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .popularMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                cell.delegate = self
                cell.labelTitle.text = "popular movies".uppercased()
                cell.data = items
                return cell
            case .upcomingMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
                cell.delegate = self
              
                cell.data = items
                return cell
                
            case .bestActorSection(let items):
                let cell = tableView.dequeueCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as BestActorTableViewCell
                cell.delegate = self
               
                cell.actorList = items
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    @objc func handlePullToRefresh() {
        fetchData()
    }
    
    func fetchData() {
//        fetchUpcomingMovieList()
//        fetchPopularMovieList()
//        fetcPopularSeriesList()
//        fetchMovieGenreList()
//        fetchTopRatedMovieList()
//        fetchPopularPeopleList()

    }
    //MARK: - API Methods
    func fetchUpcomingMovieList(){
        movieModel.getUpcomingMovieList { [weak self](data) in
            guard let self = self else {return}
           
            switch data {
            case .success(let upComingMovieList):
                self.upcomingMovieList = upComingMovieList
                self.tableViewMovies.reloadSections(IndexSet(integer:  MovieType.MOVIE_SLIDER.rawValue), with: UITableView.RowAnimation.automatic)
            case .failure(let message):
                print(message)
                
            }
          
        }

    }
    
    let disposeBag = DisposeBag()
    
    func fetchPopularMovieList(){
        //rx
//        MovieModelImpl.shared.getPopularMovieList()
//            .subscribe(
//                onNext: { data in
//                self.popularMovieList = data
//                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue), with: .automatic)
//            },onError: { error in
//                print(error)
//            }).disposed(by: disposeBag)
        //normal
//        movieModel.getPopularMovieList { [weak self](data) in
//            guard let self = self else {return}
//            switch data {
//            case .success(let popularMovieList):
//                self.popularMovieList = popularMovieList
//                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue), with: .automatic)
//            case .failure(let message):
//                print(message)
//
//            }
//
//        }
        
        //rx
     
        
        observablePopularMovies
            .map { movieList in
               [movieList]
            }
            .bind(to: tableViewMovies.rx.items(
                cellIdentifier: PopularFilmTableViewCell.identifier,
                cellType: PopularFilmTableViewCell.self
            )){
                row, element, cell in
                cell.labelTitle.text = "popular movies".uppercased()
                cell.delegate = self
                cell.data = element
            }
            .disposed(by: disposeBag)
            

    }
    
    func fetcPopularSeriesList(){
        movieModel.getPopularSeriesList { [weak self](data) in
            guard let self = self else {return}
            switch data {
            case .success(let popularSeriesList):
                self.popularSeriesList = popularSeriesList
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.SERIES_POPULAR.rawValue), with: .automatic)
            case .failure(let message):
                print(message)
            }
            
           
        }

    }
    
    func fetchMovieGenreList(){
        movieModel.getGenreList { [weak self](data) in
            guard let self = self else {return}
            switch data {
            case .success(let movieGenreList):
                self.genresMovieList = movieGenreList
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_GENRE.rawValue), with: .automatic)

            case .failure(let message):
                print(message)
                
            }
        }
    }
    
    func fetchTopRatedMovieList(){
        movieModel.getTopRatedMovieList { [weak self](data) in
            guard let self = self else {return}
            switch data {
            case .success(let movieList):
                self.topRatedMovieList = movieList
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_SHOWCASE.rawValue), with: .automatic)
            case .failure(let message):
                print(message)
            }
           
        }
    }

    func fetchPopularPeopleList(){
        movieModel.getPopularPeople(page: 1) { [weak self](data) in
            guard let self = self else {return}
            switch data {
            case .success(let popularActorList):
                self.popularPeopleList = popularActorList
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_BEST_ACTOR.rawValue), with: .automatic)
            case .failure(let message):
                print(message)
            }
            

        }

    }
    
    //MARK: - Navigation Delegate
    func onTapMovie(id:Int) {
    
        self.navigateToMovieDetailViewController(movieId: id)
       
    }
    func ontapSerie(id: Int) {
        self.navigateToSeriesDetailViewController(seriesId: id)
    }
    
    func onTapMoreActor() {
        print("from viewcontroller")
      
        self.navigateToViewMoreActorViewController(data: popularPeopleList ?? ActorList())
    }
    
    
    //MARK: - Register table view cells
    private func registerTableViewCells(){
        
        //tableViewMovies.dataSource = self
        tableViewMovies.refreshControl = refreshControl
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                self.fetchData()
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        
        tableViewMovies.registerForCell(identifier: MovieSliderTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: PopularFilmTableViewCell.identifier)
        
        tableViewMovies.registerForCell(identifier: MovieShowTimeTableViewCell.identifier)
        
        tableViewMovies.registerForCell(identifier: GenreTableViewCell.identifier)
        
        tableViewMovies.registerForCell(identifier: ShowCaseTableViewCell.identifier)
        
        tableViewMovies.registerForCell(identifier: BestActorTableViewCell.identifier)
    }
    
}



// MARK: - UITableviewDataSource
extension MovieViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // MARK: - Tableview cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case MovieType.MOVIE_SLIDER.rawValue:
            
            let cell = tableView.dequeueCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
            cell.delegate = self
          
            cell.data = upcomingMovieList
            return cell
        case MovieType.MOVIE_POPULAR.rawValue:
            let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
            cell.delegate = self
            cell.labelTitle.text = "popular movies".uppercased()
            cell.data = popularMovieList
            return cell
        case MovieType.SERIES_POPULAR.rawValue:
            let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
            cell.seriesDelegate = self
            cell.labelTitle.text = "popular series".uppercased()
            cell.data = popularSeriesList
            return cell
        case MovieType.MOVIE_SHOWTIME.rawValue:
            return tableView.dequeueCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)
           
        case MovieType.MOVIE_GENRE.rawValue:
            let cell = tableView.dequeueCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as GenreTableViewCell
            
            
            var movieList : [Result] = []
            movieList.append(contentsOf: upcomingMovieList?.results ?? [Result]())
            movieList.append(contentsOf: popularMovieList?.results ?? [Result]())
            movieList.append(contentsOf: popularSeriesList?.results ?? [Result]())
            cell.allMovieAndSeries = movieList

            
            let resultData: [GenreVO]? = genresMovieList?.genres.map({ movieGenreList -> [GenreVO] in
                movieGenreList.map { genre in
                    return genre.convertToGenreVO()
                }
          
            })
            resultData?.first?.isSelected = true
            
            cell.genreList = resultData
            
           
            return cell
           
        case MovieType.MOVIE_SHOWCASE.rawValue:
            
            let cell = tableView.dequeueCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as ShowCaseTableViewCell
            cell.data = topRatedMovieList
            return cell
        case MovieType.MOVIE_BEST_ACTOR.rawValue:
            let cell = tableView.dequeueCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as BestActorTableViewCell
            cell.delegate = self
           
            cell.actorList = popularPeopleList
            return cell
         
            
        default:
            return UITableViewCell()
        }
        
        
    }
    
}
    
    

