//
//  ViewController.swift
//  SmartMaskButton
//
//  Created by martin Brown on 10/16/20.
//  Copyright © 2020 martin Brown. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints

class ViewController: UIViewController {
    
    var gradientLayer: CAGradientLayer!
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
     
        gradientLayer.frame = self.view.bounds
     
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.white.cgColor]
     
        self.view.backgroundColor = gradientLayer
        
        gradientLayer.locations = [0.1, 0.05]
    }
    
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemRed
        return chartView
    }()
    lazy var lineChartView2: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemRed
        return chartView
    }()

    @IBOutlet weak var SmartMaskLbl: UILabel!
    @IBOutlet weak var PressureLbl: UILabel!
    @IBOutlet weak var HumidityLbl: UILabel!
    @IBOutlet weak var PressureVal: UILabel!
    @IBOutlet weak var HumidityVal: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createGradientLayer()
        view.addSubview(lineChartView)
        lineChartView.width(150)
        lineChartView.height(150)
        lineChartView.centerInSuperview(offset: CGPoint(x: -100, y: -200))
        
        view.addSubview(lineChartView2)
        lineChartView2.width(150)
        lineChartView2.height(150)
        lineChartView2.centerInSuperview(offset: CGPoint(x: 100, y: -200))
       
        
        
    }

    @IBAction func MaskFitting(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "MaskFit_vc") as? MaskFittingViewController else { return }
        present(vc, animated: true)
    }
    
    @IBAction func aboutBn(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "About_vc") as? AboutViewController else{ return }
        present(vc, animated: true)
        
    }
}

