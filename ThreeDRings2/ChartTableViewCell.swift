//
//  ChartTableViewCell.swift
//  ThreeDRings
//
//  Created by Robert McQualter on 13/10/18.
//  Copyright © 2018 Robert McQualter. All rights reserved.
//

import UIKit

class ChartTableViewCell: UITableViewCell {
	@IBOutlet weak var chartImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!

	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func updateWithChart(_ chart: Chart) {
		chartImageView.image = UIImage(named: chart.name!)
		titleLabel.text = chart.title
	}

}
