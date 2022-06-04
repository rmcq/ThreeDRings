//
//  Settings.swift
//  ThreeDRings2
//
//  Created by Robert McQualter on 2/6/2022.
//

import UIKit

enum MFBFMode: Int {
	case binocular
	case rightVisible
	case leftVisible
	
	func bgColour() -> UIColor {
		var returnColour: ColourOptions = .noColour
		
		switch self {
			case .binocular:
				switch Settings.shared.bgMode {
					case .white:
						returnColour = .white
						
					case .black, .colour:
						returnColour = .black
						
				}
				
			case .rightVisible:
				switch Settings.shared.bgMode {
					case .black:
						returnColour = .black
					case .white:
						returnColour = .white
					case .colour:
						if Settings.shared.visibleWithRightEye {
							returnColour = Settings.shared.redOverRight ? .blueBlackBG : .redBlackBG
						} else {
							returnColour = Settings.shared.redOverRight ? .redBlackBG : .blueBlackBG
						}
						Settings.shared.currentColour = returnColour
				}
				
			case .leftVisible:
				switch Settings.shared.bgMode {
					case .black:
						returnColour = .black
						
					case .white:
						returnColour = .white
						
					case .colour:
						if Settings.shared.visibleWithRightEye {
							returnColour = Settings.shared.redOverRight ? .redBlackBG : .blueBlackBG
						} else {
							returnColour = Settings.shared.redOverRight ? .blueBlackBG : .redBlackBG
						}
						Settings.shared.currentColour = returnColour
				}
		}
		
		return returnColour.uiColour()
	}
	
	func fgColour() -> UIColor {
		var returnColour: ColourOptions = .noColour
		
		switch self {
			case .binocular:
				switch Settings.shared.bgMode {
					case .black:
						returnColour = .white
					case .white, .colour:
						returnColour = .black
				}
				
			case .rightVisible:
				switch Settings.shared.bgMode {
					case .black:
						returnColour = Settings.shared.redOverRight ? .redBlackBG : .blueBlackBG
						Settings.shared.currentColour = returnColour
						
					case .white:
						returnColour = Settings.shared.redOverRight ? .redWhiteBG : .blueWhiteBG
						Settings.shared.currentColour = returnColour
						
					case .colour:
						returnColour = .black
				}
				
			case .leftVisible:
				switch Settings.shared.bgMode {
					case .black:
						returnColour = Settings.shared.redOverRight ? .blueBlackBG : .redBlackBG
						Settings.shared.currentColour = returnColour
						
					case .white:
						returnColour = Settings.shared.redOverRight ? .blueWhiteBG : .redWhiteBG
						Settings.shared.currentColour = returnColour
						
					case .colour:
						returnColour = .black
				}
		}
		
		return returnColour.uiColour()
	}
}

enum BackgroundMode: Int {
	case white
	case black
	case colour
}

enum ColourOptions: Int {
	case redBlackBG
	case blueBlackBG
	case redWhiteBG
	case blueWhiteBG
	case noColour
	case white
	case black
	
	func uiColour() -> UIColor {
		switch self {
			case .redBlackBG:
				return Settings.shared.redColourBlackBackground
			case .blueBlackBG:
				return Settings.shared.blueColourBlackBackground
			case .redWhiteBG:
				return Settings.shared.redColourWhiteBackground
			case .blueWhiteBG:
				return Settings.shared.blueColourWhiteBackground
			case .noColour:
				return UIColor.black
			case .white:
				return .white
			case .black:
				return .black
		}
	}
}

class Settings: NSObject {

	static var shared = Settings() // Singleton.

	var chartIndex: Int = 0 // Which chart is currently displayed?
	var chartSpeed: Double = 1.0
	var rotating: Bool = false
	var rotationDirectionClockwise: Bool = true
	var redColourBlackBackground: UIColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0)
	var blueColourBlackBackground: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.6, alpha: 1.0)
	var redOverRight: Bool = true // Red lens over right eye or left eye?
	var blueColourWhiteBackground: UIColor = UIColor(red: 1.0, green: 1.0, blue: 0.4, alpha: 1.0)
	var redColourWhiteBackground: UIColor = UIColor(red: 0.4, green: 1.0, blue: 1.0, alpha: 1.0)
	var visibleWithRightEye: Bool = true // Image is visible with right eye. False = visible with left eye. Combine with redOverRight and backgroundWhite to determine which colour to use.
	var mfbfMode: MFBFMode = .binocular
	var bgMode: BackgroundMode = .white
	
	var currentColour: ColourOptions = .redBlackBG
	
	enum SettingKeys: String {
		case chartIndex = "chartIndex"
		case speed = "chartSpeed"
		case rotating = "rotating"
		case direction = "rotationDirectionClockwise"
		case red = "redColour"
		case blue = "blueColour"
		case redWB = "redColourWhiteBackground"
		case blueWB = "blueColourWhiteBackground"
		case redRight = "redOverRight"
		case visibleWithRight = "visibleWithRightEye"
		case mfbfMode = "MFBFMode"
		case bgMode = "BackgroundMode"
		case currentColour = "currentColour"
	}
	
	func save() {
		// Save locally
		let uD = UserDefaults.standard
		
		uD.set(chartIndex, forKey: SettingKeys.chartIndex.rawValue)
		uD.set(chartSpeed, forKey: SettingKeys.speed.rawValue)
		uD.set(rotating, forKey: SettingKeys.rotating.rawValue)
		uD.set(rotationDirectionClockwise, forKey: SettingKeys.direction.rawValue)
		uD.setColor(color: redColourBlackBackground, forKey: SettingKeys.red.rawValue)
		//		uD.setColor(color: greenColour, forKey: SettingKeys.green.rawValue)
		uD.setColor(color: blueColourBlackBackground, forKey: SettingKeys.blue.rawValue)
		uD.setColor(color: redColourWhiteBackground, forKey: SettingKeys.redWB.rawValue)
		uD.setColor(color: blueColourWhiteBackground, forKey: SettingKeys.blueWB.rawValue)
		uD.set(redOverRight, forKey: SettingKeys.redRight.rawValue)
		uD.set(visibleWithRightEye, forKey: SettingKeys.visibleWithRight.rawValue)
		uD.set(mfbfMode.rawValue, forKey: SettingKeys.mfbfMode.rawValue)
		uD.set(bgMode.rawValue, forKey: SettingKeys.bgMode.rawValue)
		uD.set(currentColour.rawValue, forKey: SettingKeys.currentColour.rawValue)
		
		// Save to iCloud if enabled?
		print("Settings saved.")
	}
	
	func load() {
		let uD = UserDefaults.standard
		
		let res = uD.double(forKey: SettingKeys.speed.rawValue)
		if res != 0.0 {
			chartSpeed = res
		}
		
		if let mf = MFBFMode(rawValue: uD.integer(forKey: SettingKeys.mfbfMode.rawValue)) {
			mfbfMode = mf
		}
		
		if let bg = BackgroundMode(rawValue: uD.integer(forKey: SettingKeys.bgMode.rawValue)) {
			bgMode = bg
		}
		
		if let cc = ColourOptions(rawValue: uD.integer(forKey: SettingKeys.currentColour.rawValue)) {
			currentColour = cc
		}
		
		chartIndex = uD.integer(forKey: SettingKeys.chartIndex.rawValue)
		rotating = uD.bool(forKey: SettingKeys.rotating.rawValue)
		rotationDirectionClockwise = uD.bool(forKey: SettingKeys.direction.rawValue)
		redOverRight = uD.bool(forKey: SettingKeys.redRight.rawValue)
		visibleWithRightEye = uD.bool(forKey: SettingKeys.visibleWithRight.rawValue)
		
		if let col = uD.colorForKey(key: SettingKeys.red.rawValue) {
			redColourBlackBackground = col
		}
		
		//		if let col = uD.colorForKey(key: SettingKeys.green.rawValue) {
		//			greenColour = col
		//		}
		
		if let col = uD.colorForKey(key: SettingKeys.blue.rawValue) {
			blueColourBlackBackground = col
		}
		
		if let col = uD.colorForKey(key: SettingKeys.redWB.rawValue) {
			redColourWhiteBackground = col
		}
		
		if let col = uD.colorForKey(key: SettingKeys.blueWB.rawValue) {
			blueColourWhiteBackground = col
		}
		
		
	}
	
}
