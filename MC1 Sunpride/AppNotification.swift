import Foundation
import UserNotifications
import UIKit

/** identifier for push notification, different id for seperate banner notification, otherwise it will replace the previous */
enum NotificationKind: String
{
    case breaktime = "Break Routine"
    case overtime  = "Overtime Reminder"
    case bedtime   = "Getting Ready for Bed"
}

enum MessageIntensity
{
    case soft
    case normal
    case strong
}

/** a time in seconds that indicate the interval for push notification */
enum BreakNotificationStep: TimeInterval, CaseIterable
{
    case _1 = 30
    case _2 = 40
    case _3 = 45
}

func getNotificationMessage(_ kind: NotificationKind, _ intensity: MessageIntensity, _ name: String?) -> String
{
    if (kind == .breaktime)
    {
        if (intensity == .soft)
            { return "" }
        if (intensity == .normal)
            { return "" }
        if (intensity == .strong)
            { return "" }
    }
    else if (kind == .overtime)
    {
        if (intensity == .soft)
            { return "" }
        if (intensity == .normal)
            { return "" }
        if (intensity == .strong)
            { return "" }
    }
    else if (kind == .bedtime)
    {
        if (intensity == .soft)
            { return "" }
        if (intensity == .normal)
            { return "" }
        if (intensity == .strong)
            { return "" }
    }
    return ""
}

let BREAK_NOTIFICATION_ACTION_CALLBACK: [(title: String, options: UNNotificationActionOptions, callback: () -> Void)] = [
    ("Guide Me", [.foreground], AppNotification.onGuideMeAction),
    ("I Have Done It", [.destructive], AppNotification.onIHaveDoneItAction),
]

class AppNotification
{
    private init() {}
    
    public static func requestAuthorization(completionHandler: @escaping (Bool, Error?) -> Void) -> Void
    {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: completionHandler)
    }
    
    public static func getAuthorizationStatus() async -> UNAuthorizationStatus
    {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
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
            identifier: NotificationKind.breaktime.rawValue,
            actions: breakActions,
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([breakCategory])
        registerBreakNotification()
    }
    
    private static func registerBreakNotification() -> Void
    {
        let message = getNotificationMessage(
            .breaktime,
            UserSettings.get(.messageIntensity) as! MessageIntensity,
            UserSettings.get(.username) as! String?
        )
        
        let notifcontent                = UNMutableNotificationContent()
        notifcontent.title              = NotificationKind.breaktime.rawValue
        notifcontent.badge              = NSNumber(value: 3)
        notifcontent.sound              = .default
        notifcontent.categoryIdentifier = NotificationKind.breaktime.rawValue
        notifcontent.body               = message
        
        for step in BreakNotificationStep.allCases
        {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: step.rawValue, repeats: false)
            let request = UNNotificationRequest(identifier: "\(step)", content: notifcontent, trigger: trigger)
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
        resetBreakNotification()
        registerBreakNotification()
    }
    
    static func onIHaveDoneItAction() -> Void
    {
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
        if let idx = Int(response.actionIdentifier)
        {
            BREAK_NOTIFICATION_ACTION_CALLBACK[idx].callback()
            completionHandler()
        }
    }
}
