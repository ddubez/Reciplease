//
//  RecipeSearchViewController.swift
//  Reciplease
//
//  Created by David Dubez on 08/03/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class RecipeSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setDesignButtons()

        // Gesture recognizer for search recipe
        let searchRecipeGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchRecipe))
        searchRecipeGestureRecognizer.numberOfTapsRequired = 1
        searchRecipeGestureRecognizer.numberOfTouchesRequired = 1
        searchRecipesButton.addGestureRecognizer(searchRecipeGestureRecognizer)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ingredientsTableView.reloadData()
    }
    // MARK: - PROPERTIES
    var resultRecipeList = [RecipeList.Matche]()
    var numberOfResult = 0

    // MARK: - IBOUTLETS
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var addIngredientButton: UIButton!
    @IBOutlet weak var clearIngredientsButton: UIButton!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var searchRecipesButton: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - IBACTIONS
    @IBAction func didTapAddIngredientButton(_ sender: UIButton) {
        guard let ingredient = ingredientTextField.text else {return}
        IngredientService.shared.add(ingredient: ingredient)
        ingredientTextField.text?.removeAll()
        ingredientTextField.resignFirstResponder()
        ingredientsTableView.reloadData()
    }
    @IBAction func didTapClearIngredientsButton(_ sender: UIButton) {
        IngredientService.shared.clear()
        ingredientTextField.resignFirstResponder()
        ingredientsTableView.reloadData()
    }

     // MARK: - METHODS
    func setDesignButtons() {
        searchRecipesButton.layer.shadowOpacity = 0.9
        searchRecipesButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        searchRecipesButton.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

        addIngredientButton.layer.shadowOpacity = 0.8
        addIngredientButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        addIngredientButton.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

        clearIngredientsButton.layer.shadowOpacity = 0.8
        clearIngredientsButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        clearIngredientsButton.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }

    @objc func searchRecipe() {
        toggleActivityIndicator(working: true)
        IngredientService.shared.setSearchList()

        RecipeListService.shared.getRecipeList(searchPhrase:
            IngredientService.shared.searchList, start: 0) {(success, recipeListMatches, numberOfResult, error) in

            self.toggleActivityIndicator(working: false)

            if success == true, let recipeListMatches = recipeListMatches, let numberOfResult = numberOfResult {
                self.resultRecipeList = recipeListMatches
                self.numberOfResult = numberOfResult
                self.performSegue(withIdentifier: "segueToRecipeList", sender: nil)
            } else {
                self.displayAlert(with: error)
            }
        }
    }

    private func toggleActivityIndicator(working: Bool) {
        searchRecipesButton.isHidden = working
        activityIndicator.isHidden = !working
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRecipeList" {
            if let recipeListTableVC = segue.destination as? RecipeListTableViewController {
            recipeListTableVC.recipeListMatches = resultRecipeList
            recipeListTableVC.numberOfResult = numberOfResult
            }
        }
    }
}

// MARK: - KEYBOARD
extension RecipeSearchViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
    ingredientTextField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientTextField.resignFirstResponder()
        return true
    }
}

// MARK: - TABLEVIEW
extension RecipeSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IngredientService.shared.ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell",
                                                       for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }

        let ingredient = IngredientService.shared.ingredients[indexPath.row]
        cell.configure(withTitle: ingredient)

        return cell
    }
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            IngredientService.shared.removeIngredient(at: indexPath.row)
            ingredientsTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Alert
extension RecipeSearchViewController {
    func displayAlert(with message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// TODO: message alerte pas de resultat
