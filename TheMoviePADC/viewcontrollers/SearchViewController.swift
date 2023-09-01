//
//  SearchViewController.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 28/08/2023.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {

    

    
    @IBOutlet weak var collectionViewSearchList: UICollectionView!
    @IBOutlet weak var ivBack: UIImageView!
    
    let searchBar = UISearchBar()
    let networkAgent = MovieDBNetworkAgent.shared
    var searchLists : [Result] = []
    var totalPage : Int = 1
    var currentPage : Int = 1
    private var itemSpacing : CGFloat = 18
    private var numberOfItemsPerRow = 3
    let disposeBag = DisposeBag()
    let searchResutlItems : BehaviorSubject<[Result]> = BehaviorSubject(value: [])
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        initGesture()
        
        initView()
       
        initObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         
        
         navigationController?.isNavigationBarHidden = false
     }
    
    func initGesture(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapBackHome))
        
        ivBack.isUserInteractionEnabled = true
        ivBack.addGestureRecognizer(tapGesture)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ivBack)
        
   
    }
    
    
    
    @objc func onTapBackHome(){
        navigationController?.popViewController(animated: false)
    
        
    }
    
    
    func initView() {
        registerCollectionView()
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
                  .foregroundColor: UIColor.white
              ]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
        searchBar.searchTextField.leftView?.tintColor = .white

        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
        navigationItem.titleView = searchBar
        
    }

    
    func initObserver() {
        addSearchBarObserver()
        addCollectionViewBindingObserver()
        addPaginationObserver()
      
    }
 
    
    func registerCollectionView(){
        collectionViewSearchList.register(UINib(nibName: String(describing: PopularFilmCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self))
        
//        let flowLayout = UICollectionViewFlowLayout()
//        let width : CGFloat = (collectionViewSearchList.frame.size.width/3-20)
//        let height : CGFloat = 160
//
//        flowLayout.itemSize = CGSize(width: width, height: height)
//        collectionViewSearchList.setCollectionViewLayout(flowLayout, animated: true)
      
    }
    
    func rxMovieSearch(query:String, page:Int){
        RxNetworkAgent.shared.searchMovie(page: page, query: query)
            .do(onNext: { item in
                   self.totalPage = item.totalPages ?? 1
            })
                .compactMap { movieList in
                    movieList.results
                }
                .subscribe(onNext: { item in
                    if item.isEmpty {
                        self.searchResutlItems.onNext([])
                    }else {
                        self.searchResutlItems.onNext(try! self.searchResutlItems.value() + item)
                        self.collectionViewSearchList.reloadData()
                    }
                }, onError: {
                    error in
                    print(error)
                })
                .disposed(by: disposeBag)

    }
}
    
   

extension SearchViewController : UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let data = searchBar.text {
            self.currentPage = 1
            self.totalPage = 1
            self.searchLists.removeAll()
            self.rxMovieSearch(query: data, page: self.currentPage)
        }
    }
    
}

//extension SearchViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return searchLists.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularFilmCollectionViewCell.identifier, for: indexPath) as? PopularFilmCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//
//        cell.data = searchLists[indexPath.row]
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        navigateToMovieDetailViewController(movieId: searchLists[indexPath.row].id ?? 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let isAtLastRow = indexPath.row == (searchLists.count - 1)
//        let hasMorePage = currentPage < totalPage
//        if isAtLastRow && hasMorePage {
//            currentPage += 1
//            self.rxMovieSearch(query: searchBar.text ?? "", page: self.currentPage)
//        }
//    }
//
//
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//                let itemWidth : CGFloat = collectionView.frame.width
//
//
//                let itemHeight : CGFloat = itemWidth * 2
//
//                return CGSize(width: itemWidth, height: itemHeight)
//
//
//
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return itemSpacing
//    }
//
//}

//MARK: - Observers
extension SearchViewController {
    
    func addSearchBarObserver() {
        searchBar.rx.text.orEmpty
            .debounce(.microseconds(200), scheduler: MainScheduler.instance)
            .do(onNext: {print($0)})
                .subscribe(onNext: { value in
                    if value.isEmpty {
                        self.currentPage = 1
                        self.totalPage = 1
                        self.searchResutlItems.onNext([])
                    } else {
                        self.searchResutlItems.onNext([])
                        self.rxMovieSearch(query: value, page: self.currentPage)
                    }
                })
                .disposed(by: disposeBag)
            
    }
    
    func addCollectionViewBindingObserver() {
        searchResutlItems
            .bind(to: collectionViewSearchList.rx.items(cellIdentifier: String(describing: PopularFilmCollectionViewCell.identifier),  cellType: PopularFilmCollectionViewCell.self)){
                row, element, cell in
                cell.data = element
              
            }
            .disposed(by: disposeBag)
        
    }
    
    
    func addPaginationObserver() {
        
        Observable.combineLatest( collectionViewSearchList.rx.willDisplayCell,
                                  searchBar.rx.text.orEmpty)
        .subscribe(onNext: { (cellTuple, searchText) in
            let (_, indexPath) = cellTuple
            let totalItems = try! self.searchResutlItems.value().count
            let isAtLastRow = indexPath.row == totalItems - 1
            let hasMorepage = self.currentPage < self.totalPage
            if (isAtLastRow && hasMorepage) {
                self.currentPage += 1
                self.rxMovieSearch(query: searchText, page: self.currentPage)
            }
        })
        .disposed(by: disposeBag)
        
    
    }
    
    func addItemSelectObserver() {
        collectionViewSearchList.rx.itemSelected
            .subscribe(onNext: {
                indexPath in
                let items = try! self.searchResutlItems.value()
                let item = items[indexPath.row]
                self.navigateToMovieDetailViewController(movieId: item.id ?? 1)
                
            })
            .disposed(by: disposeBag)
    }
}
  

