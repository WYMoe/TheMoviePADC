//
//  MovieViewController.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 04/04/2023.
//

import UIKit

class MovieViewController: UIViewController,MovieItemDelegate,ViewMoreDelegate {
    
    
    //MARK: - IBACtion
    @IBAction func btnSearch(_ sender: Any) {
        print("searched tapped")
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableViewMovies: UITableView!
    
    
    
    //MARK: - Properties
    private var upcomingMovieList: MovieList?
    private var popularMovieList: MovieList?
    private var popularSeriesList: MovieList?
    private var genresMovieList : MovieGenreList?
    private var topRatedMovieList : MovieList?
    private var popularPeopleList : ActorList?
    private let movieModel:MovieModel  = MovieModelImpl.shared
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMovies.dataSource = self
        registerTableViewCells()
        fetchUpcomingMovieList()
        fetchPopularMovieList()
        fetcPopularSeriesList()
        fetchMovieGenreList()
        fetchTopRatedMovieList()
        fetchPopularPeopleList()
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
    
    func fetchPopularMovieList(){
        movieModel.getPopularMovieList { [weak self](data) in
            guard let self = self else {return}
            switch data {
            case .success(let popularMovieList):
                self.popularMovieList = popularMovieList
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue), with: .automatic)
            case .failure(let message):
                print(message)
                
            }
            
        }

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
//    func ontapSerie(id: Int) {
//        self.navigateToSeriesDetailViewController(seriesId: id)
//    }
    
    func onTapMoreActor() {
        print("from viewcontroller")
      
        self.navigateToViewMoreActorViewController(data: popularPeopleList!)
    }
    
    
    //MARK: - Register table view cells
    private func registerTableViewCells(){
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
            cell.delegate = self
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
    
    

