//
//  RecipeTableViewCell.swift
//  Recipes
//
//  Created by Antoine Antoniol on 10/12/2019.
//  Copyright © 2019 Antoine Antoniol. All rights reserved.
//

import UIKit
import SDWebImage

final class RecipeTableViewCell: UITableViewCell {
    
    //  MARK: - Outlets
    
    @IBOutlet private weak var recipeImageView: UIImageView!
    @IBOutlet private weak var recipeTitleLabel: UILabel!
    @IBOutlet private weak var recipeIngredientsLabel: UILabel!
    @IBOutlet private weak var cookingTimeLabel: UILabel!
    @IBOutlet private weak var yieldLabel: UILabel!
    
    //  MARK: - Methods
    
    private func setRecipeImageView(imageView:UIImageView){
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
    private func cookingTime(time:Int) {
       if time != 0 {
           cookingTimeLabel?.text = String(time) + "min"
       } else {
           cookingTimeLabel?.text = "NA"
       }
    }
    
    private func setCell(image:Data,label:String,yield:String,ingredientslist:String){
        recipeImageView?.image = UIImage(data:image)
        setRecipeImageView(imageView: recipeImageView)
        recipeTitleLabel?.text = label
        recipeIngredientsLabel?.text = ingredientslist
        yieldLabel.text = yield
    }
    
    //  MARK: - Poperties
    
    var recipe: Hit? {
        didSet {
            guard let yield = recipe?.recipe.yield else { return}
            setCell(image:recipe?.recipe.image.data ?? Data(), label: recipe?.recipe.label ?? "", yield: String(yield) , ingredientslist: recipe?.recipe.ingredientLines.joined(separator: ",") ?? "")
            guard let time = recipe?.recipe.totalTime  else { return}
            cookingTime(time: time)
        }
    }
    
    var recipeCoreData: RecipeMO? {
        didSet {
            setCell(image: recipeCoreData?.image ?? Data(), label: recipeCoreData?.label ?? "", yield:recipeCoreData?.yield ?? "", ingredientslist: recipeCoreData?.ingredientLines ?? "")
            guard let time = Int(recipeCoreData?.totalTime ?? "")  else { return}
            cookingTime(time: time)
        }
    }
}



