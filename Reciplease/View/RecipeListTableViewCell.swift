//
//  RecipeListTableViewCell.swift
//  Reciplease
//
//  Created by David Dubez on 06/04/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class RecipeListTableViewCell: UITableViewCell {

    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var photoBorder: UIImageView!
    @IBOutlet weak var blocView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setPhotoBorder()
        addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configure(withRecipeName: String, ingredients: [String], prepTime: Int?, rating: Int?, image: UIImage?) {
        recipeNameLabel.text = withRecipeName
        ingredientsLabel.text = setListOf(ingredients: ingredients)
        if let prepTimeValue = prepTime {
            let prepTimeInMinute = prepTimeValue / 60
            prepTimeLabel.text = String(prepTimeInMinute) + " min"
        }
        if let ratingValue = rating {
            ratingLabel.text = String(ratingValue)
        }
        if let imageData = image {
            smallImage.image = imageData
        }
    }
    private func setPhotoBorder() {
        photoBorder.layer.zPosition = 1
        smallImage.layer.zPosition = 0
    }
    private func addShadow() {
        blocView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        blocView.layer.shadowRadius = 2.0
        blocView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        blocView.layer.shadowOpacity = 2.0
    }
    private func setListOf(ingredients: [String]) -> String {
        var listOfIngredients = ""
        for ingredient in ingredients {
            listOfIngredients += ingredient
            listOfIngredients += " "
        }
        return listOfIngredients
    }
}
