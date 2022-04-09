import Foundation
import UserNotifications
import UIKit

/** identifier for push notification, different id for seperate banner notification, otherwise it will replace the previous */
enum NotificationId: String, CaseIterable
{
    case Break = "break"
}

/** a time in minutes that indicate the interval for push notification */
enum BreakNotificationStep: TimeInterval, CaseIterable
{
    case _1 = 30
    case _2 = 40
    case _3 = 45
}

let BREAK_NOTIFICATION_ACTION_CALLBACK: [(title: String, options: UNNotificationActionOptions, callback: () -> Void)] = [
    ("Guide Me", [.foreground, .destructive], AppNotification.onGuideMeAction),
    ("I Have Done It", [.destructive], AppNotification.onIHaveDoneItAction),
]

class AppNotification
{
    private init() {}
    
    public static func requestAuthorization() -> Void
    {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
            if let error = error { print(error) }
        }
    }
    
    public static func printAuthorizationStatus() -> Void
    {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print(settings.authorizationStatus.rawValue)
        }
    }
    
    public static func sendNotification() -> Void
    {
        var breakActions = [UNNotificationAction]()
        breakActions.reserveCapacity(BREAK_NOTIFICATION_ACTION_CALLBACK.count)
        for (i, e) in BREAK_NOTIFICATION_ACTION_CALLBACK.enumerated()
        {
            breakActions.append(UNNotificationAction(
                identifier: "\(i)",
                title: e.title,
                options: e.options
            ))
        }
        
        let breakCategory = UNNotificationCategory(
            identifier: NotificationId.Break.rawValue,
            actions: breakActions,
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([breakCategory])
        registerBreakNotification()
    }
    
    private static func registerBreakNotification() -> Void
    {
        let notificationContent                = UNMutableNotificationContent()
        notificationContent.title              = "Break Time"
        notificationContent.body               = "Write your message here!"
        notificationContent.badge              = NSNumber(value: 3)
        notificationContent.sound              = .default
        notificationContent.categoryIdentifier = NotificationId.Break.rawValue
        
        for step in BreakNotificationStep.allCases
        {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: step.rawValue, repeats: false)
            let request = UNNotificationRequest(identifier: "\(step)", content: notificationContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    static func resetBreakNotification() -> Void
    {
        for step in BreakNotificationStep.allCases
        {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(step)"])
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["\(step)"])
        }
    }
    
    static func onGuideMeAction() -> Void
    {
        print("Guide Me")
        resetBreakNotification()
        registerBreakNotification()
    }
    
    static func onIHaveDoneItAction() -> Void
    {
        print("I Have Done It")
        resetBreakNotification()
        registerBreakNotification()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate
{
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) -> Void
    {
        let idx: Int? = Int(response.actionIdentifier)
        BREAK_NOTIFICATION_ACTION_CALLBACK[idx!].callback()
        completionHandler()
    }
}
