//
//  SearchViewController.swift
//  Recipes
//
//  Created by Antoine Antoniol on 04/12/2019.
//  Copyright © 2019 Antoine Antoniol. All rights reserved.
//

import UIKit

final class AddIngredientsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var ingredientsTextfield: UITextField!
    @IBOutlet private weak var ingredientsTableView: UITableView!
    @IBOutlet private weak var searchForRecipesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var clearButton: UIButton!
    @IBOutlet private var addStackView: UIStackView!

    
    // MARK: - Actions
    
    @IBAction private func addButtonTapped(_ sender: UIButton) {
        if ingredientsTextfield.text != ""{
            addIngredients()
            ingredientsTableView.reloadData()
            ingredientsTextfield.text = ""
        } else {
            showAlert(alert: .alertEmptyIngredients, title: "Alert")
        }
    }
    
    @IBAction private func clearButtonTapped(_ sender: UIButton) {
        ingredientsTextfield.text = ""
        activityIndicator.isHidden = true
        ingredients = [String]()
        ingredientsTableView.reloadData()
    }
    
    @IBAction private func searchButtonTapped(_ sender: UIButton) {
        searchForRecipesButton.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.orange
        recipeService.getData(ingredients:ingredients, callback: { result in
            switch result {
            case .success(let data):
                self.recipes = data.hits
                self.performSegue(withIdentifier: "searchToRecipes", sender:self.searchForRecipesButton)
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    // MARK: - Properties
    
    private var ingredients = [String]()
    private var recipes = [Hit]()
    private let recipeService = RecipeService()
    
    // MARK: - Methods
    
    private func addIngredients(){
        guard let ingredientsText = ingredientsTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        ingredients.append(ingredientsText)
    }
    
    // MARK: - ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchForRecipesButton.isHidden = false
    }

    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        addButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        searchForRecipesButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        ingredientsTableView.backgroundView = UIImageView(image: UIImage(named: "ingredients"))
        ingredientsTableView.backgroundView?.alpha = 0.1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? RecipesChoiceViewController else {return}
        controller.recipesArray = recipes
    }
}

// MARK: - UITableViewDataSource

extension AddIngredientsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont(name: "Apple Symbols", size: 25)
        cell.textLabel?.text = ingredients[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return "My ingredients:"
    }
    
    private func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.red
        vw.tintColor = UIColor.blue
        return vw
    }
    

  
}

