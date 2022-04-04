//
//  ViewController.swift
//  MC1 Sunpride
//
//  Created by Tb. Daffa Amadeo Zhafrana on 04/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    var timer: Timer?
    var startTime: Double?
    @IBOutlet weak var sessionTimeText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    
    @IBAction func startTimer(_ sender: Any) {
        startTime = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:  #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func fireTimer() {
        print("Timer fired!")
    }
    
    @IBAction func stopTimer(_ sender: Any) {
        print("Timer stopped")
        timer?.invalidate()
        
        let sessionTime = Date().timeIntervalSinceReferenceDate - (startTime ?? 0)

        let timeString = String(format: "%.2f", sessionTime)
        sessionTimeText.text = "Total Time: " + timeString
    }
}

