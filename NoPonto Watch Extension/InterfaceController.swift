//
//  InterfaceController.swift
//  NoPonto Watch Extension
//
//  Created by Decio Montanhani on 18/03/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    var timerRunning = false
    var kg: Double = 0.1
    var increment: Double = 0.1
    var cookTemp: MeatTemperature = .rare

    @IBOutlet weak var timer: WKInterfaceTimer!
    @IBOutlet weak var textGroup: WKInterfaceGroup!
    @IBOutlet weak var imageGroup: WKInterfaceGroup!
    @IBOutlet weak var btTimer: WKInterfaceButton!
    @IBOutlet weak var lbWeight: WKInterfaceLabel!
    @IBOutlet weak var lbCook: WKInterfaceLabel!
    @IBOutlet weak var weightPicker: WKInterfacePicker!
    @IBOutlet weak var lbTemperature: WKInterfaceLabel!
    @IBOutlet weak var temperaturePicker: WKInterfacePicker!
    @IBOutlet weak var slider: WKInterfaceSlider!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        imageGroup.setHidden(true)
        updateConfiguration()
        setupPickers()
        // Configure interface objects here.
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func setupPickers() {
        // Picker de Quantidade
        var weightItems: [WKPickerItem] = []
        for number in stride(from: 0.1, through: 1.0, by: increment) {
            let item = WKPickerItem()
            item.title = "\(get2DecimalPlaces(for: number))"
            weightItems.append(item)
        }
        weightPicker.setItems(weightItems)
        weightPicker.setSelectedItemIndex(0)

        // Picker de temperatura
        var tempItems: [WKPickerItem] = []
        for index in 1...4 {
            let item = WKPickerItem()
            item.contentImage = WKImage(imageName: "temp-\(index)")
            tempItems.append(item)
        }
        temperaturePicker.setItems(tempItems)
        temperaturePicker.setSelectedItemIndex(0)
    }

    func updateConfiguration() {
        kg = get2DecimalPlaces(for: kg)
        lbWeight.setText("Total: \(kg) Kg")
        lbCook.setText(cookTemp.stringValue)
        temperaturePicker.setSelectedItemIndex(cookTemp.rawValue)
        lbTemperature.setText(cookTemp.stringValue)

    }

    func get2DecimalPlaces(for number: Double) -> Double {
        return Double(round(number*100)/100)
    }

    @IBAction func onTimerButton() {

        if timerRunning {
            timer.stop()
            btTimer.setTitle("iniciar Timer")
        } else {
            let time = cookTemp.cookTimeFor(kg)
            let date = Date(timeIntervalSinceNow: time)
            timer.setDate(date)
            timer.start()
            btTimer.setTitle("interromper Timer")
        }

        timerRunning.toggle()
    }
    @IBAction func onMinusButton() {
        if kg > 0.1 {
            kg -= increment
        }
        updateConfiguration()
    }
    @IBAction func onPlusButton() {
        if kg < 1.0 {
            kg += increment
        }
        updateConfiguration()
    }
    @IBAction func onTempChange(_ value: Float) {
        if let temp = MeatTemperature(rawValue: Int(value)) {
            cookTemp = temp
            updateConfiguration()
            
        }

    }

    @IBAction func onWeightChange(_ value: Int) {
        kg = Double(value+1)*increment
        updateConfiguration()
    }

    @IBAction func onTemperatureChange(_ value: Int) {
        guard let temp = MeatTemperature(rawValue: value) else {
            return
        }
        updateConfiguration()
        cookTemp = temp
        slider.setValue(Float(value))
    }

    @IBAction func onModeChange(_ value: Bool) {
        imageGroup.setHidden(!value)
        textGroup.setHidden(value)
        updateConfiguration()

        let weightPickerIndex = Int(round(kg/increment) - 1)
        weightPicker.setSelectedItemIndex(weightPickerIndex)
    }

}
