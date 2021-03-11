//
//  RecipesDetailViewController.swift
//  Recipes
//
//  Created by Antoine Antoniol on 13/12/2019.
//  Copyright © 2019 Antoine Antoniol. All rights reserved.
//

import UIKit

final class RecipesDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var detailledRecipesTableView: UITableView!
    @IBOutlet private weak var selectedImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIBarButtonItem!
    @IBOutlet private var getDirectionsButton: UIButton!
    @IBOutlet private var recipeTitleLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction private func getDirectionsButton(_ sender: Any) {
        guard let urlString = recipeRepresentable?.url else { return }
        guard let url = URL(string: (urlString)) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction private func addFavoriteButton(sender: UIBarButtonItem) {
        if favoriteButton.tintColor == UIColor.black {
            addRecipeToFavorites()
        } else {
            deleteRecipeFromFavorites()
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Properties
    
    var recipeRepresentable: RecipeRepresentable?
    var recipe : Hit?
    private var coreDataManager: CoreDataManager?
    
    // MARK: - Methods
    
    private func coreDataFunction() {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
           let coreDataStack = appDelegate.coreDataStack
           coreDataManager = CoreDataManager(coreDataStack:coreDataStack)
       }
    
    private func addRecipeToFavorites() {
        guard let label = recipeRepresentable?.label else { return }
        guard let ingredientLines = recipeRepresentable?.ingredientLines.joined(separator: "") else { return }
        guard let url = recipeRepresentable?.url else { return }
        guard let ingredient = recipeRepresentable?.ingredients else { return }
        coreDataManager?.createRecipe(label: label, ingredientLines: ingredientLines, totalTime: recipeRepresentable?.totalTime ??  "NA", image: recipeRepresentable?.image ?? Data(), url: url, ingredients: ingredient, yield: recipeRepresentable?.yield ?? "NA")
        favoriteButton.tintColor = #colorLiteral(red: 0.9985302091, green: 0.7577577829, blue: 0.02827046253, alpha: 1)
    }
    
    private func deleteRecipeFromFavorites() {
           guard let label = recipeRepresentable?.label else { return }
            guard let url = recipeRepresentable?.url else { return }
           coreDataManager?.deleteRecipe(label: label, url: url)
           favoriteButton.tintColor = UIColor.black
       }
    
    private func checkIfRecipeIsFavorite() {
        guard let recipeTitle = recipeRepresentable?.label else { return }
        guard let url = recipeRepresentable?.url else { return }
        guard let checkFavorite = coreDataManager?.checkIfRecipeIsFavorite(label: recipeTitle, url: url) else { return }
        
        if checkFavorite == true {
            favoriteButton.tintColor = #colorLiteral(red: 0.9985302091, green: 0.7577577829, blue: 0.02827046253, alpha: 1)
        } else {
            favoriteButton.tintColor = UIColor.black
        }
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDirectionsButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        checkIfRecipeIsFavorite()
        coreDataFunction()
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkIfRecipeIsFavorite()
    }
    
    // MARK: - ViewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkIfRecipeIsFavorite()
        coreDataFunction()
    }
}

//MARK: - UITableViewDataSource

extension RecipesDetailViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detailIngredient = recipeRepresentable?.ingredients.count else { return 0}
        return detailIngredient
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont(name: "Apple Symbols", size: 20)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = recipeRepresentable?.ingredients[indexPath.row]
        recipeTitleLabel.text = recipeRepresentable?.label
        selectedImageView.image = UIImage(data:recipeRepresentable?.image ?? Data())
        return cell
    }
}







