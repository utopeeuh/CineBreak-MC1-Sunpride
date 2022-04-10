import UIKit

class ViewController: UIViewController
{
    /** this is optional, status bar style can be set in project settings */
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    /** ask for authroization to do notification */
    let notificationRequestView = NotificationRequestView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Task(priority: .high) { await waitForNotificationAuthorization() }
    }
    
    public func waitForNotificationAuthorization() async -> Void
    {
        let status = await AppNotification.getAuthorizationStatus()
        status == .authorized ? notificationRequestView.removeFromSuperview() : view.addSubview(notificationRequestView)
    }
}
