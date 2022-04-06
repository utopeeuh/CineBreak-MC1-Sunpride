//
//  ViewController.swift
//  UserPreference
//
//  Created by Wilbert Devin Wijaya on 05/04/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var numberField: UITextField!

    var pickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sleepTab()
        pickNumber()
    }
    
    @objc func dateChange(datePicker: UIDatePicker){
        
        dateTF.text = formatDate(Date: datePicker.date)
    }
    
    func formatDate(Date: Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm aa"
        return formatter.string(from: Date)
    }
    
    func sleepTab() {
        
        let saveTime = UserDefaults.standard.string(forKey: "sleepTime")
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode =  .time
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        
        dateTF.inputView = datePicker
        
        if saveTime != nil {
            dateTF.text = saveTime
        }
        else {
            dateTF.text = nil
        }
    }
    
    func pickNumber(){
        
        pickerView.delegate = self
        pickerView.dataSource = self
            
        numberField.inputView = pickerView
            
        let hourPick = UserDefaults.standard.string(forKey: "watchHour")
            
        if hourPick != nil {
            numberField.text = hourPick
        }
        else {
            numberField.text = nil
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        UserDefaults.standard.set(dateTF.text, forKey: "sleepTime")
        UserDefaults.standard.set(numberField.text, forKey: "watchHour")
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
     
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberField.text = "\(row)"
    }
    
}
