//
//  ModalController.swift
//  MC1 Sunpride
//
//  Created by Tb. Daffa Amadeo Zhafrana on 11/04/22.
//

import Foundation
import UIKit

let stretchingVC = UIStoryboard(name: "StretchingModal", bundle: nil).instantiateViewController(withIdentifier: "stretchingModal") as! ModalViewController
let setupVC = UIStoryboard(name: "SetupModal", bundle: nil).instantiateViewController(withIdentifier: "setupModal") as! ModalViewController

class ModalViewController: UIViewController
{
    public var completionHandler: (() -> Void)? = nil
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        completionHandler?()
    }
    
    @IBAction func dismissModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
