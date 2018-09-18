//
//  Pie.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/18/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit
import CorePlot
class Pie: UIViewController {

    
    var base: Currency!
    var rate: Rate!
    var symbols: [Currency]!
    
    @IBOutlet weak var hostView: CPTGraphHostingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        symbols = Currency.currencies
        rate = Rate(date: "2018-08-01", base: "kj", rates: ["USD": 2.1, "USD2" : 1.2, "EUR" : 2.3, "GBP": 3.4 , "CHF" : 4.0, "CAD" : 3.6])
        // add the base currency to the symbols, so it will show on the graph
        symbols.insert(base, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initPlot()
    }
    
    func initPlot() {
        configureHost()
        configureGraph()
        configureChart()
        configureLegend()
    }
    
    func configureHost() {
        hostView.allowPinchScaling = false
    }
    
    func configureGraph() {
        // 1 - Create and configure the graph
        let graph = CPTXYGraph(frame: hostView.bounds)
        hostView.hostedGraph = graph
        graph.paddingLeft = 0.0
        graph.paddingTop = 0.0
        graph.paddingRight = 0.0
        graph.paddingBottom = 0.0
        graph.axisSet = nil
        
        // 2 - Create text style
        let textStyle: CPTMutableTextStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.black()
        textStyle.fontName = "Avenir Next"
        textStyle.fontSize = 16.0
        textStyle.textAlignment = .center
        
        // 3 - Set graph title and text style
        graph.title = "USD Exchange Rate 2018-08-10"
        graph.titleTextStyle = textStyle
        graph.titlePlotAreaFrameAnchor = CPTRectAnchor.top
    }
    
    func configureChart() {
        // 1 - Get a reference to the graph
        let graph = hostView.hostedGraph!
        
        // 2 - Create the chart
        let pieChart = CPTPieChart()
        pieChart.delegate = self
        pieChart.dataSource = self
        pieChart.pieRadius = (min(hostView.bounds.size.width, hostView.bounds.size.height) * 0.7) / 2
        pieChart.identifier = NSString(string: "Clerkie")
        pieChart.startAngle = CGFloat(M_PI_4)
        pieChart.sliceDirection = .clockwise
        pieChart.labelOffset = -0.6 * pieChart.pieRadius
        
        // 3 - Configure border style
        let borderStyle = CPTMutableLineStyle()
        borderStyle.lineColor = CPTColor.white()
        borderStyle.lineWidth = 2.0
        pieChart.borderLineStyle = borderStyle
        
        // 4 - Configure text style
        let textStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.white()
        textStyle.textAlignment = .center
        pieChart.labelTextStyle = textStyle
        
        // 5 - Add chart to graph
        graph.add(pieChart)
    }
    
    func configureLegend() {
        // 1 - Get graph instance
        guard let graph = hostView.hostedGraph else { return }
        
        // 2 - Create legend
        let theLegend = CPTLegend(graph: graph)
        
        // 3 - Configure legend
        theLegend.numberOfColumns = 1
        theLegend.fill = CPTFill(color: CPTColor.white())
        let textStyle = CPTMutableTextStyle()
        textStyle.fontSize = 18
        theLegend.textStyle = textStyle
        
        // 4 - Add legend to graph
        graph.legend = theLegend
        if view.bounds.width > view.bounds.height {
            graph.legendAnchor = .right
            graph.legendDisplacement = CGPoint(x: -20, y: 0.0)
            
        } else {
            graph.legendAnchor = .bottomRight
            graph.legendDisplacement = CGPoint(x: -8.0, y: 8.0)
        }
    }
    
}

extension Pie: CPTPieChartDataSource, CPTPieChartDelegate {
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(symbols.count)
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        let symbol = symbols[Int(idx)]
        //rate = Rate(date: "2018-08-01", base: "kj", rates: ["1": 1.1, "2" : 2.2])
        let currencyRate = rate.rates[symbol.name]!.floatValue

       
        return 1.0 / currencyRate
    }
    
    func dataLabel(for plot: CPTPlot, record idx: UInt) -> CPTLayer? {
        let value = rate.rates[symbols[Int(idx)].name]!.floatValue
        let layer = CPTTextLayer(text: String(format: "\(symbols[Int(idx)].name)\n%.2f", value))
        layer.textStyle = plot.labelTextStyle
        return layer
    }
    
    func sliceFill(for pieChart: CPTPieChart, record idx: UInt) -> CPTFill? {
        switch idx {
        case 0:   return CPTFill(color: CPTColor(componentRed:0.92, green:0.28, blue:0.25, alpha:1.00))
        case 1:   return CPTFill(color: CPTColor(componentRed:0.06, green:0.80, blue:0.48, alpha:1.00))
        case 2:   return CPTFill(color: CPTColor(componentRed:0.22, green:0.33, blue:0.49, alpha:1.00))
        default:  return nil
        }
    }
    
    func legendTitle(for pieChart: CPTPieChart, record idx: UInt) -> String? {
        return symbols[Int(idx)].name
    }
    
}
