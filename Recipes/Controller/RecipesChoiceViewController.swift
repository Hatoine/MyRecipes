//
//  RecipesChoiceViewController.swift
//  Recipes
//
//  Created by Antoine Antoniol on 04/12/2019.
//  Copyright © 2019 Antoine Antoniol. All rights reserved.
//

import UIKit


final class RecipesChoiceViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var recipesTableView: UITableView?
    
    // MARK: - Properties
    
    var recipesArray = [Hit]()
    private var recipe : Hit?
    private var recipeRepresentable: RecipeRepresentable?
    
    // MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destination = segue.destination as? RecipesDetailViewController else { return }
        destination.recipeRepresentable = recipeRepresentable
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        recipesTableView?.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
    }
}

// MARK: - UITableViewDataSource

extension RecipesChoiceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {
            fatalError()
        }
        cell.recipe = recipesArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        let recipe = recipesArray[indexPath.row].recipe
        recipeRepresentable = RecipeRepresentable(label: recipe.label, image: recipe.image.data, ingredients: recipe.ingredients.map({$0.text }), ingredientLines: recipe.ingredientLines, yield: String(recipe.yield), totalTime: String(recipe.totalTime), url: recipe.url)
        performSegue(withIdentifier: "listToDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Your ingredients match no recipes"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textAlignment = .center
        label.textColor = .red
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return recipesArray.isEmpty ? 200 : 0
    }
}

