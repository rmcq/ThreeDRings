//
//  MasterViewController.swift
//  ThreeDRings2
//
//  Created by Robert McQualter on 1/6/2022.
//

import UIKit

let charts = [
	Chart(chartTitle: "Cone and Cup", chartName: "conecup", binocular: false),
	Chart(chartTitle: "Small Cone", chartName: "smallcone", binocular: false),
	Chart(chartTitle: "Cup & Straw", chartName: "cupstraw", binocular: false),
	Chart(chartTitle: "Eight Shapes", chartName: "8shapes", binocular: false),
	Chart(chartTitle: "Spiral", chartName: "spiral", binocular: false),
	Chart(chartTitle: "Off Axis Spiral", chartName: "oaspiral", binocular: false),
	Chart(chartTitle: "Grating", chartName: "grating", binocular: false),
	Chart(chartTitle: "Binocular Cone and Cup", chartName: "bconecup", binocular: true),
	Chart(chartTitle: "Binocular Cone", chartName: "bcone", binocular: true),
	Chart(chartTitle: "Rotator", chartName: "rotator", binocular: true),
]

class MasterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		print("MDC viewDidLoad")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
    }

    // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
	  return charts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ChartTableViewCell
		let chart = charts[indexPath.row]
		cell.updateWithChart(chart)
		
		return cell
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		print("segue")
		if let nav = segue.destination as? UINavigationController {
			if let newVC = nav.topViewController as? DetailViewController {
				if let indexPath = tableView.indexPathForSelectedRow {
					Settings.shared.chartIndex = indexPath.row
					globalCurrentChart = charts[indexPath.row]
					newVC.currentChart = globalCurrentChart
					//newVC.configureChart()
					
					// Also update second screen if it exists.
					secondScreenVC?.currentChart = newVC.currentChart
//					secondScreenVC?.resetRotation()
					secondScreenVC?.configureChart()
				}
			}
		}
		
    }
	
	func selectCorrectRow() {
		// Select row.
		tableView.selectRow(at: IndexPath(row: Settings.shared.chartIndex, section: 0), animated: true, scrollPosition: .middle)

	}
}
