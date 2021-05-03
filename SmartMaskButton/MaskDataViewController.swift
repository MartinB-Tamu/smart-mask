//
//  MaskDataViewController.swift
//  SmartMaskButton
//
//  Created by martin Brown on 11/17/20.
//  Copyright © 2020 martin Brown. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints



class MaskDataViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var DataPass: UILabel!
    
   
    
    var labelText = String()
    lazy var pressVect = [Int]()
    lazy var tempVect = [Int]()
    lazy var humVect = [Int]()
    

    
   
    
    //creating chart for Pressure data
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .gray
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(8, force: false)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.labelTextColor = .black
        chartView.xAxis.axisLineColor = .black
        chartView.xAxis.setLabelCount(9, force: false)
        
       // chartView.animate(xAxisDuration: 1.0)
        
        return chartView
        
        
    }()
    //creating chart for temperature data
    lazy var lineChartView2: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .gray
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(8, force: false)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.labelTextColor = .black
        chartView.xAxis.axisLineColor = .black
        chartView.xAxis.setLabelCount(9, force: false)
        
        //chartView.animate(xAxisDuration: 1.0)
        return chartView
    }()
    // creating chart for humidity data
    lazy var lineChartView3: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .gray
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(8, force: false)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.labelTextColor = .black
        chartView.xAxis.axisLineColor = .black
        chartView.xAxis.setLabelCount(9, force: false)
        
        //chartView.animate(xAxisDuration: 1.0)
        return chartView
    }()

    override func viewWillAppear(_ animated:Bool) {
      //  DataPass.text = labelText
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pass data
      //  DataPass.text = labelText
        
  
        // Pressure graph
        view.addSubview(lineChartView)
        lineChartView.width(250)
        lineChartView.height(150)
        lineChartView.centerInSuperview(offset: CGPoint(x: 0, y: -200))
        setData()
        // Temperature graph
        view.addSubview(lineChartView2)
        lineChartView2.width(250)
        lineChartView2.height(150)
        lineChartView2.centerInSuperview(offset: CGPoint(x: 0, y: 0))
        setData2()
        // Humidity graph
        view.addSubview(lineChartView3)
        lineChartView3.width(250)
        lineChartView3.height(150)
        lineChartView3.centerInSuperview(offset: CGPoint(x: 0, y: 200))
        setData3()
        
        
    }
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    func setData() {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<199 {
            let yValues = ChartDataEntry(x: Double(i), y: Double(pressVect[pressVect.count-(200-i)]))
            lineChartEntry.append(yValues)
        }
        
        let set1 = LineChartDataSet(entries: lineChartEntry, label: "Pressure")
        
    
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2
        set1.setColor(.black)
       // set1.fill = Fill(color: .black)
       // set1.fillAlpha = 0.8
        
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
    }
    
    func setData2() {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<99 {
            let yValues2 = ChartDataEntry(x: Double(i), y: Double(tempVect[tempVect.count-(100-i)]))
            lineChartEntry.append(yValues2)
        }
        
        let set1 = LineChartDataSet(entries: lineChartEntry, label: "Temperature")
        
    
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2
        set1.setColor(.black)
       // set1.fill = Fill(color: .black)
       // set1.fillAlpha = 0.8
        
        let data = LineChartData(dataSet: set1)
        lineChartView2.data = data
    }
    
    func setData3() {
        let set1 = LineChartDataSet(entries: yValues3, label: "Humidity")
        
    
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2
        set1.setColor(.black)
       // set1.fill = Fill(color: .black)
       // set1.fillAlpha = 0.8
        
        
        let data = LineChartData(dataSet: set1)
        lineChartView3.data = data
    }
    //dummy data for humidity
    let yValues3: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 91.0),
        ChartDataEntry(x: 1.0, y: 91.2),
        ChartDataEntry(x: 2.0, y: 88.3),
        ChartDataEntry(x: 3.0, y: 90.1),
        ChartDataEntry(x: 4.0, y: 85.2),
        ChartDataEntry(x: 5.0, y: 89.4),
        ChartDataEntry(x: 6.0, y: 92.9),
        ChartDataEntry(x: 7.0, y: 93.0),
        ChartDataEntry(x: 8.0, y: 91.7),
        ChartDataEntry(x: 9.0, y: 89.8),]
    
    

}
