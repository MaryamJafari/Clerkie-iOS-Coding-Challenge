//
//  PieChart.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/18/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit
import Charts
class PieChart: UIViewController {
    
    
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        
        let unitsSold = [200.0, 400.0, 600.0, 300.0, 1200.0, 160.0]
        setChart(dataPoints: months, values: unitsSold)
        
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i], data:  dataPoints[i] as AnyObject)
            
            dataEntries.append(dataEntry1)
            
        }
        
        
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Spending Report")
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        
        
        
        var colors: [UIColor] = []
        
        
        
        for _ in 0..<dataPoints.count {
            
            let red = Double(arc4random_uniform(256))
            
            let green = Double(arc4random_uniform(256))
            
            let blue = Double(arc4random_uniform(256))
            
            
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            
            colors.append(color)
            
        }
        
        
        
        pieChartDataSet.colors = colors
        
    }
    
}
