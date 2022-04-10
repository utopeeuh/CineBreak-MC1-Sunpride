import Foundation
import UIKit

class NotificationRequestView: UIView
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        setup()
    }
    
    func setup()
    {
        let bundle  = Bundle(for: NotificationRequestView.self)
        let view    = bundle.loadNibNamed("NotificationRequestView", owner: self, options: nil)![0] as! UIView
        view.frame  = self.bounds
        addSubview(view)
    }
    
    @IBAction func onGivePermissionButton(_ sender: Any)
    {
        Task(priority: .high)
        {
            let authorizationStatus = await AppNotification.getAuthorizationStatus()
            let appSettingURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!)!
            
            if (authorizationStatus == .notDetermined)
                { AppNotification.requestAuthorization() }
            if (authorizationStatus == .denied)
                { await UIApplication.shared.open(appSettingURL) }
        }
    }
    
    @IBAction func onNotNowButton(_ sender: Any)
    {
        self.removeFromSuperview()
    }
}
