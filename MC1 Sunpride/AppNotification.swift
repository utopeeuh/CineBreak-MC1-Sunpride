//
//  UserNotification.swift
//  MC1 Sunpride
//
//  Created by Ramadhan Kalih Sewu on 04/04/22.
//

import Foundation
import UserNotifications

class AppNotification
{
    private init() {}
    
    public static func requestAuthorization() -> Void
    {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
            print(error != nil ? error.debugDescription : "")
        }
    }
    
    public static func printAuthorizationStatus() -> Void
    {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print(settings.authorizationStatus.rawValue)
        }
    }
    
    public static func sendNotification()
    {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Break Time"
        notificationContent.body  = "Are you ready to take a break? This will only take you 30 seconds!"
        notificationContent.badge = NSNumber(value: 3)
        notificationContent.sound = .default
        
        if let url = Bundle.main.url(forResource: "dune",
                                    withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                            url: url,
                                                            options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60,
                                                        repeats: true)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    public static func stopNotification(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
