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
    print(sessions)
    if let data = try? PropertyListEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: SESSIONS_KEY)
    }
}

func addBreakCounter(){
    breakCounter += 1
}

func createSession (startTime: Date){
    let watchTime = Date().timeIntervalSince(startTime)
    if watchTime > 10 {
        print(watchTime)
        var isOvertime = false
        
        let calendar = Calendar.current
        
        let startHour = calendar.component(.hour, from: startTime)
        let startMinute = calendar.component(.minute, from: startTime)
        let finishHour = calendar.component(.hour, from: Date())
        let finishMinute = calendar.component(.minute, from: Date())
        
        if startHour < getSleepTimeHour() && startMinute < getSleepTimeMinute() && finishHour > getSleepTimeHour() && finishMinute > getSleepTimeMinute(){
            isOvertime = true
        }
            
        let newSession = Session(date: Date(), watchTime: watchTime, breaksTaken: breakCounter, isOvertime: isOvertime)
        addSession(newSession: newSession)
    }
    breakCounter = 0
    
}












