//
//  ViewController.swift
//  MC1 Sunpride
//
//  Created by Tb. Daffa Amadeo Zhafrana on 04/04/22.
//

import UIKit

class ViewController: UIViewController {
    
//<<<<<<< HEAD
//    @IBOutlet weak var timerLabel: UITextView!
//    @IBOutlet weak var startStopButton: UIButton!
//
//    let userDefaults = UserDefaults.standard
//
//    var sessionTimer: SessionTimer?
//    var sessions = getSessions()
//
    override func viewDidLoad()
    {
        super.viewDidLoad()

        AppNotification.requestAuthorization()
//        sessionTimer = SessionTimer(timerLabel: timerLabel, startStopButton: startStopButton)
    }
//
//    @IBAction func startStopAction(_ sender: Any) {
//        sessionTimer!.startStopAction()
//    }
//
//    func updateSessions(){
//        if let data = try? PropertyListEncoder().encode(sessions) {
//                UserDefaults.standard.set(data, forKey: SESSIONS_KEY)
//        }
//    }
//=======
}

class HumanInterface
{
    static let blacklistName: [String] = ["iphone", "ipad"]
    
    static public func pickNameFromDevice() -> String?
    {
        let deviceName: String = UIDevice.current.name
        let nameCandidates: [String] = deviceName.components(separatedBy: " ")
        for name in nameCandidates
            { if (!isBlacklisted(name) && !isBeginWithNumber(name)) { return name } }
        return nil
    }
    
    static private func isBlacklisted(_ string: String) -> Bool
    {
        for b in blacklistName
            { if (string.localizedCaseInsensitiveContains(b)) { return true } }
        return false
    }
    
    static private func isBeginWithNumber(_ string: String) -> Bool
    {
        if string.isEmpty { return false }
        return string[string.startIndex].isNumber
    }
}
