import UIKit

class ViewController: UIViewController
{
    /** this is optional, status bar style can be set in project settings */
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AppNotification.requestAuthorization()
        AppNotification.sendNotification()
    }
}
