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
    
    var sessions = getSessions()
    let userDefaults = UserDefaults.standard
    
    var sessionTimer: SessionTimer?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        AppNotification.requestAuthorization()
        sessionTimer = SessionTimer(timerLabel: timerLabel, startStopButton: startStopButton)
        
    }
    
    @IBAction func startStopAction(_ sender: Any) {
        sessionTimer!.startStopAction()
    }
}

