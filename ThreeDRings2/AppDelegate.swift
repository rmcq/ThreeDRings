//
//  AppDelegate.swift
//  ThreeDRings2
//
//  Created by Robert McQualter on 1/6/2022.
//

import UIKit
import UniformTypeIdentifiers
import CoreSpotlight
import Intents

var globalCurrentChart: Chart? // Keep track of the current chart for opening/closing external screen.
let controlChartUserActivityPrefix = "com.ausoptom.ThreeDRings.control."
let openChartUserActivityPrefix = "com.ausoptom.ThreeDRings.openchart."

enum UAControl: String, CaseIterable {
	case startRotation = "start"
	case stopRotation = "stop"
	case halfSpeed = "half"
	case threeQuarterSpeed = "slower"
	case normalSpeed = "normal"
	case fasterSpeed = "faster"
	case doubleSpeed = "double"
	case quadSpeed = "quad"
	case clockwiseRotation = "clockwise"
	case anticlockwiseRotation = "anticlockwise"
	case binocular = "binocular"
	case rightVisible = "rightVisible"
	case leftVisible = "leftVisible"
	case redOverRight = "redOverRight"
	case redOverLeft = "redOverLeft"
	case blackBackground = "bgBlack"
	case whiteBackground = "bgWhite"
	case colouredBackground = "bgColour"
	
	func description() -> String {
		switch self {
			case .startRotation:
				return "Start rotation"
			case .stopRotation:
				return "Stop rotation"
			case .halfSpeed:
				return "Half speed"
			case .threeQuarterSpeed:
				return "Three quarter speed"
			case .normalSpeed:
				return "Normal speed"
			case .fasterSpeed:
				return "Faster speed"
			case .doubleSpeed:
				return "Double speed"
			case .quadSpeed:
				return "Quad speed"
			case .clockwiseRotation:
				return "Clockwise rotation"
			case .anticlockwiseRotation:
				return "Anticlockwise rotation"
			case .binocular:
				return "Binocular"
			case .rightVisible:
				return "Visible to right eye"
			case .leftVisible:
				return "Visible to left eye"
			case .redOverRight:
				return "Red lens over right eye"
			case .redOverLeft:
				return "Red lens over left eye"
			case .blackBackground:
				return "Black background"
			case .whiteBackground:
				return "White background"
			case .colouredBackground:
				return "Coloured background"
		}
	}
	
	func userActivity() -> NSUserActivity {
		let actionIdentifier = controlChartUserActivityPrefix + rawValue
		let ua: NSUserActivity = NSUserActivity(activityType: actionIdentifier)
		
		let useDescription = description()
		
		ua.isEligibleForSearch = true
		ua.isEligibleForPrediction = true
		ua.suggestedInvocationPhrase = useDescription + " chart"
		
		ua.title = description()
		ua.userInfo = nil
		ua.persistentIdentifier = NSUserActivityPersistentIdentifier(actionIdentifier)
		
		let attributes = CSSearchableItemAttributeSet(itemContentType: UTType.item.identifier as String)
		attributes.thumbnailData = nil
		attributes.contentDescription = "Perform the action " + useDescription
		ua.contentAttributeSet = attributes
		
		return ua
	}
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var secondScreenScene: UIWindowScene?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		// Load settings.
		Settings.shared.load()
		globalCurrentChart = charts[Settings.shared.chartIndex]
		
		// Register UAControl items with Siri.
		var suggestions = [INShortcut]()
		// Add charts.
		for chart in charts {
			let suggestion = INShortcut(userActivity: chart.userActivity!)
			suggestions.append(suggestion)
		}

		for item in UAControl.allCases {
			let suggestion = INShortcut(userActivity: item.userActivity())
			suggestions.append(suggestion)
		}
		
		INVoiceShortcutCenter.shared.setShortcutSuggestions(suggestions)
		
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		// Is also called when an external display is connected.
		
		if connectingSceneSession.role == .windowExternalDisplay {
			// Connecting an external display.
			let sceneConfig = UISceneConfiguration(name: "External", sessionRole: .windowExternalDisplay)
			sceneConfig.storyboard = UIStoryboard(name: "External", bundle: nil)
			sceneConfig.delegateClass = SceneDelegate.self
			return sceneConfig
		}
		
		// Not an external screen. Weird.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
		
		// External screen disconnected?
		
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		Settings.shared.save()
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		Settings.shared.save()
	}

}

