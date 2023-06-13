//
//  MovieViewController.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 04/04/2023.
//

import UIKit

class MovieViewController: UIViewController,MovieItemDelegate,ViewMoreDelegate {
    
    
    
    
    
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet weak var ivMenu: UIImageView!
    @IBOutlet weak var viewForToolbar: UIView!
    @IBOutlet weak var tableViewMovies: UITableView!
    
    private let networkAgent = MovieDBNetworkAgent.shared
    

    private var upcomingMovieList: MovieList?
    private var popularMovieList: MovieList?
    private var popularSeriesList: MovieList?
    private var genresMovieList : MovieGenreList?
    private var topRatedMovieList : MovieList?
    private var popularPeopleList : ActorList?
    
    
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
    
    
    func fetchUpcomingMovieList(){
        networkAgent.getUpcomingMovieList { data in
           
            self.upcomingMovieList = data
            self.tableViewMovies.reloadSections(IndexSet(integer:  MovieType.MOVIE_SLIDER.rawValue), with: UITableView.RowAnimation.automatic)
        } failure: { error in
            
        }

    }
    
    func fetchPopularMovieList(){
        networkAgent.getPopularMovieList { data in
            self.popularMovieList = data
            self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue), with: .automatic)
        } failure: { error in
        }


    }
    
    func fetcPopularSeriesList(){
        networkAgent.getPopularSeriesList { data in
            self.popularSeriesList = data
            self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.SERIES_POPULAR.rawValue), with: .automatic)
        } failure: { error in
            
        }

    }
    
    func fetchMovieGenreList(){
        networkAgent.getGenreList { data in
            self.genresMovieList = data
            self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_GENRE.rawValue), with: .automatic)
        } failure: { error in
            
        }

    }
    
    func fetchTopRatedMovieList(){
        networkAgent.getTopRatedMovieList { data in
            self.topRatedMovieList = data
            self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_SHOWCASE.rawValue), with: .automatic)
        } failure: { error in
            
        }

    }
//  //  func fetchPopularPeopleList(){
//        networkAgent.getPopularPeople { data in
//        //    self.popularPeopleList = data
//            self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_BEST_ACTOR.rawValue), with: .automatic)
//        } failure: { error in1
//            print("error : popularpeople \(error)")
//
//        }
//
//    }
    func fetchPopularPeopleList(){
        networkAgent.getPopularPeople(page: 1) { actorList in
            self.popularPeopleList = actorList
            self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_BEST_ACTOR.rawValue), with: .automatic)

        } failure: { error in
            
        }


    }
    func onTapMovie(id:Int) {
    
        self.navigateToMovieDetailViewController(movieId: id)
       
    }
    
    func onTapMoreActor() {
        print("from viewcontroller")
        
        //test id - 603692
       // self.navigateToMovieDetailViewController(movieId: 603692)
        self.navigateToViewMoreActorViewController(data: popularPeopleList!)
    }
    
    private func registerTableViewCells(){
        tableViewMovies.registerForCell(identifier: MovieSliderTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: PopularFilmTableViewCell.identifier)
        
        tableViewMovies.registerForCell(identifier: MovieShowTimeTableViewCell.identifier)
        
        tableViewMovies.registerForCell(identifier: GenreTableViewCell.identifier)
        
        tableViewMovies.registerForCell(identifier: ShowCaseTableViewCell.identifier)
        
        tableViewMovies.registerForCell(identifier: BestActorTableViewCell.identifier)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension MovieViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
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
    
    

