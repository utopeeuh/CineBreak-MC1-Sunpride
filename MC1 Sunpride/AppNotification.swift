import Foundation
import UserNotifications
import UIKit

/** identifier for push notification, different id for seperate banner notification, otherwise it will replace the previous */
enum NotificationKind: String
{
    case breaktime = "Take a break!"
    case overtime  = "You're going overtime!"
    case bedtime   = "Get ready for bed"
}

enum MessageIntensity: Int, CaseIterable
{
    case soft   = 0
    case normal = 1
    case strong = 2
}

/** a time in seconds that indicate the interval for push notification */
enum BreakNotificationStep: TimeInterval, CaseIterable
{
    case _1 = 30
    case _2 = 40
    case _3 = 50
}

private struct Messages {
    var breakMessages : [String]
    var overtimeMessages : [String]
    var bedtimeMessages : [String]
}

private var userName = ""
private let softMessages = Messages(breakMessages: ["Time is up! It's important to take a little break"], overtimeMessages: ["You have completed your daily dose of movie therapy, time to continue your activities", "Remember to do other things other than watching!"], bedtimeMessages: ["Hey, I'd like to remind you that it's time to sleep :)"])

private let normalMessages = Messages(breakMessages: ["Fun fact of the day: Taking a little break won't hurt anyone!"], overtimeMessages: ["\(userName), your time is up! It's time to rest or be more productive!", "Hey \(userName), don't you have anything else to do?"], bedtimeMessages: ["It's sleep time. You can continue later after enough rest :)", "Knock knock. Who's there? Sleepy. Sleepy who? Sleepy you."])

private let strongMessages = Messages(breakMessages: ["Fun fact: People who don't take breaks develop back pains!", "Feel like wearing thicker glasses? Take a break!", "Back pain incoming!!!"], overtimeMessages: ["Forgetting other things \(userName)? Guess you're just lazy and old"], bedtimeMessages: ["For the love of God, stop and go to sleep! You have enough problems for tomorrow!", "I see a person who doesn't care enough about their sleep", "I guess sleep deprivation is a trend now \(userName)"])

func getNotificationMessage(_ kind: NotificationKind, _ intensity: MessageIntensity, _ name: String?) -> String
{
    userName = name ?? "User"
    if (kind == .breaktime)
    {
        if (intensity == .soft)
            { return softMessages.breakMessages.randomElement()! }
        if (intensity == .normal)
            { return normalMessages.breakMessages.randomElement()! }
        if (intensity == .strong)
            { return strongMessages.breakMessages.randomElement()! }
    }
    else if (kind == .overtime)
    {
        if (intensity == .soft)
            { return softMessages.overtimeMessages.randomElement()! }
        if (intensity == .normal)
            { return normalMessages.overtimeMessages.randomElement()! }
        if (intensity == .strong)
            { return strongMessages.overtimeMessages.randomElement()! }
    }
    else if (kind == .bedtime)
    {
        if (intensity == .soft)
            { return softMessages.bedtimeMessages.randomElement()! }
        if (intensity == .normal)
            { return normalMessages.bedtimeMessages.randomElement()! }
        if (intensity == .strong)
            { return strongMessages.bedtimeMessages.randomElement()! }
    }
    return ""
}

let BREAK_NOTIFICATION_ACTION_CALLBACK: [(title: String, options: UNNotificationActionOptions, callback: () -> Void)] = [
    ("Show Me How", [.foreground], AppNotification.onGuideMeAction),
    ("I've Done It", [.destructive], AppNotification.onIHaveDoneItAction),
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
        let intensityIdx = UserSettings.get(.messageIntensity) as! Int
        let msgIntensity = MessageIntensity.allCases[intensityIdx]
        
        let message = getNotificationMessage(
            .breaktime,
            msgIntensity,
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
                msgIntensity,
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
                msgIntensity,
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
