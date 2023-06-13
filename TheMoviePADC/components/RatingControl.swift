//
//  RatingControl.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 06/04/2023.
//

import UIKit

@IBDesignable
class RatingControl: UIStackView {

   
    
     @IBInspectable var rating : Int = 4{
        didSet{
            updateButtonRating()
        }
    }
    @IBInspectable var starSize : CGSize = CGSize(width: 16, height: 16){
        didSet{
            setUpButtons()
            updateButtonRating()
        }
    }
    @IBInspectable  var starCount : Int = 5{
        didSet{
            setUpButtons()
            updateButtonRating()
        }
    }
    var ratingButtons = [UIButton]()
    override init(frame: CGRect) {
         super.init(frame: frame)
         setUpButtons()
        updateButtonRating()
     }

    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
        updateButtonRating()
    }
    
    private func setUpButtons(){
       
        clearExistingButton()
        for _ in 0..<starCount{
            let button = UIButton()
            
            button.setImage(UIImage(named: "filledStar"), for: .selected)
            button.setImage(UIImage(named: "emptyStar"), for: .normal)
           
            
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            addArrangedSubview(button)
            button.isUserInteractionEnabled = false
            ratingButtons.append(button)
                
        }
    }
    private func updateButtonRating(){
        for(index,button) in ratingButtons.enumerated(){
            
            button.isSelected = index < rating
        }
        
    }
    
    
    private func clearExistingButton(){
        for btn in ratingButtons {
            removeArrangedSubview(btn)
            btn.removeFromSuperview()
        }
        ratingButtons.removeAll()
    }
}
