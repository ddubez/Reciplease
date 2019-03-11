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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ingredientsTableView.reloadData()
    }

    // MARK: - IBOUTLETS
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var addIngredientButton: UIButton!
    @IBOutlet weak var clearIngredientsButton: UIButton!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var searchRecipesButton: UIView!

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
extension RecipeSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IngredientService.shared.ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell",
                                                       for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }

        let ingredient = IngredientService.shared.ingredients[indexPath.row]
        cell.configure(withTitle: ingredient)

        return cell
    }
}
