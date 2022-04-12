//
//  InitialSetupViewController.swift
//  MC1-Sunpride
//
//  Created by Nikita Felicia on 11/04/22.
//

import UIKit

class OnboardingSetupController: UIViewController {
    
    //@IBOutlet weak var setButton: UIButton!
    
    @IBOutlet weak var setButton1: UIButton!
    
    @IBOutlet weak var setButton2: UIButton!
    
    @IBOutlet weak var setButton3: UIButton!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button1aa: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button2aa: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button3aa: UIButton!
    
    @IBOutlet weak var durationField: UITextField!
    
    @IBOutlet weak var sleepField: UITextField!
    
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var softButton: UIButton!
    

    var pickerView = UIPickerView()
    var intensity: String?
    
    // MESSAGE INTENSITY
    @IBAction func showAction1(_ sender: Any) {
        animateIn(desiredView: blurView)
        animateIn(desiredView: popupView1)
        // set user default
    }
    
    @IBAction func setAction1(_ sender: Any) {
        animateOut(desiredView: popupView1)
        animateOut(desiredView: blurView)
    }
    
    // SLEEP TIME
    @IBAction func showAction2(_ sender: Any) {
        animateIn(desiredView: blurView)
        animateIn(desiredView: popupView2)
        
    }
    
    @IBAction func setAction2(_ sender: Any) {
        animateOut(desiredView: popupView2)
        animateOut(desiredView: blurView)
        UserDefaults.standard.set(sleepField.text, forKey: "sleepTime")
    }
    
    
    // WATCH TIME
    @IBAction func showAction3(_ sender: Any) {
        animateIn(desiredView: blurView)
        animateIn(desiredView: popupView3)
        
    }
    
    @IBAction func setAction3(_ sender: Any) {
        animateOut(desiredView: popupView3)
        animateOut(desiredView: blurView)
        UserDefaults.standard.set(durationField.text, forKey: "watchTime")
    }
   
    @IBAction func hardButtonPressed(_ sender: UIButton) {
        changeSelected(sender: sender, isSelected: true)
        changeSelected(sender: neutralButton, isSelected: false)
        changeSelected(sender: softButton, isSelected: false)
    }
    
    @IBAction func neutralButtonPressed(_ sender: UIButton) {
        changeSelected(sender: sender, isSelected: true)
        changeSelected(sender: hardButton, isSelected: false)
        changeSelected(sender: softButton, isSelected: false)
    }
    
    @IBAction func softButtonPressed(_ sender: UIButton) {
        changeSelected(sender: sender, isSelected: true)
        changeSelected(sender: hardButton, isSelected: false)
        changeSelected(sender: neutralButton, isSelected: false)
    }
    
    func changeSelected(sender: UIButton, isSelected : Bool){
        if(sender.isSelected ==  isSelected){
            return
        }
        
        sender.isSelected = isSelected
        
        sender.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0,  alpha: sender.isSelected ? 0.25  : 0).cgColor
        
        sender.layer.shadowOffset = CGSize(width: 0.0, height: 4.5)
        sender.layer.shadowOpacity = 1.0
        sender.layer.shadowRadius = 0.0
        sender.backgroundColor = sender.isSelected ? UIColor.systemIndigo : UIColor(named: "greyColor")
        
    }
    
    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet var popupView1: UIView!
    
    @IBOutlet var popupView2: UIView!
    
    @IBOutlet var popupView3: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurView.bounds = self.view.bounds
        
        popupView1.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.6)
        
        popupView2.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.3)
        sleepTab() //sleep
       
        popupView3.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.3)
        pickNumber() //watch
        
        popupView1.layer.cornerRadius = 15
        popupView2.layer.cornerRadius = 15
        popupView3.layer.cornerRadius = 15
        
        setButton1.layer.cornerRadius = 15
        setButton2.layer.cornerRadius = 15
        setButton3.layer.cornerRadius = 15
        
        hardButton.layer.cornerRadius = 10
        neutralButton.layer.cornerRadius = 10
        softButton.layer.cornerRadius = 10
        
        button1.layer.cornerRadius = 15
        button1.semanticContentAttribute = .forceRightToLeft
        button1aa.layer.cornerRadius = 15
        
        button2.layer.cornerRadius = 15
        button2.semanticContentAttribute = .forceRightToLeft
        button2aa.layer.cornerRadius = 15
        
        button3.layer.cornerRadius = 15
        button3.semanticContentAttribute = .forceRightToLeft
        button3aa.layer.cornerRadius = 15
    }
    
    func animateIn(desiredView: UIView){
        let backgroundView = self.view
        
        backgroundView?.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView!.center
        
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
    }

    func animateOut(desiredView: UIView){
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: {_ in
            desiredView.removeFromSuperview()
        })
    }
    
    @objc func dateChange(datePicker: UIDatePicker){
        
        sleepField.text = formatDate(Date: datePicker.date)
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
        
        sleepField.inputView = datePicker
        
        if saveTime != nil {
            sleepField.text = saveTime
        }
        else {
            sleepField.text = nil
        }
    }
    
    func pickNumber(){
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
            
        durationField.inputView = pickerView
            
        let hourPick = UserDefaults.standard.string(forKey: "watchTime")
            
        if hourPick != nil {
            durationField.text = hourPick
        }
        else {
            durationField.text = nil
        }
    }
}

extension OnboardingSetupController: UIPickerViewDelegate, UIPickerViewDataSource {
     
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 10 : 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? String(row+1) : "hours"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        durationField.text = "\(row+1)"
    }
    
}
