//
//  SceneDelegate.swift
//  ThreeDRings2
//
//  Created by Robert McQualter on 1/6/2022.
//

import UIKit

var secondScreenVC: SecondScreenViewController?
var deviceScreenVC: DetailViewController?
var masterVC: MasterViewController?

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
		guard let _ = (scene as? UIWindowScene) else { return }
		
		// OK, we now need to set up the second screen UI.
		// Just use a global secondScreenVC variable for now.
		if session.role == .windowExternalDisplay {
			secondScreenVC = window?.rootViewController as? SecondScreenViewController
			
			// Update it to the current chart.
			secondScreenVC?.currentChart = globalCurrentChart
			
		} else {
			let splitVC = window!.rootViewController as! UISplitViewController
			let navC = splitVC.viewControllers[0] as! UINavigationController
			masterVC = navC.viewControllers[0] as? MasterViewController
		}
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
		secondScreenVC = nil
	}

	func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
		print("Got user activity")
		
		// Restore user activity type.
		// Check if its a chart.
		if userActivityType.starts(with: openChartUserActivityPrefix) {
			// Want to open this chart. Find which chart it is, then open that chart in the detail view.
			let index = userActivityType.index(userActivityType.startIndex, offsetBy: openChartUserActivityPrefix.count)
			let chartSearchName = String(userActivityType[index...])
			var chartNum = 0
			while chartNum < charts.count && charts[chartNum].name != chartSearchName {
				chartNum += 1
			}
			
			// Found a chart? Open it.
			if chartNum < charts.count {
				print("Open chart " + charts[chartNum].title!)
				Settings.shared.chartIndex = chartNum
				globalCurrentChart = charts[chartNum]
				if let dvc = deviceScreenVC {
					dvc.prepareChartAfterChange()
					// Select the right line in the MasterViewController.
					
					if let ssvc = secondScreenVC {
						ssvc.configureChart()
					}
					
				}
			}
		} else if userActivityType.starts(with: controlChartUserActivityPrefix) {
			let index = userActivityType.index(userActivityType.startIndex, offsetBy: controlChartUserActivityPrefix.count)
			let controlName = String(userActivityType[index...])
			
			// Is a control function.
			// TODO: Need to implement chart control from Siri.
			print("Control: " + controlName)
			NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ChartControl"), object: controlName, userInfo: nil))
		}

	}
	
	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.
		if scene.session.role == .windowApplication {
			Settings.shared.save()
		}
	}


}

