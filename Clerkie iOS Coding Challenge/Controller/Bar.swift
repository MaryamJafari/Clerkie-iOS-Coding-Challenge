//
//  Bar.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/18/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit
import CorePlot

class Bar: UIViewController {


    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet var hostView: CPTGraphHostingView!
    
    var base: Currency!
    var rates: [Rate]!
    var symbols: [Currency]!
    
    var plot1: CPTBarPlot!
    var plot2: CPTBarPlot!
    var plot3: CPTBarPlot!
    
    let BarWidth = 0.25
    let BarInitialX = 0.25
    
    var priceAnnotation: CPTPlotSpaceAnnotation?
    
    override func viewDidLoad() {
    super.viewDidLoad()
    updateLabels()
        rates = [Rate(date: "2018-08-01", base: "kj", rates: ["USD": 4.1, "USD2" : 3.2, "EUR" : 7.3, "GBP": 6.4 , "CHF" : 2.0, "CAD" : 3.6]) ,Rate(date: "2018-08-02", base: "kj", rates: ["USD": 2.1, "USD2" : 1.2, "EUR" : 0.3, "GBP": 4.4 , "CHF" : 1.0, "CAD" : 5.6]) ,Rate(date: "2018-08-03", base: "kj", rates: ["USD": 0.1, "USD2" : 7.2, "EUR" : 2.3, "GBP": 3.4 , "CHF" : 4.0, "CAD" : 3.6]),
       ]
    }
    
    func updateLabels() {
    label1.text = base.name
    label2.text = symbols[0].name
    label3.text = symbols[1].name
    }
    
    func highestRateValue() -> Double {
    var maxRate = DBL_MIN
    for rate in rates {
    maxRate = max(maxRate, rate.maxRate().doubleValue)
    }
    return maxRate
    }
    
    override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    initPlot()
    }
    
    func initPlot() {
    configureHostView()
    configureGraph()
    configureChart()
    configureAxes()
    }
    
    func configureHostView() {
    hostView.allowPinchScaling = false
    }
    
    func configureGraph() {
    // 1 - Create the graph
    let graph = CPTXYGraph(frame: hostView.bounds)
    graph.plotAreaFrame?.masksToBorder = false
    hostView.hostedGraph = graph
    
    // 2 - Configure the graph
    graph.apply(CPTTheme(named: CPTThemeName.plainWhiteTheme))
    graph.fill = CPTFill(color: CPTColor.clear())
    graph.paddingBottom = 30.0
    graph.paddingLeft = 30.0
    graph.paddingTop = 0.0
    graph.paddingRight = 0.0
    
    // 3 - Set up styles
    let titleStyle = CPTMutableTextStyle()
    titleStyle.color = CPTColor.black()
    titleStyle.fontName = "Avenir Next"
    titleStyle.fontSize = 16.0
    titleStyle.textAlignment = .center
    graph.titleTextStyle = titleStyle
    
        let title = "\(base.name) exchange rates\n\(rates.first!.date) - \(rates.last!.date)"
    graph.title = title
    graph.titlePlotAreaFrameAnchor = .top
    graph.titleDisplacement = CGPoint(x: 0.0, y: -16.0)
    
    // 4 - Set up plot space
    let xMin = 0.0
    let xMax = Double(rates.count)
    let yMin = 0.0
    let yMax = 1.4 * highestRateValue()
    guard let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace else { return }
    plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMax - xMin))
    plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMin), lengthDecimal: CPTDecimalFromDouble(yMax - yMin))
    }
    
    
    func configureChart() {
    // 1 - Set up the three plots
    plot1 = CPTBarPlot()
    plot1.fill = CPTFill(color: CPTColor(componentRed:0.92, green:0.28, blue:0.25, alpha:1.00))
    plot2 = CPTBarPlot()
    plot2.fill = CPTFill(color: CPTColor(componentRed:0.06, green:0.80, blue:0.48, alpha:1.00))
    plot3 = CPTBarPlot()
    plot3.fill = CPTFill(color: CPTColor(componentRed:0.22, green:0.33, blue:0.49, alpha:1.00))
    
    // 2 - Set up line style
    let barLineStyle = CPTMutableLineStyle()
    barLineStyle.lineColor = CPTColor.lightGray()
    barLineStyle.lineWidth = 0.5
    
    // 3 - Add plots to graph
    guard let graph = hostView.hostedGraph else { return }
    var barX = BarInitialX
    let plots = [plot1!, plot2!, plot3!]
    for plot: CPTBarPlot in plots {
    plot.dataSource = self
    plot.delegate = self
    plot.barWidth = NSNumber(value: BarWidth)
    plot.barOffset = NSNumber(value: barX)
    plot.lineStyle = barLineStyle
    graph.add(plot, to: graph.defaultPlotSpace)
    barX += BarWidth
    }
    }
    
    func configureAxes() {
    // 1 - Configure styles
    let axisLineStyle = CPTMutableLineStyle()
    axisLineStyle.lineWidth = 2.0
    axisLineStyle.lineColor = CPTColor.black()
    // 2 - Get the graph's axis set
    guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet else { return }
    // 3 - Configure the x-axis
    if let xAxis = axisSet.xAxis {
    xAxis.labelingPolicy = .none
    xAxis.majorIntervalLength = 1
    xAxis.axisLineStyle = axisLineStyle
    var majorTickLocations = Set<NSNumber>()
    var axisLabels = Set<CPTAxisLabel>()
    for (idx, rate) in rates.enumerated() {
    majorTickLocations.insert(NSNumber(value: idx))
    let label = CPTAxisLabel(text: "\(rate.date)", textStyle: CPTTextStyle())
    label.tickLocation = NSNumber(value: idx)
    label.offset = 5.0
    label.alignment = .left
    axisLabels.insert(label)
    }
    xAxis.majorTickLocations = majorTickLocations
    xAxis.axisLabels = axisLabels
    }
    // 4 - Configure the y-axis
    if let yAxis = axisSet.yAxis {
    yAxis.labelingPolicy = .fixedInterval
    yAxis.labelOffset = -10.0
    yAxis.minorTicksPerInterval = 3
    yAxis.majorTickLength = 30
    let majorTickLineStyle = CPTMutableLineStyle()
    majorTickLineStyle.lineColor = CPTColor.black().withAlphaComponent(0.1)
    yAxis.majorTickLineStyle = majorTickLineStyle
    yAxis.minorTickLength = 20
    let minorTickLineStyle = CPTMutableLineStyle()
    minorTickLineStyle.lineColor = CPTColor.black().withAlphaComponent(0.05)
    yAxis.minorTickLineStyle = minorTickLineStyle
    yAxis.axisLineStyle = axisLineStyle
    }
    }
    }
    
    // MARK: Actions
    
    extension Bar {
        @IBAction func switch1Changed(_ sender: UISwitch) {
            let on = sender.isOn
            if !on {
                hideAnnotation(graph: plot1.graph!)
            }
            plot1.isHidden = !on
        }
        @IBAction func switch2Changed(_ sender: UISwitch) {
            let on = sender.isOn
            if !on {
                hideAnnotation(graph: plot2.graph!)
            }
            plot2.isHidden = !on
        }
        @IBAction func switch3Changed(_ sender: UISwitch) {
            let on = sender.isOn
            if !on {
                hideAnnotation(graph: plot3.graph!)
            }
            plot3.isHidden = !on
        }
        
        func hideAnnotation(graph: CPTGraph) {
            guard let plotArea = graph.plotAreaFrame?.plotArea,
                let priceAnnotation = priceAnnotation else {
                    return
            }
            plotArea.removeAnnotation(priceAnnotation)
            self.priceAnnotation = nil
        }
        
    }
    
    extension Bar: CPTBarPlotDataSource, CPTBarPlotDelegate {
        
        func numberOfRecords(for plot: CPTPlot) -> UInt {
            return UInt(rates.count)
        }
        
        func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
            if fieldEnum == UInt(CPTBarPlotField.barTip.rawValue) {
                if plot == plot1 {
                    return 1.0 as AnyObject?
                }
                if plot == plot2 {
//return 2.0 as AnyObject?
                    return rates[Int(idx)].rates[symbols[0].name]!
                }
                if plot == plot3 {
                    
                   return rates[Int(idx)].rates[symbols[1].name]!
                    //return 3.0 as AnyObject?
                }
            }
            return idx
        }
        
        
        func barPlot(_ plot: CPTBarPlot, barWasSelectedAtRecord idx: UInt, with event: UIEvent) {
            // 1 - Is the plot hidden?
            if plot.isHidden == true {
                return
            }
            // 2 - Create style, if necessary
            let style = CPTMutableTextStyle()
            style.fontSize = 12.0
            style.fontName = "HelveticaNeue-Bold"
            
            // 3 - Create annotation
            guard let price = number(for: plot,
                                     field: UInt(CPTBarPlotField.barTip.rawValue),
                                     record: idx) as? CGFloat else { return }
            
            priceAnnotation?.annotationHostLayer?.removeAnnotation(priceAnnotation)
            priceAnnotation = CPTPlotSpaceAnnotation(plotSpace: plot.plotSpace!, anchorPlotPoint: [0,0])
            
            // 4 - Create number formatter
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            // 5 - Create text layer for annotation
            let priceValue = formatter.string(from: NSNumber(cgFloat: price))
            let textLayer = CPTTextLayer(text: priceValue, style: style)
            
            priceAnnotation!.contentLayer = textLayer
            // 6 - Get plot index
            var plotIndex: Int = 0
            if plot == plot1 {
                plotIndex = 0
            }
            else if plot == plot2 {
                plotIndex = 1
            }
            else if plot == plot3 {
                plotIndex = 2
            }
            // 7 - Get the anchor point for annotation
            let x = CGFloat(idx) + CGFloat(BarInitialX) + (CGFloat(plotIndex) * CGFloat(BarWidth))
            let y = CGFloat(price) + 0.05
            priceAnnotation!.anchorPlotPoint = [NSNumber(cgFloat: x), NSNumber(cgFloat: y)]
            // 8 - Add the annotation
            guard let plotArea = plot.graph?.plotAreaFrame?.plotArea else { return }
            plotArea.addAnnotation(priceAnnotation)
        }
}


