//
//  Router.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 15/04/2023.
//

import Foundation
import UIKit



enum storyboardName: String{
    case Main = "Main"
    case Authentication = "Authentication"
    case LaunchScreen = "LaunchScreen"
}

extension UIStoryboard {
    static func mainStoryboard()->UIStoryboard{
        UIStoryboard(name: storyboardName.Main.rawValue, bundle: nil)
    }
}

extension UIViewController {
    func navigateToMovieDetailViewController(movieId:Int){
       
        guard  let vc  = UIStoryboard.mainStoryboard().instantiateViewController(identifier: MovieDetailViewController.identifier) as? MovieDetailViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.movieID = movieId
        vc.modalTransitionStyle = .flipHorizontal
        
        self.navigationController?.pushViewController(vc, animated: true)
       // present(vc, animated: true)
    }
    func navigateToSeriesDetailViewController(seriesId:Int){
       
        guard  let vc  = UIStoryboard.mainStoryboard().instantiateViewController(identifier: SeriesDetailViewController.identifier) as? SeriesDetailViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.seriesID = seriesId
        vc.modalTransitionStyle = .flipHorizontal
        
        self.navigationController?.pushViewController(vc, animated: true)
       // present(vc, animated: true)
    }
    
    func navigateToViewMoreActorViewController(data : ActorList){
       
        if  let vc  = UIStoryboard.mainStoryboard().instantiateViewController(identifier: ViewMoreActorViewController.identifier) as? ViewMoreActorViewController {
            vc.actorList = data
            present(vc, animated: true, completion: nil)}

            
    }
    
    func navigateToSimilarMovieViewController(movieId:Int){
        print("ontap similar 3")
        
        guard  let vc  = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {return}
         vc.movieID = movieId
        ///present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSimilarSeriesViewController(seriesId:Int){
      
        
        guard  let vc  =  UIStoryboard.mainStoryboard().instantiateViewController(identifier: SeriesDetailViewController.identifier)  as? SeriesDetailViewController else {return}
         vc.seriesID = seriesId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


