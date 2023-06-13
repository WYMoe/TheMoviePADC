//
//  ViewExtensions.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 08/04/2023.
//

import Foundation
import UIKit

extension UILabel{
    func underlineText(text:String){
        let attributeString = NSMutableAttributedString.init(string:text)
        
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        self.attributedText = attributeString
    }
    
}

extension UITableViewCell {

    static var identifier : String {
        String(describing: self)
    }
}

extension UITableView {

    
    func registerForCell(identifier:String){
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func dequeueCell<T:UITableViewCell>(identifier:String,indexPath:IndexPath)->T{
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            return UITableViewCell() as! T }
        return cell
        
    }
}

extension UICollectionViewCell {

    static var identifier : String {
        String(describing: self)
    }
}

extension UICollectionView {

    
    func registerForCell(identifier:String){
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueCell<T:UICollectionViewCell>(identifier:String,indexPath:IndexPath)->T{
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            return UICollectionViewCell() as! T }
        

        return cell
        
    }
}


extension UIViewController {

    static var identifier : String {
        String(describing: self)
    }
}
