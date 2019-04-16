//
//  RecipeViewController.swift
//  Reciplease
//
//  Created by David Dubez on 13/04/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    // MARK: - PROPERTIES
    var recipeId: String!
    var recipe = Recipe()
    
    enum displayState {
        case loading, loaded, error
    }

    // MARK: - OUTLETS
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageBox: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var preparationTimeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var attributionLabel: UILabel!

    // MARK: - ACTIONS
    @IBAction func didTapSaveRecipe(_ sender: UIBarButtonItem) {
    }
    @IBAction func didTapGetDirectionButton(_ sender: UIButton) {
        openUrlRecipe()
    }

    // MARK: - METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageBox()
        setRecipeDisplay(displayState: .loading)
        toggleIngredientsList(searching: true)

        RecipeService.shared.getRecipe(recipeId: recipeId) { (success, recipe, error) in
            self.toggleIngredientsList(searching: false)
            if success == true, let recipeGetted = recipe {
                self.recipe = recipeGetted
                self.setRecipeDisplay(displayState: .loaded)
            } else {
                self.setRecipeDisplay(displayState: .error)
                self.displayAlert(with: error)
            }
        }
    }

    private func setImageBox() {
        recipeImage.layer.zPosition = -1
        recipeImage.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        recipeImage.layer.borderWidth = 1
        recipeImage.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        recipeImage.layer.shadowRadius = 10.0
        recipeImage.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        recipeImage.layer.shadowOpacity = 5.0

        let rotationAngle = (CGFloat.pi / 12)
        let translationTransfort = CGAffineTransform(translationX: 30, y: 0)
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        let transform = translationTransfort.concatenating(rotationTransform)
        imageBox.transform = transform
    }

    private func setRecipeDisplay(displayState: displayState) {
        switch displayState {
        case .loading:
            nameLabel.text = "Loading ... "
            recipeImage.image = UIImage(named: "defaultPhoto")
        case .loaded:
            nameLabel.text = recipe.name

        case .error:
            nameLabel.text = "Sorry, no recipe"
            recipeImage.image = UIImage(named: "defaultPhoto")
        }
    }

    private func openUrlRecipe() {
        let urlString = "http://www.yummly.com/recipe/Hot-Turkey-Salad-Sandwiches-Allrecipes"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }

    private func toggleIngredientsList(searching: Bool) {
        activityIndicator.isHidden = !searching
        ingredientsTableView.isHidden = searching
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: - Alert
extension RecipeViewController {
    func displayAlert(with message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// TODO:    - Mettre à jour données à afficher en fonction du RECIPE
//          - Faire TableView,
//          - capitalise recipe name,
//          - mettre une stack view pour traiter l'erreur sur l'iphone 5
//          - voir probleme de la shadow sur l'image
//          - Mettre le bon Url
