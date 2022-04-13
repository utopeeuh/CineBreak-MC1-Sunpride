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
    case _3 = 50
}

func getNotificationMessage(_ kind: NotificationKind, _ intensity: MessageIntensity, _ name: String?) -> String
{
    let callname: String = name == nil ? "User" : name!
    if (kind == .breaktime)
    {
        if (intensity == .soft)
            { return "\(callname) are you ready to take a break? It will only took you a few seconds!" }
        if (intensity == .normal)
            { return "Fun fact of the day: Taking a break won't hurt anyone!" }
        if (intensity == .strong)
            { return "Feel like wearing thicker glasses? Take a break now \(callname)!" }
    }
    else if (kind == .overtime)
    {
        if (intensity == .soft)
            { return "You have complete your daily dose of movie theraphy, time to continue your activities" }
        if (intensity == .normal)
            { return "Hey, don't you have anything else to do?" }
        if (intensity == .strong)
            { return "Forgetting other things \(callname)? Guess you're just lazy and old" }
    }
    else if (kind == .bedtime)
    {
        if (intensity == .soft)
            { return "Hey, I would like to remind you that it is time to sleep :)" }
        if (intensity == .normal)
            { return "It's sleep time, you can continue later after enough rest :)" }
        if (intensity == .strong)
            { return "I guess sleep deprivation is a trend now \(callname)" }
    }
    return ""
}

let BREAK_NOTIFICATION_ACTION_CALLBACK: [(title: String, options: UNNotificationActionOptions, callback: () -> Void)] = [
    ("Guide Me", [.foreground], AppNotification.onGuideMeAction),
    ("I Have Done It", [.destructive], AppNotification.onIHaveDoneItAction),
]

class AppNotification
{
    public static var onBreakTakenHandler: (() -> Void)? = nil
    
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
        
        // bedtime notification
        if (true)
        {
            notifcontent.body = getNotificationMessage(
                .bedtime,
                UserSettings.get(.messageIntensity) as! MessageIntensity,
                UserSettings.get(.username) as! String?
            )
            let sleepTimeIntervalDay0 = UserSettings.getSleepTimeInterval()
            let date     = Date()
            let calendar = Calendar.current
            let hour     = calendar.component(.hour, from: date)
            let minutes  = calendar.component(.minute, from: date)
            let currTimeIntervalDay0 = Double(hour * 3600 + minutes * 60)
            let bedtimeInterval = currTimeIntervalDay0 > sleepTimeIntervalDay0 ?
                24 * 60 * 60 - currTimeIntervalDay0 + sleepTimeIntervalDay0 : sleepTimeIntervalDay0 - currTimeIntervalDay0
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: bedtimeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: NotificationKind.overtime.rawValue, content: notifcontent, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
        
        // overtime notification
        if (true)
        {
            notifcontent.body = getNotificationMessage(
                .overtime,
                UserSettings.get(.messageIntensity) as! MessageIntensity,
                UserSettings.get(.username) as! String?
            )
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: UserSettings.getOvertimeInterval(), repeats: false)
            let request = UNNotificationRequest(identifier: NotificationKind.overtime.rawValue, content: notifcontent, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
        
    }
    
    static func removeAllNotification() -> Void
    {
        removeBreakNotification()
        for kind in [NotificationKind.overtime, NotificationKind.bedtime]
        {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [kind.rawValue])
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [kind.rawValue])
        }
    }
    
    static func removeBreakNotification() -> Void
    {
        for step in BreakNotificationStep.allCases
        {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(step)"])
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["\(step)"])
        }
    }
    
    public static func isBreakTime(_ startTime: Date, _ step: BreakNotificationStep = ._1) -> Bool
    {
        return Date().timeIntervalSince(startTime) >= step.rawValue
    }
    
    public static func onGuideMeAction() -> Void
    {
        let presented = stretchingVC.viewIfLoaded?.window != nil
        stretchingVC.completionHandler = onBreakTaken
        if (!presented)
        {
            let vc = UIApplication.shared.topMostViewController()
            vc?.present(stretchingVC, animated: true)
        }
    }
    
    static func onIHaveDoneItAction() -> Void
    {
        if (UIApplication.shared.applicationState != .background)
        {
            let presented = stretchingVC.viewIfLoaded?.window != nil
            stretchingVC.completionHandler = nil
            if (presented)
                { stretchingVC.dismiss(animated: true) }
        }
        onBreakTaken()
    }
    
    static func onBreakTaken() -> Void
    {
        addBreakCounter()
        removeBreakNotification()
        registerBreakNotification()
        onBreakTakenHandler?()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate
{
    // did receive push notification from background
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) -> Void
    {
        if let idx = Int(response.actionIdentifier)
            { BREAK_NOTIFICATION_ACTION_CALLBACK[idx].callback() }
        completionHandler()
    }
    
    // received push notifications while in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) -> Void
    {
        completionHandler([.sound, .badge, .list])
    }
}
