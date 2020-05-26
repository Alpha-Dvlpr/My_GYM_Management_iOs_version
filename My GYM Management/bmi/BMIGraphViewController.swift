//
//  BMIGraphViewController.swift
//  My GYM Management
//
//  Created by Aarón on 26/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import SwiftCharts
import CoreData

class BMIGraphViewController: UIViewController {

    //MARK: Variables
    var chartView: LineChart!
    var bmiChartData: [(Double, Double)] = []
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBmiArray()
        showChart()
    }
    
    //MARK: Helpers
    
    /**
     This method inits an array from the data stored on CoreData.
     
     - Author: Aarón Granado Amores.
     */
    func initBmiArray() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BMI")
        var numberOfResults: Int!
        
        fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch,managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            
            numberOfResults = fetchedResultsController.fetchedObjects?.count ?? 0
        } catch {
            print("Error getting bmi data")
        }
        
        if numberOfResults != 0 {
            for position in 0...(numberOfResults - 1) {
                let bmi = fetchedResultsController.object(at: IndexPath(row: position, section: 0)) as! BMI
                
                bmiChartData.append((Double(position), bmi.calculatedBMI))
            }
        }
    }
    
    /**
     This method creates the chart and then it displays it on the view.
     
     - Author: Aarón Granado Amores.
     */
    func showChart() {
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0.0)
        let chartConfig = ChartConfigXY(xAxisConfig: ChartAxisConfig(from: 0, to: Double(bmiChartData.count - 1), by: 1),
                                        yAxisConfig: ChartAxisConfig(from: 0, to: 60, by: 10))
        let chartFrame = CGRect(x: 16, y: topBarHeight + 16, width: view.frame.width - 32, height: view.frame.height - topBarHeight - 32)
        let chart = LineChart(frame: chartFrame,
                              chartConfig: chartConfig,
                              xTitle: "",
                              yTitle: "Valor IMC",
                              lines: [(chartPoints: bmiChartData,
                                       color: UIColor.blue)]
        )
        
        self.view.addSubview(chart.view)
        self.chartView = chart
    }
}
