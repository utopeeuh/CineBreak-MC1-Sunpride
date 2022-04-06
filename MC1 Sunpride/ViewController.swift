//
//  ViewController.swift
//  MC1 Sunpride
//
//  Created by Tb. Daffa Amadeo Zhafrana on 04/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var timerLabel: UITextView!
    @IBOutlet weak var startStopButton: UIButton!
    
    var sessionTime: CVarArg?
    var timerCounting:Bool = false
    var startTime:Date?
    var stopTime:Date?
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    
    var scheduledTimer: Timer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        AppNotification.requestAuthorization()
        
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        
        
        if timerCounting
        {
            startTimer()
        }
        else
        {
            stopTimer()
            if let start = startTime
            {
                if let stop = stopTime
                {
                    let time = calcRestartTime(start: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)
                    setTimeLabel(Int(diff))
                }
            }
        }
    }
    
    @IBAction func startStopAction(_ sender: Any) {
        if timerCounting
        {
            setStopTime(date: Date())
            stopTimer()
        }
        else
        {
            if let stop = stopTime
            {
                let restartTime = calcRestartTime(start: startTime!, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            }
            else
            {
                setStartTime(date: Date())
            }
            
            startTimer()
        }
    }
    
    func calcRestartTime(start: Date, stop: Date) -> Date
    {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    func startTimer()
    {
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(true)
        startStopButton.setTitle("Stop", for: .normal)
        AppNotification.sendNotification()
    }
    
    func stopTimer()
    {
        if scheduledTimer != nil
        {
            scheduledTimer.invalidate()
            sessionTime = Date().timeIntervalSince(startTime!)
            print(String(format: "%.0f seconds", sessionTime!))
        }
        
        setTimerCounting(false)
        setStopTime(date: nil)
        setStartTime(date: nil)
        
        startStopButton.setTitle("Start", for: .normal)
        
        timerLabel.text = makeTimeString(min: 30, sec: 0)
        AppNotification.resetBreakNotification()
    }
    
    @objc func refreshValue()
    {
        if let start = startTime
        {
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(Int(diff))
        }
        else
        {
            stopTimer()
            setTimeLabel(0)
        }
    }
    
    func setTimeLabel(_ val: Int)
    {
        let time = secondsToMinutesSeconds(val)
        let timeString = makeTimeString(min: time.0, sec: time.1)
        timerLabel.text = timeString
    }
    
    func secondsToMinutesSeconds(_ ms: Int) -> (Int, Int)
    {
        let min = 29 - ((ms % 3600) / 60)
        let sec = 59  - ((ms % 3600) % 60)
        
        if min == 0 && sec == 0{
            stopTimer()
        }
        
        return (min, sec)
    }
    
    func makeTimeString(min: Int, sec: Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    func setStartTime(date: Date?)
    {
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }
    
    func setStopTime(date: Date?)
    {
        stopTime = date
        userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ val: Bool)
    {
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
}

