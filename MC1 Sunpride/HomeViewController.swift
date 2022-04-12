import Foundation
import UIKit

class HomeViewController: UIViewController
{
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    @IBOutlet weak var prepBtn: UIButton!
    @IBOutlet weak var stretchBtn: UIButton!
    @IBOutlet weak var timerView: TimerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AppNotification.onBreakTakenHandler = self.onBreakTakenHandler
        timerView.initialTime = UInt(BreakNotificationStep.allCases[0].rawValue)
        prepBtn.semanticContentAttribute = .forceRightToLeft
        stretchBtn.semanticContentAttribute = .forceRightToLeft
    }
    
    @IBAction func openSetupModal(_ sender: Any)
    {
        setupVC.completionHandler = nil
        let presented = setupVC.viewIfLoaded?.window != nil
        if (!presented)
        {
            let vc = UIApplication.shared.topMostViewController()
            vc?.present(setupVC, animated: true)
        }
    }
    
    @IBAction func openStretchingModal(_ sender: Any)
    {
        stretchingVC.completionHandler = nil
        let presented = stretchingVC.viewIfLoaded?.window != nil
        if (!presented)
        {
            let vc = UIApplication.shared.topMostViewController()
            vc?.present(stretchingVC, animated: true)
        }
    }
    
    func onBreakTakenHandler() -> Void
    {
        timerView.startTimer()
    }
}
