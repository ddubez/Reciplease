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
    var recipe: Recipe?
    var sourceRecipeUrl = ""
    var ifRecipeStored = false

    enum DisplayState {
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
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var getDirectionButton: UIButton!
    @IBOutlet weak var attributionLabel: UILabel!
    @IBOutlet weak var attributionImage: UIImageView!

    // MARK: - ACTIONS
    @IBAction func didTapSaveRecipe(_ sender: UIBarButtonItem) {
        if saveButton.image == UIImage(named: "selectedStar"), let recipeToDelete = recipe {

            AppDelegate.viewContext.delete(recipeToDelete)

            do { try AppDelegate.viewContext.save()
                saveButton.image = UIImage(named: "star")
            } catch let error as NSError {
                displayAlert(with: "error in deleting recipe ! \(error)")
            }

        } else {
            do { try AppDelegate.viewContext.save()
                saveButton.image = UIImage(named: "selectedStar")
            } catch let error as NSError {
                displayAlert(with: "error in saving recipe ! \(error)")
            }
        }
    }
    @IBAction func didTapGetDirectionButton(_ sender: UIButton) {
        openUrlRecipe()
    }

    // MARK: - METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageBox()
        setRecipeDisplay(displayState: .loading)

        if let favoriteRecipe = checkFavoriteRecipe() {
            saveButton.image = UIImage(named: "selectedStar")
            self.recipe = favoriteRecipe
            self.setRecipeDisplay(displayState: .loaded)
        } else {
            RecipeService.shared.getRecipe(recipeId: recipeId) { (success, recipe, error) in
                if success == true, let recipeGetted = recipe {
                    self.recipe = recipeGetted
                    self.setRecipeDisplay(displayState: .loaded)
                } else {
                    self.displayAlert(with: error)
                    self.setRecipeDisplay(displayState: .error)
                }
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
        let translationTransfort = CGAffineTransform(translationX: 35, y: 0)
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        let transform = translationTransfort.concatenating(rotationTransform)
        imageBox.transform = transform
    }

    private func setRecipeDisplay(displayState: DisplayState) {
        switch displayState {
        case .loading:
            toggleIngredientsList(searching: true)
            getDirectionButton.isHidden = true
            nameLabel.text = "Loading ... "
            recipeImage.image = UIImage(named: "defaultPhoto")
            preparationTimeLabel.text = "..."
            ratingLabel.text = "..."
        case .loaded:
            toggleIngredientsList(searching: false)
            guard let recipe = recipe else { return }
            getDirectionButton.isHidden = false
            nameLabel.text = recipe.name
            let totalTimeInMinute = recipe.totalTimeInSeconds / 60
            preparationTimeLabel.text = String(totalTimeInMinute) + " min"
            ratingLabel.text = String(recipe.rating)
            if let sourceRecipeUrlString = recipe.source?.sourceRecipeUrl {
                sourceRecipeUrl = sourceRecipeUrlString
            }
            if let attributionText = recipe.attribution?.attributionText {
                attributionLabel.text = attributionText
            }
            if let attributionImageUrl = recipe.attribution?.attributionLogo {
                getImageForAttributionLogo(from: attributionImageUrl)
            }

            if let imagesRecipeUrl = recipe.images?.hostedLargeUrl {
                getImageForRecipe(from: imagesRecipeUrl)
            }

        case .error:
            toggleIngredientsList(searching: false)
            getDirectionButton.isHidden = true
            ingredientsTableView.isHidden = true
            nameLabel.text = "Sorry, no recipe"
            recipeImage.image = UIImage(named: "defaultPhoto")
            preparationTimeLabel.text = "?"
            ratingLabel.text = "?"
        }
    }

    private func getImageForRecipe(from: String) {
        let recipeImageService = RecipeImageService()
        recipeImageService.getIconImage(imageUrl: from, completionHandler: { (data) in
            guard let data = data else {
                return
            }
            self.recipeImage.image = UIImage(data: data)
        })
    }

    private func getImageForAttributionLogo(from: String) {
        let recipeImageService = RecipeImageService()
        recipeImageService.getIconImage(imageUrl: from, completionHandler: { (data) in
            guard let data = data else {
                return
            }
            self.attributionImage.image = UIImage(data: data)
        })
    }

    private func openUrlRecipe() {
        let urlString = sourceRecipeUrl
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }

    private func toggleIngredientsList(searching: Bool) {
        activityIndicator.isHidden = !searching
        ingredientsTableView.isHidden = searching
    }

    private func checkFavoriteRecipe() -> Recipe? {
        for eachRecipe in Recipe.all {
            if let eachRecipeId = eachRecipe.recipeId {
                if eachRecipeId == self.recipeId {
                    return eachRecipe
                }
            }
        }
        return nil
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
// MARK: - TABLEVIEW
extension RecipeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let recipeIngredientsLines = recipe?.ingredientLines else {
            return 1
        }
        return recipeIngredientsLines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientRecipeTableViewCell",
                                                       for: indexPath) as? IngredientRecipeTableViewCell else {
                                                        return UITableViewCell()
        }
        guard let recipeIngredientsLines = recipe?.ingredientLines else {
            return UITableViewCell()
        }

        if let ingredientLine = recipeIngredientsLines.object(at: indexPath.row) as? IngredientLine {
            if let ingredient = ingredientLine.line {
                cell.configure(withTitle: ingredient) }
            }
        return cell
    }
}

// MARK: - Alert
extension RecipeViewController {
    func displayAlert(with message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// TODO:    - problème affichage sur les autres Iphones : faire une scroll view pour tout voir
//          - mettre en permanance l'indicateur de scroll sur la table view d'ingredients
//          - sauvergarder les images dans coredata
//          - Verifier le modele MVC ( que toutes les données ne soient que dans le Model)
//          - voir pour faire un glissement sur la droite pour les ingredients trop long
//          - probleme etoile grise au lieu de bleue
