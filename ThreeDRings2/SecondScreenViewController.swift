//
//  SecondScreenViewController.swift
//  ThreeDRings
//
//  Created by Robert McQualter on 12/10/18.
//  Copyright © 2018 Robert McQualter. All rights reserved.
//

import UIKit

class SecondScreenViewController: ImageController {
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		configureChart()
		
		// Match rotation to device screen.
		// Match rotation to the device display.
		if let dviv = deviceScreenVC?.imageView {
			if let tf = dviv.layer.presentation()?.transform {
				imageView?.layer.transform = tf
			}
		}
		
		if currentlyRotating {
			startRotation()
		}

	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
