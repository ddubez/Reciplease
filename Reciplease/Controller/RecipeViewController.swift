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

    // MARK: - METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        RecipeService.shared.getRecipe(recipeId: recipeId) { (success, recipe, error) in
            if success == true, let recipeGetted = recipe {
                self.recipe = recipeGetted
            } else {
                self.displayAlert(with: error)
            }
        }
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
// TODO: capitalise recipe name, mettre une stack view pour traiter l'erreur sur l'iphone 5

// MARK: - Alert
extension RecipeViewController {
    func displayAlert(with message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
