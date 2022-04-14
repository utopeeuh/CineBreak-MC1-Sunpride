import Foundation

enum SettingsKey
{
    case initial                       /// Bool
    case username                      /// String
    case enableVibrate                 /// Bool
    case sleepTime                     /// String
    case messageIntensity              /// Int as CaseIterable Index
    case targetWatchDuration           /// String
    case enableBreaktimeNotification   /// Bool
    case enableOvertimeNotification    /// Bool
    case enablePassBedtimeNotification /// Bool
}

class UserSettings
{
    static public func set(_ key: SettingsKey, _ value: Any?) -> Void
    {
        UserDefaults.standard.set(value, forKey: "\(key)")
    }
    
    static public func get(_ key: SettingsKey) -> Any?
    {
        let value = UserDefaults.standard.object(forKey: "\(key)")
        if (value != nil) { return value }
        /// default value for user settings
        if (key == .initial)                        { return true }
        if (key == .username)                       { return "User" }
        if (key == .enableVibrate)                  { return true }
        if (key == .sleepTime)                      { return "22:00" }
        if (key == .messageIntensity)               { return MessageIntensity.normal.rawValue }
        if (key == .targetWatchDuration)            { return "3" }
        if (key == .enableOvertimeNotification)     { return true }
        if (key == .enableBreaktimeNotification)    { return true }
        if (key == .enablePassBedtimeNotification)  { return true }
        return nil
    }
    
    public static func getSleepTimeInterval() -> TimeInterval
    {
        let time = get(.sleepTime) as! String
        let times = time.split(separator: ":")
        return 3600 * Double(times[0])! + 60 * Double(times[1])!
    }
    
    public static func getOvertimeInterval() -> TimeInterval
    {
        let time = get(.targetWatchDuration) as! String
        return 3600 * Double(time)!
    }
    
    public static func getSleepTimeHour() -> Int{
        let sleepTime = String(describing: UserSettings.get(.sleepTime))
        let hour = String(sleepTime[sleepTime.index(sleepTime.startIndex, offsetBy: 9)]) + String(sleepTime[sleepTime.index(sleepTime.startIndex, offsetBy: 10)])
        print(hour)
        return Int(hour)!
    }

    public static func getSleepTimeMinute() -> Int{
        let sleepTime = String(describing: UserSettings.get(.sleepTime))
        let minute = String(sleepTime[sleepTime.index(sleepTime.startIndex, offsetBy: 12)]) + String(sleepTime[sleepTime.index(sleepTime.startIndex, offsetBy: 13)])
        return Int(minute)!
    }
}
