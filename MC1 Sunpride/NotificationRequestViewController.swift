import Foundation
import UIKit

class NotificationRequestViewController: UIViewController
{
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
