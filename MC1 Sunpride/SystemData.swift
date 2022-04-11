import Foundation
import UIKit

class SystemData
{
    static let blacklistName: [String] = ["iphone", "ipad"]
    
    static public func pickNameFromDevice() -> String?
    {
        let deviceName: String = UIDevice.current.name
        let nameCandidates: [String] = deviceName.components(separatedBy: " ")
        
        /// detect if a string contains a word (non case sensitive) from what listed on `blacklistName`
        let isBlacklisted = { (_ string: String) -> Bool in
            for b in blacklistName
                { if (string.localizedCaseInsensitiveContains(b)) { return true } }
            return false
        }
        /// detect if a string is started with a number
        let isBeginWithNumber = { (_ string: String) -> Bool in
            if string.isEmpty { return false }
            return string[string.startIndex].isNumber
        }
        /// find first from candidates
        for name in nameCandidates
            { if (!isBlacklisted(name) && !isBeginWithNumber(name)) { return name } }
        return nil
    }
}
