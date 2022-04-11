//
//  ViewController.swift
//  MC1 Sunpride
//
//  Created by Tb. Daffa Amadeo Zhafrana on 04/04/22.
//

import UIKit

class ViewController: UIViewController
{
    /** this is optional, status bar style can be set in project settings */
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    var selectedDate = Date()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(HumanInterface.pickNameFromDevice())
    }
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
