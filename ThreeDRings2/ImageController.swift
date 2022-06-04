//
//  ImageController.swift
//  ThreeDRings2
//
//  Created by Robert McQualter on 2/6/2022.
//

import Foundation
import UIKit

//protocol ImageController {
//	var currentlyRotating: Bool {get set}
//	var imageView: UIImageView? {get set}
//	var currentChart: Chart? {get set}
//
//	mutating func startRotation()
//	mutating func stopRotation()
//	mutating func setSpeedTo(_ newSpeed: Float)
//
//	func configureChart()
//	func setColours()
//}

class ImageController: UIViewController {
	@IBOutlet var imageView: UIImageView?
	var currentlyRotating: Bool = false
	var currentChart: Chart?
	
	// Default functions.
	func startRotation() {
		let rotation = CABasicAnimation(keyPath: "transform.rotation")
		let currentAngleNum:NSNumber = imageView?.layer.value(forKeyPath: "transform.rotation.z") as! NSNumber
		let currentAngle = currentAngleNum.floatValue
		rotation.fromValue = currentAngle
		rotation.toValue = 2.0 * Float.pi + currentAngle
		if !Settings.shared.rotationDirectionClockwise {
			rotation.toValue = -(2.0 * Float.pi) + currentAngle
		}
		
		rotation.duration = (currentChart?.defaultRate ?? 5) / Settings.shared.chartSpeed
		rotation.repeatCount = Float.infinity
		rotation.isRemovedOnCompletion = false
		
		imageView?.layer.add(rotation, forKey: "Spin")
		currentlyRotating = true
		Settings.shared.rotating = true
	}
	
	func stopRotation() {
		// Stop rotation.
		if let tf = imageView?.layer.presentation()?.transform {
			imageView?.layer.transform = tf
		}
		imageView?.layer.removeAnimation(forKey: "Spin")
		currentlyRotating = false
		Settings.shared.rotating = false
	}
	
	func configureChart() {
		// Set up new chart.
		guard let chart = globalCurrentChart else {return}
		currentChart = chart
		imageView?.image = UIImage(named: chart.name!)
		currentlyRotating = Settings.shared.rotating
		setColours()
	}

	func setColours() {
		// Set colours of imageView appropriately.
		guard let bgView = imageView?.superview else { return }
		
		if currentChart != nil && currentChart!.isBinocular {
			bgView.backgroundColor = .white
			imageView?.tintColor = .black
		} else {
			bgView.backgroundColor = Settings.shared.mfbfMode.bgColour()
			imageView?.tintColor = Settings.shared.mfbfMode.fgColour()
		}
	}
	
	func restartRotation() {
		if currentlyRotating {
			stopRotation()
			startRotation()
		}
	}
	
//	func resetRotation() {
//		// Remove transform, reset starting point for animation.
//		// Used so both the external screen (which isn't destroyed and recreated when the MasterViewController cell is changed), and the device screen (which is) can stay in sync.
//		stopRotation(reset: true)
//
//	}
}
