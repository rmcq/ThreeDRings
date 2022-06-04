//
//  UserDefaultsExtension.swift
//  ThreeDRings
//
//  Created by Robert McQualter on 15/5/2022.
//  Copyright © 2022 Robert McQualter. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults {
	func colorForKey(key: String) -> UIColor? {
		var colourReturned: UIColor?
		if let colourData = data(forKey: key) {
			do {
				if let colour = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colourData) as? UIColor {
					colourReturned = colour
				}
			} catch {
				print("Error UserDefaults")
			}
		}
		return colourReturned
	}
	
	func setColor(color: UIColor?, forKey key: String) {
		var colorData: NSData?
		if let color = color {
			do {
				let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
				colorData = data
			} catch {
				print("Error UserDefaults")
			}
		}
		set(colorData, forKey: key)
	}
}
