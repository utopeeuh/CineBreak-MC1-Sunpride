import Foundation
import UIKit

let notificationRequestVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationRequestID")

class NotificationRequestViewController: UIViewController
{
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func onGivePermissionButton(_ sender: Any)
    {
        Task(priority: .high)
        {
            let status = await AppNotification.getAuthorizationStatus()
            let appSettingURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!)!
            
            if (status == .notDetermined)
            {
                AppNotification.requestAuthorization() { (granted, error) in
                    if let error = error { print(error) }
                    if (granted) { DispatchQueue.main.async { self.dismiss(animated: true) }}
                }
            }
            else if (status == .denied)
                { await UIApplication.shared.open(appSettingURL) }
        }
    }
    
    @IBAction func onNotNowButton(_ sender: Any)
    {
        self.dismiss(animated: true)
    }
}
