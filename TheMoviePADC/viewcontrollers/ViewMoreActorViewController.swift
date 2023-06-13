//
//  ViewMoreActorViewController.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 13/06/2023.
//

import UIKit

class ViewMoreActorViewController: UIViewController {

    @IBOutlet weak var collectionViewActors: UICollectionView!
    
    var actorList : ActorList?
    private var actorInfoList : [ActorInfo] = []
    private var itemSpacing : CGFloat = 10
    private var numberOfItemsPerRow = 3
    private var totalPages :Int = 1
    private var currentPage : Int = 1
    let networkAgent = MovieDBNetworkAgent.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewActors.showsHorizontalScrollIndicator = false
        collectionViewActors.showsVerticalScrollIndicator = false
   
        let collectionViewLayout = UICollectionViewFlowLayout()
               collectionViewLayout.minimumInteritemSpacing = 10
               collectionViewLayout.minimumLineSpacing = 10
        collectionViewActors.collectionViewLayout = collectionViewLayout
        collectionViewActors.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionViewActors.dataSource = self
        collectionViewActors.delegate = self
        collectionViewActors.registerForCell(identifier: ActorCollectionViewCell.identifier)
      
        if let layout = collectionViewActors.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .vertical
        }
        collectionViewActors.registerForCell(identifier: ActorCollectionViewCell.identifier)
        initState()
      
    }
    
    private func initState(){
        currentPage = actorList?.page ?? 1
        totalPages = actorList?.totalPages ?? 1
        actorInfoList.append(contentsOf: actorList?.results ?? [ActorInfo]())
        collectionViewActors.reloadData()
    }
    
}

extension ViewMoreActorViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        actorInfoList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCell(identifier: ActorCollectionViewCell.identifier, indexPath: indexPath) as ActorCollectionViewCell
        cell.actorInfo = actorInfoList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isAtLastRow = indexPath.row == actorInfoList.count-1
        let hasMorePage = currentPage < totalPages
        
        if isAtLastRow && hasMorePage {
            currentPage = currentPage + 1
            fetchData(page: currentPage)
        }
    }
    
    private func fetchData(page:Int) {
        networkAgent.getPopularPeople(page: page) { actorList in
            self.actorInfoList.append(contentsOf: actorList.results ?? [ActorInfo]())
            self.collectionViewActors.reloadData()
        } failure: { error in
            
        }

    }
    
    
}


extension ViewMoreActorViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing : CGFloat = (itemSpacing*CGFloat(numberOfItemsPerRow-1)) + collectionView.contentInset.left + collectionViewActors.contentInset.right

        let itemWidth : CGFloat = (collectionView.frame.width / CGFloat(numberOfItemsPerRow)) - totalSpacing/CGFloat(numberOfItemsPerRow)
        let itemHeight : CGFloat = itemWidth*1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}
