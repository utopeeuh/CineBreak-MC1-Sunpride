import Foundation
import UIKit

class HomeViewController: UIViewController
{
    /** this is optional, status bar style can be set in project settings */
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    @IBOutlet weak var prepBtn: UIButton!
    @IBOutlet weak var stretchBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        prepBtn.semanticContentAttribute = .forceRightToLeft
        stretchBtn.semanticContentAttribute = .forceRightToLeft
    }
    
    @IBAction func openSetupModal(_ sender: Any) {
        performSegue(withIdentifier: "setupModal", sender: self)
    }
    
    @IBAction func openStretchingModal(_ sender: Any) {
        performSegue(withIdentifier: "stretchingModal", sender: self)
    }
}
