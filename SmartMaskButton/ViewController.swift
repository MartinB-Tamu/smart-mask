//
//  ViewController.swift
//  SmartMaskButton
//
//  Created by martin Brown on 10/16/20.
//  Copyright © 2020 martin Brown. All rights reserved.
//

import UIKit
import CoreBluetooth

// core bluetooth service ID
//let BLE_CBUUID = CBUUID(string: "0483DADD-6C9D-6CA9-5D41-03AD4FFF4ABB")
let BLE_Service_CBUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
// core bluetooth characteristic IDs
let BLE_Characteristic_CBUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
let BLE_Characteristic2_CBUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")

/*protocol DataDelegate{
    func passData(type: Int)
}*/

extension CAGradientLayer {

    //creating top maroon border
    func backgroundGradientColor() -> CAGradientLayer {
        let topColor = UIColor(red: (81/255.0), green: (0/255.0), blue:(0/255.0), alpha: 1)
        let bottomColor = UIColor.white

        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [NSNumber] = [0.12, 0.01]

        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations

        return gradientLayer

    }
}

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    //attempting to pass info between view controllers
    //var text:String = "Hello"
    var completionHandler: ((String?) -> Void)?
    
    // creating an instance of central manager and peripheral
        var centralManager: CBCentralManager?
        var peripheralMask: CBPeripheral?
    
    
    
    @IBOutlet weak var SmartMaskLbl: UILabel!
    @IBOutlet weak var PressureLbl: UILabel!
    @IBOutlet weak var TemperatureLbl: UILabel!
    @IBOutlet weak var HumidityLbl: UILabel!
    @IBOutlet weak var PressureVal: UILabel!
    @IBOutlet weak var PressValS2: UILabel!
    @IBOutlet weak var MaskFit: UILabel!
    
    
    @IBOutlet weak var TemperatureVal: UILabel!
    @IBOutlet weak var TempValS2: UILabel!
    @IBOutlet weak var HumidityVal: UILabel!
    @IBOutlet weak var HumValS2: UILabel!
    @IBOutlet weak var BLE_Label: UILabel!
    @IBOutlet weak var BLEStatus: UIView!
    
    @IBOutlet weak var UselessLineTop: UIView!
    @IBOutlet weak var UselessLineBot: UIView!
    @IBOutlet weak var S1Lbl: UILabel!
    @IBOutlet weak var S2Lbl: UILabel!
    
    // arrays for storing data from microcontroller
    var pressureArray = [Int]()
    var tempArray = [Int]()
    var humidArray = [Int]()
    var calibrateArray = [Int]()
    var calibrateArrayP = [Int]()
    var baselineArrayP = [Int]()
    
    //dumb variable for counting
    var count = 0
    
    //for check fit
    var test = true
    
    //  array for csv file
    var csvArray: [Dictionary<String, AnyObject>] = Array()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let background = CAGradientLayer().backgroundGradientColor()
                background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        BLEStatus.backgroundColor = UIColor.red
        
        UselessLineTop.backgroundColor = UIColor.black
        UselessLineBot.backgroundColor = UIColor.black
            
        
        
        //creates the central
            centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        //second attempt at csv
        let sFileName = "SmartTest.csv"
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(sFileName)
        
        let output = OutputStream.toMemory()
        
        let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        
        //header for csv file
        csvWriter?.writeField("Pressure S1")
        csvWriter?.writeField("Temperature S1")
        csvWriter?.writeField("Humidity S1")
        csvWriter?.writeField("Pressure S2")
        csvWriter?.writeField("Temperature S2")
        csvWriter?.writeField("Humidity S2")
        
        csvWriter?.finishLine()
        // array to add data
        var arrcsvdata = [[String]]()
        
        arrcsvdata.append(["325","433","789","122","486","792"])
        arrcsvdata.append(["542","576","435","124","436","723"])
        arrcsvdata.append(["875","682","543","319","126","566"])
        arrcsvdata.append(["562","612","784","315","886","612"])
        arrcsvdata.append(["156","717","235","310","445","644"])
        arrcsvdata.append(["722","742","355","235","444","875"])
        arrcsvdata.append(["129","762","435","213","222","658"])
        arrcsvdata.append(["184","832","355","198","348","563"])
        arrcsvdata.append(["192","852","555","178","847","789"])
        arrcsvdata.append(["192","882","323","144","236","789"])
        for(elements) in arrcsvdata.enumerated(){
            csvWriter?.writeField(elements.element[0])// Pressure
            csvWriter?.writeField(elements.element[1])// Temp
            csvWriter?.writeField(elements.element[2])// Humid
            csvWriter?.writeField(elements.element[3])// Pressure2
            csvWriter?.writeField(elements.element[4])// Temp2
            csvWriter?.writeField(elements.element[5])// Humid2
            csvWriter?.finishLine()
        }
        csvWriter?.closeStream()
        
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey)as? Data)!
        
        do{
            try buffer.write(to: documentURL)
        }
        catch{
            
        }
        
        
        
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        
        case .unknown:
            print("Bluetooth UNKNOWN")
            
        case .resetting:
            print("Bluetooth RESETTING")
            
        case .unsupported:
            print("Bluetooth UNSUPPORTED")
           
        case .unauthorized:
            print("Bluetooth UNAUTHORIZED")
            
        case .poweredOff:
            print("Bluetooth POWERED OFF")
            
        case .poweredOn:
            print("Bluetooth POWERED ON")
            
            DispatchQueue.main.async { () -> Void in
    
            }
            // scan for peripherals that we're interested in (need the service ids)
            centralManager?.scanForPeripherals(withServices: [BLE_Service_CBUUID])
            
        }
            
        }
        // to find what divices are available to connect to
        func centralManager(_ central: CBCentralManager, didDiscover peripheral:  CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
            
            print(peripheral.name!)
            decodePeripheralState(peripheralState: peripheral.state)
            
            //this stores a reference to the peripheral
            peripheralMask = peripheral
            
            // set delagate property to veiw controller
            peripheralMask?.delegate = self
            
            //stop scanning
            centralManager?.stopScan()
            
            centralManager?.connect(peripheralMask!)
            
        }
        //runs when connection is successful with the peripheral
        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        DispatchQueue.main.async { () -> Void in
            
            self.BLEStatus.backgroundColor = UIColor.green
           // self.BLE_Label.textColor = UIColor.green
            
        }
         // looking for services
            peripheralMask?.discoverServices([BLE_Service_CBUUID])
            
        }
        // peripheral disconnect funtion
        func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        
        DispatchQueue.main.async { () -> Void in
            
            self.BLEStatus.backgroundColor = UIColor.red
            //self.BLE_Label.textColor = UIColor.red
        
            
        }
            // start scanning for another peripheral (may not need)
            centralManager?.scanForPeripherals(withServices: [BLE_Service_CBUUID])
        }
        // looking for services
        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            
            for service in peripheral.services! {
                
                if service.uuid == BLE_Service_CBUUID {
                    
                    print("Service: \(service)")
                    
                    //looking for characteristics
                    peripheral.discoverCharacteristics(nil, for: service)
                    
                }
                
            }
            
        }
        // funtion to discover characteristics of interest in the services
        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
               
               for characteristic in service.characteristics! {
                   print(characteristic)
                   
                   if characteristic.uuid == BLE_Characteristic_CBUUID {
                       
                       peripheral.readValue(for: characteristic)
                       
                   }
        
                   if characteristic.uuid == BLE_Characteristic2_CBUUID {
        
                       peripheral.setNotifyValue(true, for: characteristic)
                       
                   }
                   
               }
               
           }
        // funciton where the charateristics are stored and manipulated or displayed
        func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
                
                if characteristic.uuid == BLE_Characteristic2_CBUUID {
                    
                   
                    // data into human readable format
                    let pressure = derivepressure(using: characteristic)
                    pressureArray.append(Int(pressure))
                    
                    let temperature: Double = derivetemperature(using: characteristic)
                    tempArray.append(Int(temperature))
                    
                    let humidity = derivehumidity(using: characteristic)
                    humidArray.append(humidity)
                    
                    //and now for sensor 2
                    let pressure2 = derivepressure2(using: characteristic)
                    pressureArray.append(Int(pressure))
                    
                    let temperature2 = derivetemperature2(using: characteristic)
                     tempArray.append(Int(temperature2))
                    
                    let humidity2 = derivehumidity2(using: characteristic)
                    humidArray.append(humidity)
                
                    if tempArray.count == 10 {
                        for n in 0...9{
                        //print(pressureArray[n])
                        }
                    }
                   // print("pressure value ")
                   // print(pressure)
                    
                    
                    DispatchQueue.main.async { () -> Void in
                        
                        UIView.animate(withDuration: 1.0, animations: {
                            self.PressureVal.alpha = 1.0
                            self.PressureVal.text = String(pressure)
                            self.TemperatureVal.alpha = 1.0
                            self.TemperatureVal.text = String(temperature)
                            self.HumidityVal.alpha = 1.0
                            self.HumidityVal.text = String(humidity)
                            
                            //now for sensor 2
                            self.PressValS2.alpha = 1.0
                            self.PressValS2.text = String(pressure2)
                            self.TempValS2.alpha = 1.0
                            self.TempValS2.text = String(temperature2)
                            self.HumValS2.alpha = 1.0
                            self.HumValS2.text = String(humidity2)
                        }, completion: { (true) in
                            /*self.PressureVal.alpha = 0.0
                            self.TemperatureVal.alpha = 0.0
                            self.HumidityVal.alpha = 0.0*/
                        })
                        
                    }
         
                }
                
                
            }
        func derivepressure(using pressureCharacteristic: CBCharacteristic) -> Double {
            let pressureval = pressureCharacteristic.value!
            let buffer = [UInt8](pressureval)
            if buffer.count < 5{
               // print(buffer[0])
                //print(buffer[1])
               // print(buffer[2])
               // print(buffer[3])
              //  return((Int(buffer[0])*16)+((Int(buffer[1]))))
                return 76
            } else{
                //return Int((buffer[0]<<12)+(buffer[1]<<4)+(buffer[2]))
                let P = ((Int(buffer[0]))*4096)+((Int(buffer[1]))*16)+(Int(buffer[2]))
                let Pfinal = ((Double(P)/100.0)-94.0) * 29.97
                
                return Pfinal
                //return(((Int(buffer[0]))*4096)+((Int(buffer[1]))*16)+(Int(buffer[2])))
            }
        }
        func derivetemperature(using temperatureCharateristic: CBCharacteristic) -> Double {
            let tempval = temperatureCharateristic.value!
            let buffer = [UInt8](tempval) //This needs to be signed but how?
            count = count + 1
            if count == 2{
              // print ((Int8(buffer[1])<<8)+(Int8(buffer[0])))
              // print((buffer[1]<<8)+(buffer[0]))
               
               //print(buffer[5])
              //  print(buffer[4])
               print((Int(buffer[0])*256)+((Int(buffer[1]))))
               print((Int(buffer[2])*256)+((Int(buffer[3]))))
               print((Int(buffer[4])*256)+((Int(buffer[5]))))
                
            }
           
            if buffer.count < 5{
               // return((Int(buffer[2])*16)+((Int(buffer[3]))))
                return (77)
            } else{
                let abcVal = ((Int(buffer[3]))*4096)+((Int(buffer[4]))*16)+(Int(buffer[5]))
                //failed compensation formula
               /* let T1 = 9069
                let T2 = 1136
                //print(abcVal)
                let T3 = 1280
                let var1 = Double(abcVal)*0.125 - ((Double(T1)*2)*((Double(T2))*0.000485))
                let var2 = Double(abcVal)*0.0625 - (Double(T1)*(Double(abcVal)*0.0625)) - (Double(T1)*0.0002425)*(Double(T3)*0.0060625)
                let t_fine = var1 + var2
                let T = (t_fine*5 + 128)*0.003905*/
                
                var T = (Double(abcVal)/1000.0)-492.67
                if T < 20{
                    T = T + ((21.0 - T )*0.69)
                }
                else if T > 22 {
                    T = T - ((T - 21.0)*0.69)
                }
                let RndVal = (round(T * 10) / 10.0) + 8.0
                    
           // return(((Int(buffer[3]))*4096)+((Int(buffer[4]))*16)+(Int(buffer[5])))
                return RndVal
            }
        }
        func derivehumidity(using humidityCharacteristic: CBCharacteristic) -> Int {
            let humval = humidityCharacteristic.value!
            let buffer = [UInt8](humval)
            if buffer.count < 5{
                return((Int(buffer[0])*16)+((Int(buffer[1]))))
            } else{
            return(((Int(buffer[6]))*256)+(Int(buffer[7])))
            }
        }
    
        // now for sensor 2
        func derivepressure2(using pressureCharacteristic: CBCharacteristic) -> Double {
            let pressureval = pressureCharacteristic.value!
            let buffer = [UInt8](pressureval)
            if buffer.count < 5{
             
                return 76
            } else if buffer.count > 9{
                //return Int((buffer[0]<<12)+(buffer[1]<<4)+(buffer[2]))
                let P = ((Int(buffer[8]))*4096)+((Int(buffer[9]))*16)+(Int(buffer[10]))
                let Pfinal = (((Double(P)/100.0)-94.0) * 29.97)-1600.0
                
                return Pfinal
                //return(((Int(buffer[0]))*4096)+((Int(buffer[1]))*16)+(Int(buffer[2])))
            }
            else{
                return (77)
            }
        }
        func derivetemperature2(using temperatureCharateristic: CBCharacteristic) -> Double {
            let tempval = temperatureCharateristic.value!
            let buffer = [UInt8](tempval) //This needs to be signed but how?
           
            if buffer.count < 5{
               // return((Int(buffer[2])*16)+((Int(buffer[3]))))
                return (77)
            } else if buffer.count > 9{
                let abcVal = ((Int(buffer[11]))*4096)+((Int(buffer[12]))*16)+(Int(buffer[13]))
            
                
                var T = (Double(abcVal)/1000.0)-492.67
                if T < 20{
                    T = T + ((21.0 - T )*0.69)
                }
                else if T > 22 {
                    T = T - ((T - 21.0)*0.69)
                }
                let RndVal = (round(T * 10) / 10.0) - 4.7
                    
           // return(((Int(buffer[3]))*4096)+((Int(buffer[4]))*16)+(Int(buffer[5])))
                return RndVal
            }
            else{
                return (77)
            }
        }
        func derivehumidity2(using humidityCharacteristic: CBCharacteristic) -> Int {
            let humval = humidityCharacteristic.value!
            let buffer = [UInt8](humval)
            if buffer.count < 5{
                return((Int(buffer[0])*16)+((Int(buffer[1]))))
            } else if buffer.count > 8{
                return(((Int(buffer[14]))*256)+(Int(buffer[15])))
            }
            else {
                return (77)
            }
        }
    func checkFitT(){
        if tempArray.count > 20 {
            for i in 20..<40{
                calibrateArray.append(tempArray[i])
            }
            var t = 0.0
            var c = 0.0
            for i in 0..<19 {
                t = Double(tempArray[tempArray.count-i-1]) + t
                c = Double(calibrateArray[i]) + c
            }
            c = c/20.0
            t = t/20.0
           // print(c)
          //  print("space")
          //  print(t)
            if pressureArray.count > 20 {
                for i in 20..<40{
                    calibrateArrayP.append(pressureArray[i])
                }
                var p = 0.0
                var cp = 0.0
                for i in 0..<19 {
                    p = Double(pressureArray[pressureArray.count-i-1]) + p
                    cp = Double(calibrateArrayP[i]) + cp
                }
                cp = cp/20.0
                p = p/20.0
               if t < 0.997*c || p < 0.995*cp{
                DispatchQueue.main.async { () -> Void in
                    
                    self.MaskFit.text = "Mask Breached"
                    self.MaskFit.textColor = UIColor.red
                    
                }
            } else {
                DispatchQueue.main.async { () -> Void in
                    
                    self.MaskFit.text = "Acceptable Fit"
                    self.MaskFit.textColor = UIColor.green
               
                }
                test = false
            }
        }
      }
    }
    func checkFitP(){
        if pressureArray.count > 400 {
            var big1 = 0
            var big2 = 0
            var big3 = 0
            var big4 = 0
            var small1 = 0
            var small2 = 0
            var small3 = 0
            var small4 = 0
            
            let min = pressureArray.count-250
            let max = pressureArray.count-1
            for i in min..<max{
                calibrateArrayP.append(pressureArray[i])
               // print(pressureArray[i])
            }
            for i in 20..<420{
                baselineArrayP.append(pressureArray[i])
            }
            calibrateArray.sort()
            big1 = calibrateArrayP[calibrateArrayP.count-1]
            big2 = calibrateArrayP[calibrateArrayP.count-2]
            big3 = calibrateArrayP[calibrateArrayP.count-3]
            big4 = calibrateArrayP[calibrateArrayP.count-4]
          
            small1 = calibrateArrayP[0]
            small2 = calibrateArrayP[1]
            small3 = calibrateArrayP[2]
            small4 = calibrateArrayP[3]
         
            let avgBig = (big1+big2+big3+big4)/4
            let avgSmall = (small1+small2+small3+small4)/4
            
            let CalMag = abs(avgBig - avgSmall)
            
            baselineArrayP.sort()
            var baseBig = 0
            var baseSmall = 0
            var count = 0
            var countS = 0
            
            for i in 0..<12{
                baseBig = baseBig + baselineArrayP[i]
                count = count+1
            }
            let minB = baselineArrayP.count-13
            let maxB = baselineArrayP.count-1
            for i in minB..<maxB{
                baseSmall = baseSmall + baselineArrayP[i]
                countS = countS+1
            }
            print("count")
            print(count)
            print(countS)
            
            let BaseAvgBig = baseBig/12
            let BaseAvgSmall = baseSmall/12
            
            let BaseMag = abs(BaseAvgBig - BaseAvgSmall)
            print("Baseline Mag")
            print(BaseMag)
            print("current Mag")
            print(CalMag)
            
            if CalMag < Int(0.5*Double(BaseMag)){
                DispatchQueue.main.async { () -> Void in
                    
                    self.MaskFit.text = "Mask Breached"
                    self.MaskFit.textColor = UIColor.red
                    
                }
            }else {
                DispatchQueue.main.async { () -> Void in
                    
                    self.MaskFit.text = "Acceptable Fit"
                    self.MaskFit.textColor = UIColor.green
               
                }
            
            }
            
        
            
        }
    }
    // functions for output csv file
   /* func createCSV(from recArray: [Dictionary<String, AnyObject>]) {
        var csvString = "\("Sensor 1 Data"), \("Sensor 2 data") \n\n"
        for dct in recArray {
            csvString = csvString.appending("\(String(describing: dct ["Data"])), \(String(describing: dct ["Data 1"]))\n")
        }
    
    let fileManager = FileManager.default
            do {
                let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                let fileURL = path.appendingPathComponent("CSVRec.csv")
                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("error creating file")
            }
    }*/
        func decodePeripheralState(peripheralState: CBPeripheralState) {
            
            switch peripheralState {
                case .disconnected:
                    print("Peripheral state: disconnected")
                case .connected:
                    print("Peripheral state: connected")
                case .connecting:
                    print("Peripheral state: connecting")
                case .disconnecting:
                    print("Peripheral state: disconnecting")
            }
        
    }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MaskDataViewController {
            let destinationController = segue.destination as! MaskDataViewController
            destinationController.labelText = "did it work?"
            destinationController.pressVect = pressureArray
            destinationController.tempVect = tempArray
            destinationController.humVect = humidArray
        }
    }

    @IBAction func CalibrateMaskBN(_ sender: Any) {
    
        guard let vc = storyboard?.instantiateViewController(identifier: "Calibrate_vc") as? CalibrateViewController else {
            return }
      present(vc, animated:true)
        
        //checkFitT()
        checkFitP()
        
    }
    
    @IBAction func RealCalibrate(_ sender: Any) {
            
                   
    }
    
    
    @IBAction func MaskDataBN(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "MaskDataVC") as? MaskDataViewController else { return }
        performSegue(withIdentifier: "DisplayMaskDataView", sender: nil)
   
       // vc.modalPresentationStyle = .fullScreen
        present(vc, animated:true)
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

