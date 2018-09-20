//
//  LineChart.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/18/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit
import Charts
class LineChart: UIViewController {
    
    @IBOutlet weak var randomize: RoundedCornerButton!
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var xvalues: [String] = [String]()
        xvalues.append("Jan")
        xvalues.append("Feb")
        xvalues.append("Mar")
        xvalues.append("Apr")
        xvalues.append("May")
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bothSided
        xAxis.axisMinimum = 0.0
        xAxis.granularity = 1.0
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xvalues)
        
        let data = generateLineData()
        lineChartView.data = data
        
        
    }
    
    func generateLineData() -> LineChartData {
        
        var values = [ChartDataEntry]()
        for i in 0..<5{
            let val = Double(arc4random_uniform(UInt32(1000)) + 3)
            let value = ChartDataEntry(x: Double(i), y: val)
            print(value)
            values.append(value)
        }
        
        
        let set = LineChartDataSet(values: values, label: "Utility Bil")
        
        
        set.setCircleColor(UIColor.blue)
        set.lineWidth = 1
        set.circleRadius = 5
        set.drawCircleHoleEnabled = true
        set.valueTextColor = UIColor.blue
        set.valueFont = UIFont(name: "Avenir Next", size: 12.0)!
        set.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set)
        data.addDataSet(set)
        
        return data
    }
}

