//
//  Chart.swift
//  ThreeDRings
//
//  Created by Robert McQualter on 12/10/18.
//  Copyright © 2018 Robert McQualter. All rights reserved.
//

import UIKit
import Intents
import CoreSpotlight
import CoreServices
import UniformTypeIdentifiers

class Chart: NSObject {
	var title: String?
	var name: String?
	var image: UIImage?
	var isBinocular: Bool = false
	var defaultRate: CFTimeInterval = 2
	var userActivity: NSUserActivity? // To record when we use this chart, so it can be predicted.
	
	init(chartTitle: String, chartName: String, img: UIImage? = nil, binocular: Bool, defTime: CFTimeInterval = 5) {
		title = chartTitle
		name = chartName
		image = img
		isBinocular = binocular
		defaultRate = defTime
		
		// Create userActivity for this chart.
		let actionIdentifier = openChartUserActivityPrefix + chartName
		userActivity = NSUserActivity(activityType: actionIdentifier)
		userActivity?.title = "Show " + chartTitle
		userActivity?.userInfo = nil
		userActivity?.isEligibleForSearch = true
		userActivity?.isEligibleForPrediction = true
		userActivity?.persistentIdentifier = NSUserActivityPersistentIdentifier(actionIdentifier)
		let attributes = CSSearchableItemAttributeSet(itemContentType: UTType.item.identifier as String)
		let image = UIImage(named: chartName)
		attributes.thumbnailData = image?.pngData()
		attributes.contentDescription = "Open " + chartTitle
		userActivity?.contentAttributeSet = attributes

	}
}
