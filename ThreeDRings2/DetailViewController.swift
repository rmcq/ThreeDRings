//
//  DetailViewController.swift
//  ThreeDRings2
//
//  Created by Robert McQualter on 1/6/2022.
//

import UIKit
import IntentsUI
import UniformTypeIdentifiers
import CoreSpotlight

class DetailViewController: ImageController {

	@IBOutlet weak var playStopButton: UIBarButtonItem!
	@IBOutlet weak var colourButton: UIBarButtonItem?
	@IBOutlet weak var siriButton: UIBarButtonItem?
	
//
// MARK: - @IBAction functions

	@IBAction func startStopRotationButtonTapped(_ sender: UIBarButtonItem) {
		self.startStopRotation()
	}


	@IBAction func speedButtonTapped(_ sender: UIBarButtonItem) {
		self.showSpeedViewTo(sender)
	}

	@IBAction func colourButtonTapped(_ sender: UIBarButtonItem) {
		self.showColourViewTo(sender)
	}

	@IBAction func antiClockwiseButtonTapped(_ sender: UIBarButtonItem) {
		setDirectionToClockwise(false)
		userActivity = UAControl.anticlockwiseRotation.userActivity()
		if !currentlyRotating {
			startStopRotation()
		}
	}

	@IBAction func clockwiseButtonTapped(_ sender: UIBarButtonItem) {
		setDirectionToClockwise(true)
		userActivity = UAControl.clockwiseRotation.userActivity()
		if !currentlyRotating {
			startStopRotation()
		}
	}
	
	@IBAction func siriButtonTapped(_ sender: UIBarButtonItem) {
		// Display Siri view controller.
		displaySiriShortcutPopup()
	}

	// MARK: - ViewController functions
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		deviceScreenVC = self
		
		// Register to receive cahrt control messages.
		let mainQueue = OperationQueue.main
		NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "ChartControl"), object: nil, queue: mainQueue) { notification in
			if let controlName = notification.object as? String {
				self.controlChartFromActivityName(controlName)
			}
		}
    }
    
	override func viewWillAppear(_ animated: Bool) {
		// Set up image details.
		prepareChartAfterChange()
	}
	
	func prepareChartAfterChange() {
		configureChart()
		colourButton?.isEnabled = !(currentChart?.isBinocular ?? false)
		playStopButton.image = UIImage(systemName: currentlyRotating ? "pause.circle" : "play.circle")
		
		// Match rotation to the device display.
		if let ssiv = secondScreenVC?.imageView {
			if let tf = ssiv.layer.presentation()?.transform {
				imageView?.layer.transform = tf
			}
		}
		
		if currentlyRotating {
			startRotation()
		}
		
		// Set user activity to current chart.
		view.userActivity = currentChart?.userActivity
		currentChart?.userActivity?.becomeCurrent()
		
		// Enable Siri button.
		siriButton?.isEnabled = view.userActivity != nil
		
		// Make sure tableView item is correctly selected.
		masterVC?.selectCorrectRow()
	}
	
	// MARK: - DetailViewController functions
	func showColourViewTo(_ sourceButton: UIBarButtonItem) {
		let ac = UIAlertController(title: "Set MFBF Mode", message: "", preferredStyle: .actionSheet)
		
		if Settings.shared.mfbfMode != .binocular {
			ac.addAction(UIAlertAction(title: "Binocular", style: .default, handler: { ac in
				Settings.shared.bgMode = .white
				Settings.shared.mfbfMode = .binocular
				self.setColours()
				secondScreenVC?.setColours()
			}))
		}
		
		if Settings.shared.mfbfMode != .rightVisible {
			ac.addAction(UIAlertAction(title: "Right eye sees image", style: .default, handler: { ac in
				Settings.shared.mfbfMode = .rightVisible
				self.setColours()
				secondScreenVC?.setColours()
			}))
		}
		
		if Settings.shared.mfbfMode != .leftVisible {
			ac.addAction(UIAlertAction(title: "Left eye sees image", style: .default, handler: { ac in
				Settings.shared.mfbfMode = .leftVisible
				self.setColours()
				secondScreenVC?.setColours()
			}))
		}
		
		ac.addAction(UIAlertAction(title: "Switch to red over " + (!Settings.shared.redOverRight ? "right" : "left"), style: .default, handler: { ac in
			Settings.shared.redOverRight = !Settings.shared.redOverRight
			self.setColours()
			secondScreenVC?.setColours()
		}))
		
		if Settings.shared.bgMode != .black {
			ac.addAction(UIAlertAction(title: "Set background to black", style: .default, handler: { ac in
				Settings.shared.bgMode = .black
				self.setColours()
				secondScreenVC?.setColours()
			}))
		}
		
		if Settings.shared.bgMode != .white {
			ac.addAction(UIAlertAction(title: "Set background to white", style: .default, handler: { ac in
				Settings.shared.bgMode = .white
				self.setColours()
				secondScreenVC?.setColours()
			}))
		}
		
		if Settings.shared.bgMode != .colour {
			ac.addAction(UIAlertAction(title: "Set background to colour", style: .default, handler: { ac in
				Settings.shared.bgMode = .colour
				Settings.shared.mfbfMode = .leftVisible
				self.setColours()
				secondScreenVC?.setColours()
			}))
		}
		
		if Settings.shared.mfbfMode != .binocular {
			ac.addAction(UIAlertAction(title: "Modify colour...", style: .default, handler: { ac in
				// Show controller.
				let cp = UIColorPickerViewController()
				cp.delegate = self
				cp.selectedColor = Settings.shared.currentColour.uiColour()
				cp.supportsAlpha = false
				self.present(cp, animated: true)
			}))
		}
			
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		if let popoverController = ac.popoverPresentationController {
			popoverController.barButtonItem = sourceButton
		}
		
		self.present(ac, animated: true, completion: nil)
	}

	func showSpeedViewTo(_ sourceButton: UIBarButtonItem) {
		// Show a config view to set up direction and speed.
		let ac = UIAlertController(title: "Set Speed", message: "", preferredStyle: .actionSheet)
		
		ac.addAction(UIAlertAction(title: "½ x Speed", style: .default, handler: { (ac) in
			self.setSpeedTo(0.5)
			self.userActivity = UAControl.halfSpeed.userActivity()
		}))
		
		ac.addAction(UIAlertAction(title: "3/4 Speed", style: .default, handler: { (ac) in
			self.setSpeedTo(0.75)
			self.userActivity = UAControl.threeQuarterSpeed.userActivity()
		}))
		
		ac.addAction(UIAlertAction(title: "1 x Speed", style: .default, handler: { (aa) in
			self.setSpeedTo(1.0)
			self.userActivity = UAControl.normalSpeed.userActivity()
		}))
		
		ac.addAction(UIAlertAction(title: "1½ x Speed", style: .default, handler: { (ac) in
			self.setSpeedTo(1.5)
			self.userActivity = UAControl.fasterSpeed.userActivity()
		}))
		
		ac.addAction(UIAlertAction(title: "2 x Speed", style: .default, handler: { (ac) in
			self.setSpeedTo(2.0)
			self.userActivity = UAControl.doubleSpeed.userActivity()
		}))
		
		ac.addAction(UIAlertAction(title: "4 x Speed", style: .default, handler: { ac in
			self.setSpeedTo(4.0)
			self.userActivity = UAControl.quadSpeed.userActivity()
		}))
		
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		if let popoverController = ac.popoverPresentationController {
			popoverController.barButtonItem = sourceButton
		}
		
		self.present(ac, animated: true, completion: nil)
	}

	func startStopRotation() {
		// Start rotation or stop rotation.
		if currentlyRotating {
			self.stopRotation()
			secondScreenVC?.stopRotation()
			playStopButton.image = UIImage(systemName: "play.circle")
			Settings.shared.rotating = false
			userActivity = UAControl.stopRotation.userActivity()
			UAControl.startRotation.userActivity().becomeCurrent()
		} else {
			self.startRotation()
			secondScreenVC?.startRotation()
			playStopButton.image = UIImage(systemName: "pause.circle")
			Settings.shared.rotating = true
			userActivity = UAControl.startRotation.userActivity()
			UAControl.startRotation.userActivity().becomeCurrent()
		}
	}

	func setDirectionToClockwise(_ clockwise: Bool) {
		// Set rotation direction.
		Settings.shared.rotationDirectionClockwise = clockwise
		if Settings.shared.rotating {
			self.stopRotation()
			self.startRotation()
			secondScreenVC?.stopRotation()
			secondScreenVC?.startRotation()
		}
	}
	
	func setSpeedTo(_ speed: Double) {
		Settings.shared.chartSpeed = speed
		self.restartRotation()
		secondScreenVC?.restartRotation()
	}
	

}

extension DetailViewController: UIColorPickerViewControllerDelegate {
	func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect: UIColor, continuously: Bool) {
		//	func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
		// Get final colour selection.
		//let finalColour = viewController.selectedColor
		let finalColour = didSelect
		
		switch Settings.shared.currentColour {
			case .redBlackBG:
				Settings.shared.redColourBlackBackground = finalColour
				
			case .blueBlackBG:
				Settings.shared.blueColourBlackBackground = finalColour
				
			case .redWhiteBG:
				Settings.shared.redColourWhiteBackground = finalColour
				
			case .blueWhiteBG:
				Settings.shared.blueColourWhiteBackground = finalColour
				
			default:
				// Other colours shouldn't happen.
				break
		}
		
		setColours()
		secondScreenVC?.setColours()
	}
	
	// MARK: - Siri Intents / User Activity
	

	func openChartFromActivity() {
		// Open chart from user activity notification.
		prepareChartAfterChange()
	}
	
	func controlChartFromActivityName(_ controlName: String) {
		// Control chart.
		switch controlName {
			case "start":
				// Start rotation.
				startRotation()
				
			case "stop":
				stopRotation()
				
			case "half":
				setSpeedTo(0.5)
				
			case "slower":
				setSpeedTo(0.75)
				
			case "normal":
				setSpeedTo(1.0)
				
			case "faster":
				setSpeedTo(1.5)
				
			case "double":
				setSpeedTo(2.0)
				
			case "quad":
				setSpeedTo(4.0)
				
			case "clockwise":
				setDirectionToClockwise(true)
				
			case "anticlockwise":
				setDirectionToClockwise(false)
				
			case "binocular":
				Settings.shared.bgMode = .white
				Settings.shared.mfbfMode = .binocular
				self.setColours()
				secondScreenVC?.setColours()

			case "rightVisible":
				Settings.shared.mfbfMode = .rightVisible
				self.setColours()
				secondScreenVC?.setColours()

			case "leftVisible":
				Settings.shared.mfbfMode = .leftVisible
				self.setColours()
				secondScreenVC?.setColours()

			case "redOverRight":
				Settings.shared.redOverRight = true
				self.setColours()
				secondScreenVC?.setColours()

			case "redOverLeft":
				Settings.shared.redOverRight = false
				self.setColours()
				secondScreenVC?.setColours()

			case "bgBlack":
				Settings.shared.bgMode = .black
				self.setColours()
				secondScreenVC?.setColours()

			case "bgWhite":
				Settings.shared.bgMode = .white
				self.setColours()
				secondScreenVC?.setColours()
				
			case "bgColour":
				Settings.shared.bgMode = .colour
				Settings.shared.mfbfMode = .leftVisible
				self.setColours()
				secondScreenVC?.setColours()

			default:
				break
		}
	}
	
	func displaySiriShortcutPopup() {
		guard let userActivity = view.userActivity else { return }
		let shortcut = INShortcut(userActivity: userActivity)
		let vc = INUIAddVoiceShortcutViewController(shortcut: shortcut)
		vc.delegate = self
		present(vc, animated: true, completion: nil)
	}
	
}

extension DetailViewController: INUIAddVoiceShortcutViewControllerDelegate {
	func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
		dismiss(animated: true)
	}
	
	func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
		dismiss(animated: true)
	}
	
	
}

