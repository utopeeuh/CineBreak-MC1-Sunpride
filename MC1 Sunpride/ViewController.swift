//
//  ViewController.swift
//  UserPreference
//
//  Created by Wilbert Devin Wijaya on 05/04/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        print("2")
    }
    
    @IBAction func goToUserP(_ sender: Any) {
        performSegue(withIdentifier: "goToUserP", sender: self)
        print("1")
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "goToUserP" {
//                guard let vc = segue.destination as? UserPreferenceController else { return }
//                self.show(vc, sender: self)
//            }
//        }
}
