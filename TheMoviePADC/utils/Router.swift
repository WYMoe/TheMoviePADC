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
        present(vc, animated: true)
    }
    
    func navigateToViewMoreActorViewController(data : ActorList){
       
        if  let vc  = UIStoryboard.mainStoryboard().instantiateViewController(identifier: ViewMoreActorViewController.identifier) as? ViewMoreActorViewController {
            vc.actorList = data
            present(vc, animated: true, completion: nil)}

            
    }
}


//extension UICollectionView{
//    func navigateToViewMoreActorViewController(){
//
//        guard  let vc  = UIStoryboard.mainStoryboard().instantiateViewController(identifier: ViewMoreActorViewController.identifier) as? ViewMoreActorViewController else {return}
//        vc.modalPresentationStyle = .fullScreen
//
//        vc.modalTransitionStyle = .flipHorizontal
//        self.present(vc, animated: true)
//    }
//}
