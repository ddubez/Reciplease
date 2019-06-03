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

    var selectedRecipeId: String?
    var recipe: Recipe?
    var sourceRecipeUrl = ""
    var ifRecipeStored = false

    let recipeStorageManager = RecipeStorageManager()

    enum DisplayState {
        case loading, loaded, error
    }

    // MARK: - OUTLETS
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageBox: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var preparationTimeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var getDirectionButton: UIButton!
    @IBOutlet weak var attributionLabel: UILabel!
    @IBOutlet weak var attributionUrl: UILabel!
    @IBOutlet weak var attributionImage: UIImageView!
    @IBOutlet weak var ingredientsStackView: UIStackView!
    @IBOutlet weak var attributionsStackView: UIStackView!

    // MARK: - ACTIONS
    @IBAction func didTapSaveRecipe(_ sender: UIBarButtonItem) {
        saveOrDeleteRecipe()
    }

    @IBAction func didTapGetDirectionButton(_ sender: UIButton) {
        openUrlRecipe()
    }

    // MARK: - METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageBox()
        setRecipeDisplay(displayState: .loading)

        if let recipeId = selectedRecipeId {
            setSelectedRecipe(from: recipeId)
        } else {
            self.navigationController?.popViewController(animated: true)
        }

        // Gesture recognizer for open browser on the attribution url
        let attributionsGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                   action: #selector(openUrlRecipeAttribution))
        self.attributionsStackView.addGestureRecognizer(attributionsGestureRecognizer)
    }

    private func setSelectedRecipe(from recipeId: String) {
        // fetch if recipe is in store and if not get it from API
        if let favoriteRecipe = recipeStorageManager.fetchStored(recipeId: recipeId) {
            saveButton.image = UIImage(named: "selectedStar")
            self.recipe = favoriteRecipe
            self.setRecipeDisplay(displayState: .loaded)
        } else {
            RecipeService.shared.getRecipe(recipeId: recipeId) { (success, recipe, error) in
                if success == true, let recipeGetted = recipe {
                    self.recipe = recipeGetted
                    self.setRecipeDisplay(displayState: .loaded)
                } else {
                    if let error = error {
                        self.displayAlert(with: error.message)
                    }
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
            nameLabel.text = NSLocalizedString("Loading ... ", comment: "")
            recipeImage.image = UIImage(named: "defaultPhoto")
            preparationTimeLabel.text = "..."
            ratingLabel.text = "..."
        case .loaded:
            toggleIngredientsList(searching: false)
            guard let recipe = recipe else { return }
            getDirectionButton.isHidden = false
            loadRecipe(recipe)

        case .error:
            toggleIngredientsList(searching: false)
            getDirectionButton.isHidden = true
            ingredientsStackView.isHidden = true
            nameLabel.text = NSLocalizedString("Sorry, no recipe", comment: "")
            recipeImage.image = UIImage(named: "defaultPhoto")
            preparationTimeLabel.text = "?"
            ratingLabel.text = "?"
        }
    }

    private func loadRecipe(_ recipeToLoad: Recipe) {
        nameLabel.text = recipeToLoad.name
        let totalTimeInMinute = recipeToLoad.totalTimeInSeconds / 60
        preparationTimeLabel.text = String(totalTimeInMinute) + " min"
        ratingLabel.text = String(recipeToLoad.rating)
        if let sourceRecipeUrlString = recipeToLoad.source?.sourceRecipeUrl {
            sourceRecipeUrl = sourceRecipeUrlString
        }
        if let attributionText = recipeToLoad.attribution?.attributionText {
            attributionLabel.text = attributionText
        }
        if let attributionTextUrl = recipeToLoad.attribution?.attributionUrl {
            attributionUrl.text = attributionTextUrl
        }
        if let attributionImageUrl = recipeToLoad.attribution?.attributionLogo {
            getImageForAttributionLogo(from: attributionImageUrl)
        }
        if let imageToDisplay = recipeToLoad.imageForList {
            recipeImage.image = UIImage(data: imageToDisplay)
        } else if let imagesRecipeUrl = recipeToLoad.images?.hostedLargeUrl {
            getImageForRecipe(from: imagesRecipeUrl)
        }

        guard let ingredientLines = recipeToLoad.ingredientLines else {
            return
        }
        for ingredientLine in ingredientLines {
            if let ingredientLine = ingredientLine as? IngredientLine {
                if let ingredient = ingredientLine.line {
                    createNewIngredientLine(name: ingredient)
                }
            }
        }
    }

    private func getImageForRecipe(from: String) {
        let recipeImageService = RecipeImageService()
        recipeImageService.getIconImage(imageUrl: from, completionHandler: { (data) in
            guard let data = data else {
                return
            }
            self.recipeImage.image = UIImage(data: data)
            if let recipe = self.recipe {
                recipe.imageForList = data
            }
        })
    }

    private func getImageForAttributionLogo(from: String) {
        let recipeImageService = RecipeImageService()
        recipeImageService.getIconImage(imageUrl: from, completionHandler: { (data) in
            guard let data = data else {
                self.attributionImage.isHidden = true
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
        ingredientsStackView.isHidden = searching
    }

    private func createNewIngredientLine(name: String) {
        let ingredientLabel = UILabel()
        ingredientLabel.text = "    - " + name
        ingredientLabel.numberOfLines = 0
        ingredientLabel.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        ingredientLabel.font = UIFont(name: "GloriaHallelujah", size: 14)
        ingredientsStackView.addArrangedSubview(ingredientLabel)
    }

    @objc func openUrlRecipeAttribution() {
        if let urlAttributionString = attributionUrl.text {
        guard let urlAttribution = URL(string: urlAttributionString) else { return }
        UIApplication.shared.open(urlAttribution)
        }
    }

    private func saveOrDeleteRecipe() {
        if saveButton.image == UIImage(named: "selectedStar"), let recipeToDelete = recipe {
            // Delete recipe
            do {
                if let recipeIdToDelete = recipeToDelete.recipeId {
                    try recipeStorageManager.deleteRecipe(recipeId: recipeIdToDelete)
                }
                saveButton.image = UIImage(named: "star")
            } catch let error {
                displayAlert(with: error.message)
            }

        } else {
            if let recipeToSave = recipe {
                // Save recipe
                do {
                    try recipeStorageManager.saveRecipe(recipeToSave)
                    saveButton.image = UIImage(named: "selectedStar")
                } catch let error {
                    displayAlert(with: error.message)
                }
            }
        }
    }
}

// MARK: - Alert
extension RecipeViewController {
    func displayAlert(with message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error!", comment: ""),
                                      message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
