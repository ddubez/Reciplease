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
    var sourceRecipeUrl = ""

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
        ingredientsTableView.showsVerticalScrollIndicator = true

        RecipeService.shared.getRecipe(recipeId: recipeId) { (success, recipe, error) in
            self.toggleIngredientsList(searching: false)
            if success == true, let recipeGetted = recipe {
                self.recipe = recipeGetted
                self.setRecipeDisplay(displayState: .loaded)
            } else {
                self.displayAlert(with: error)
                self.setRecipeDisplay(displayState: .error)
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

    private func setRecipeDisplay(displayState: DisplayState) {
        switch displayState {
        case .loading:
            getDirectionButton.isHidden = true
            nameLabel.text = "Loading ... "
            recipeImage.image = UIImage(named: "defaultPhoto")
            preparationTimeLabel.text = "..."
            ratingLabel.text = "..."
        case .loaded:
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
        return recipe.ingredientLines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientRecipeTableViewCell",
                                                       for: indexPath) as? IngredientRecipeTableViewCell else {
                                                        return UITableViewCell()
        }

        let ingredientLine = recipe.ingredientLines[indexPath.row]
        cell.configure(withTitle: ingredientLine)

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

// TODO:    - sauvegarde de la recette ,
//          - affichage Loading et Error,
//          - capitalise recipe name,
//          - mettre une stack view pour traiter l'erreur sur l'iphone 5
//          - voir probleme de la shadow sur l'image
//          - mettre en permanance l'indicateur de scroll
