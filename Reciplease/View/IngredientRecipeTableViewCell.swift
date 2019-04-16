//
//  IngredientRecipeTableViewCell.swift
//  Reciplease
//
//  Created by David Dubez on 16/04/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class IngredientRecipeTableViewCell: UITableViewCell {

    // MARK: - OUTLETS
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(withTitle: String) {
        titleLabel.text = withTitle
    }
}
