//
//  FavoritesViewController.swift
//  Recipes
//
//  Created by Antoine Antoniol on 08/01/2020.
//  Copyright © 2020 Antoine Antoniol. All rights reserved.
//

import UIKit


final class FavoritesViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var favoritesTableView: UITableView?
    
    // MARK: - Actions
    
    
    @IBAction func deleteAllFavoritesButton(_ sender: UIButton) {
        if coreDataManager?.recipeMOarray.count != 0 {
            alertDeleteFavorites()
        } else {
            showAlert(alert: .noFavorites, title: "Alert")
        }
    }
    
    // MARK: - Properties
    
    private var coreDataManager: CoreDataManager?
    private var recipeRepresentable: RecipeRepresentable?
    
    // MARK: - Methods
    
    func alertDeleteFavorites(){
        let alertController = UIAlertController(title: "Are you sure to delete all your favorites?", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.coreDataManager?.deleteAllFavorites()
            self.favoritesTableView?.reloadData()
            self.showAlert(alert: .alertDeleteAllFavotitesOK,title: "")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            self.showAlert(alert: .alertDeleteAllFavotitesCancel,title: "")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? RecipesDetailViewController else {return}
        destination.recipeRepresentable = recipeRepresentable
    }
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        favoritesTableView?.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
        favoritesTableView?.reloadData()
    }
    
    // MARK: - ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoritesTableView?.reloadData()
    }
}

// MARK: - TableView

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coreDataManager?.recipeMOarray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else { fatalError()
        }
        cell.recipeCoreData = coreDataManager?.recipeMOarray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        let recipe = coreDataManager?.recipeMOarray[indexPath.row]
        recipeRepresentable = RecipeRepresentable(label: recipe?.label ?? "", image: recipe?.image, ingredients: recipe?.ingredients ?? [String](), ingredientLines: [recipe?.ingredientLines.map({ $0.self}) ?? ""], yield: recipe?.yield ?? "", totalTime: String(recipe?.totalTime ?? ""), url: recipe?.url ?? "")
        performSegue(withIdentifier:"favoritesToDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let favorite = coreDataManager?.recipeMOarray[indexPath.row] else { return}
            guard let label = favorite.label else { return}
            guard let url = favorite.url else { return}
            coreDataManager?.deleteRecipe(label: label, url: url)
            favoritesTableView?.deleteRows(at: [indexPath], with:.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Add some favorites by clicking the star button"
        label.numberOfLines = 0
        label.font = UIFont(name: "Apple Symbols", size: 22)
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return coreDataManager?.recipeMOarray.isEmpty ?? true ? 200 : 0
    }
}

