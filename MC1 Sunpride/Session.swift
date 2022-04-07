//
//  Session.swift
//  MC1 Sunpride
//
//  Created by Tb. Daffa Amadeo Zhafrana on 06/04/22.
//

import Foundation
let SESSIONS_KEY = "SESSIONS_KEY"
let encoder = JSONEncoder()

struct Session: Codable {
    var date: Date
    var watchTime: Double
    var breaksTaken : Int
    var isOvertime : Bool
}

func getSessions() -> [Session]{
    
    let emptySessions : [Session] = []
    
    // retrieve from UserDefaults if exists
    if let data = UserDefaults.standard.data(forKey: SESSIONS_KEY) {
        let sessions = try! PropertyListDecoder().decode([Session].self, from: data)
        return sessions
    }
    
    // insert empty Session array to UserDefaults if not exists
    else if let data = try? PropertyListEncoder().encode(emptySessions){
        UserDefaults.standard.set(data, forKey: SESSIONS_KEY)
    }
    
    return emptySessions
}

func addSession(newSession: Session) -> Void{
    var sessions = getSessions()
    sessions.append(newSession)
    if let data = try? PropertyListEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: SESSIONS_KEY)
    }
}












