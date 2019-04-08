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

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setPhotoBorder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(withRecipeName: String, ingredients: [String], prepTime: Int?, rating: Int?) {
        recipeNameLabel.text = withRecipeName
        ingredientsLabel.text = "\(ingredients)"
        if let prepTimeValue = prepTime {
            prepTimeLabel.text = String(prepTimeValue)
        }
        if let ratingValue = rating {
            ratingLabel.text = String(ratingValue)
        }
        // TODO: configure image
        smallImage.image = UIImage(named: "noPhoto")
    }
    private func setPhotoBorder() {
        photoBorder.layer.zPosition = 1
        smallImage.layer.zPosition = 0
    }
}
