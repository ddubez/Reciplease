//
//  IngredientTableViewCell.swift
//  Reciplease
//
//  Created by David Dubez on 11/03/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    // MARK: - OUTLETS
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(withTitle: String) {
        titleLabel.text = withTitle
    }

}
