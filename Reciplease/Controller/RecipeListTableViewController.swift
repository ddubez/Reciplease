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
    var recipeListMatches: [RecipeList.Matche]!
    var numberOfResult = 0
    var selectedRecipeId = ""
    let offSetForLoadingData = CGFloat(100)
    var isLoadingMore = false

    // MARK: - IBOUTLETS
    @IBOutlet weak var totalMatchesLabel: UILabel!
    @IBOutlet weak var footerRecipeListTableView: UIView!

    // MARK: - METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        totalMatchesLabel.text = "\(numberOfResult)"
        footerRecipeListTableView.isHidden = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeListMatches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeListTableViewCell",
                                                       for: indexPath) as? RecipeListTableViewCell else {
                                                        return UITableViewCell()
        }

        if recipeListMatches[indexPath.row].listImage == nil {
            // get image for the recipe in the cell only if not already get

            if let smallImageUrls = recipeListMatches[indexPath.row].smallImageUrls {
                let recipeImageService = RecipeImageService()
                recipeImageService.getIconImage(imageUrl: smallImageUrls[0], completionHandler: { (data) in
                    guard let data = data else {
                        self.recipeListMatches[indexPath.row].listImage = UIImage(named: "defaultPhoto")
                        tableView.reloadData()
                        return
                    }
                    self.recipeListMatches[indexPath.row].listImage = UIImage(data: data)
                    tableView.reloadData()
                })
            } else {
                recipeListMatches[indexPath.row].listImage = UIImage(named: "defaultPhoto")
            }
        }

        // configure the cell
        let recipe = recipeListMatches[indexPath.row]
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

            let numberOfRecipeDisplayed = recipeListMatches.count

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
                    self.recipeListMatches.append(matche)
                }

                self.tableView.reloadData()
            } else {
                self.displayAlert(with: error)
            }
        }
    }

    private func toggleFooter(loading: Bool) {
        isLoadingMore = loading
        footerRecipeListTableView.isHidden = !loading
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipeId = recipeListMatches[indexPath.row].referenceId
        self.performSegue(withIdentifier: "segueToRecipe", sender: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRecipe" {
            if let recipeVC = segue.destination as? RecipeViewController {
                recipeVC.recipeId = selectedRecipeId
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle:
     UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array,
     and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
// MARK: - Alert
extension RecipeListTableViewController {
    func displayAlert(with message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
// TODO:    - ajouter titre dans la navigation bar
//          - format spérateur milier pour nombre recherches
//          - Refactoriser
