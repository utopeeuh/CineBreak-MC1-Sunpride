import Foundation

enum SettingsKey
{
    case initial                       /// Bool
    case username                      /// String
    case enableVibrate                 /// Bool
    case sleepTime                     /// String
    case messageIntensity              /// MessageIntensity
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
        if (key == .username)                       { return nil }
        if (key == .enableVibrate)                  { return true }
        if (key == .sleepTime)                      { return "22:00" }
        if (key == .messageIntensity)               { return MessageIntensity.normal }
        if (key == .targetWatchDuration)            { return "3 hours" }
        if (key == .enableOvertimeNotification)     { return true }
        if (key == .enableBreaktimeNotification)    { return true }
        if (key == .enablePassBedtimeNotification)  { return true }
        return nil
    }
}
