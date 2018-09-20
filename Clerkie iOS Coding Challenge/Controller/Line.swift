//
//  Line.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/18/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit
import Charts
class Line: UIViewController {
    var months: [String]!
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let unitsSold = [200.0, 40.0, 60.0, 30.0, 120.0, 160.0]
        
        setChart(y: unitsSold)
    }
    
    func setChart(y: [Double]) {
        var dataEntries = [BarChartDataEntry]()
        
        for (i, val) in y.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(i), y: val) 
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Commute Expence")
        barChartView.data = BarChartData(dataSet: chartDataSet)
        
        let xaxis = XAxis()
        xaxis.valueFormatter = BarChartFormatter()
        barChartView.xAxis.valueFormatter = xaxis.valueFormatter
        barChartView.xAxis.labelPosition = .bottom
        chartDataSet.colors = [UIColor(red:0.00, green:0.50, blue:0.93, alpha:1.8)]
        barChartView.backgroundColor = UIColor.white
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        let ll = ChartLimitLine(limit: 150.0, label: "Assigned Budget")
        barChartView.rightAxis.addLimitLine(ll)
        
        barChartView.chartDescription?.text = ""
    }
    
    
 
}
public class BarChartFormatter: NSObject, IAxisValueFormatter{
    
    var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        // 0 -> Jan, 1 -> Feb...
        return months[Int(value)]
    }
}
