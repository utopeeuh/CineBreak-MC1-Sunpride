//
//  Session.swift
//  MC1 Sunpride
//
//  Created by Tb. Daffa Amadeo Zhafrana on 06/04/22.
//

import Foundation
let SESSIONS_KEY = "SESSIONS_KEY"

struct Session: Codable {
    var date: Date
    var watchTime: Double
    var breaksTaken : Int
    var watchAfterSleepTime : Bool
}

func getSessions() -> [Session]{
    let emptySessions : [Session] = []
    let sessions =  UserDefaults.standard.object(forKey: SESSIONS_KEY) as? [Session] ?? emptySessions
    
    if sessions.isEmpty == true{
        UserDefaults.standard.setValue(sessions, forKey: SESSIONS_KEY)
    }
    
    return sessions
}














