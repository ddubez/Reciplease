//
//  RecipeListTableViewController.swift
//  Reciplease
//
//  Created by David Dubez on 11/03/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class RecipeListTableViewController: UITableViewController {

    // MARK: - PROPERTIES
    var resultRecipeListMatches: [RecipeList.Matche]?
    var recipeListToDisplay = [RecipeList.Matche]()
    var numberOfResult = 0
    var selectedRecipeId = ""
    let offSetForLoadingData = CGFloat(100)
    var isLoadingMore = false
    var isDiplayingFavorite = false

    let recipeStorageManager = RecipeStorageManager()

    // MARK: - IBOUTLETS
    @IBOutlet weak var totalMatchesLabel: UILabel!
    @IBOutlet weak var footerRecipeListTableView: UIView!

    // MARK: - METHODS

    override func viewDidLoad() {
        super.viewDidLoad()

        if let recipeListMatches = resultRecipeListMatches {
            isDiplayingFavorite = false
            recipeListToDisplay = recipeListMatches
            totalMatchesLabel.text = formatNumberOfResults(with: numberOfResult,
                                                           title: NSLocalizedString("Total matches : ",
                                                                                    comment: ""))
        } else {
            isDiplayingFavorite = true
            recipeListToDisplay = importFavoriteRecipe()
            totalMatchesLabel.text = formatNumberOfResults(with: recipeListToDisplay.count,
                                                           title: NSLocalizedString("Number of favorites : ",
                                                                                    comment: ""))
        }

        footerRecipeListTableView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isDiplayingFavorite == true {
            recipeListToDisplay = importFavoriteRecipe()
            totalMatchesLabel.text = formatNumberOfResults(with: recipeListToDisplay.count,
                                                    title: NSLocalizedString("Number of favorites : ", comment: ""))
            tableView.reloadData()
            if recipeListToDisplay.count == 0 {
                displayAlert(with:
                    NSLocalizedString("sorry, you don't have favorite recipe !", comment: "") + "\n"
                        + NSLocalizedString("you can save a recipe by tapping the star", comment: "") + "\n"
                        + NSLocalizedString("on the upper right of search result screen !", comment: "")
                    )
            }
        }
    }

    private func importFavoriteRecipe() -> [RecipeList.Matche] {
        return recipeStorageManager.fetchAllStored().compactMap(RecipeList.Matche.init(with:))
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeListToDisplay.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeListTableViewCell",
                                                       for: indexPath) as? RecipeListTableViewCell else {
                                                        return UITableViewCell()
        }

        if recipeListToDisplay[indexPath.row].listImage == nil {
            // get image for the recipe in the cell only if not already get

            if let smallImageUrls = recipeListToDisplay[indexPath.row].smallImageUrls {
                let recipeImageService = RecipeImageService()
                recipeImageService.getIconImage(imageUrl: smallImageUrls[0], completionHandler: { (data) in
                    guard let data = data else {
                        self.recipeListToDisplay[indexPath.row].listImage = UIImage(named: "defaultPhoto")
                        tableView.reloadData()
                        return
                    }
                    self.recipeListToDisplay[indexPath.row].listImage = UIImage(data: data)
                    tableView.reloadData()
                })
            } else {
                recipeListToDisplay[indexPath.row].listImage = UIImage(named: "defaultPhoto")
            }
        }

        // configure the cell
        let recipe = recipeListToDisplay[indexPath.row]
        cell.configure(withRecipeName: recipe.recipeName,
                       ingredients: recipe.ingredients,
                       prepTime: recipe.totalTimeInSeconds,
                       rating: recipe.rating,
                       image: recipe.listImage)
        return cell

    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Load more recipe when user reach the bottom of the list
        let maxOffSet = (scrollView.contentSize.height - scrollView.frame.size.height)
        if !isLoadingMore
            && scrollView.contentOffset.y >= 0
            && scrollView.contentOffset.y + offSetForLoadingData >=  maxOffSet {

            let numberOfRecipeDisplayed = recipeListToDisplay.count

            if numberOfRecipeDisplayed < numberOfResult {
                toggleFooter(loading: true)
                getMoreRecipe(start: numberOfRecipeDisplayed)
            }
        }
    }

    private func getMoreRecipe(start: Int) {
        RecipeListService.shared.getRecipeList(searchPhrase:
        IngredientService.shared.searchList, start: start) {(success, recipeListMatches, numberOfResult, error) in
            self.toggleFooter(loading: false)

            if success == true, let recipeListMatches = recipeListMatches, let numberOfResult = numberOfResult {
                self.numberOfResult = numberOfResult

                for matche in recipeListMatches {
                    self.recipeListToDisplay.append(matche)
                }

                self.tableView.reloadData()
            } else {
                if let error = error {
                    self.displayAlert(with: error.message)
                }
            }
        }
    }

    private func toggleFooter(loading: Bool) {
        isLoadingMore = loading
        footerRecipeListTableView.isHidden = !loading
    }

    private func formatNumberOfResults(with number: Int, title: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "fr_FR")

        if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
            return title + formattedNumber
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipeId = recipeListToDisplay[indexPath.row].referenceId
        self.performSegue(withIdentifier: "segueToRecipe", sender: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRecipe" {
            if let recipeVC = segue.destination as? RecipeViewController {
                recipeVC.selectedRecipeId = selectedRecipeId
            }
        }
    }

}
// MARK: - Alert
extension RecipeListTableViewController {
    func displayAlert(with message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error!", comment: ""),
                                      message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
