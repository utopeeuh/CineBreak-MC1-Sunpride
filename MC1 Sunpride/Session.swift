import Foundation

let SESSIONS_KEY = "SESSIONS_KEY"
let encoder = JSONEncoder()

private var breakCounter : Int = 0

struct Session: Codable
{
    var date: Date
    var watchTime: Double
    var breaksTaken : Int
    var isOvertime : Bool
}

func getSessions() -> [Session]
{
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

func addSession(newSession: Session) -> Void
{
    var sessions = getSessions()
    sessions.append(newSession)
    if let data = try? PropertyListEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: SESSIONS_KEY)
    }
}

func addCounter(){
    breakCounter += 1
}

func createSession (startTime: Date){
    let watchTime = Date().timeIntervalSince(startTime)
    let isOvertime = watchTime > getWatchTime() ? true : false
    let newSession = Session(date: Date(), watchTime: watchTime, breaksTaken: breakCounter, isOvertime: isOvertime)
    addSession(newSession: newSession)
}












