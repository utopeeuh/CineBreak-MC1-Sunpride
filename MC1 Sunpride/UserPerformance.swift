import Foundation

// Call by UserPerformance.shared.att
class UserPerformance
{
    
    private let defaults = UserDefaults.standard
    
    private let TOTAL_WATCHTIME_KEY = "TOTAL_WATCHTIME_KEY"
    private let BREAKS_TAKEN_KEY = "BREAKS_TAKEN_KEY"
    private let SESSIONS_DONE_KEY = "SESSIONS_DONE_KEY"
    private let TIMES_OVERTIME_KEY = "TIMES_OVERTIME_KEY"
    
    //retrieve sessions, update userdefaults data from 6 days ago to today, ran everytime app is opened
    func updateWeeklyStats(){
        resetStats()
        for s in getSessions() {
            // validate if session is in the past 7 days inc. today
            if(s.date >= subtractDay(days: 6)){
                update(s: s)
            }
        }
    }
    
    func getLastWeekStat() -> Double{
        var totalTime : Double = 0
        for s in getSessions() {
            if subtractDay(days: 7) <  s.date  && s.date < subtractDay(days: 13){
                totalTime += s.watchTime
            }
        }
        return totalTime
    }
    
    private func subtractDay(days: Int) -> Date{
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = days*(-1)
        return Calendar.current.date(byAdding: dateComponent, to: currentDate)!
    }
    
    private func update(s: Session){
        totalWatchtime += s.watchTime
        breaksTaken += Double(s.breaksTaken)
        sessionsDone += 1
        if s.isOvertime {  timesOvertime += 1  }
    }
    
    private func resetStats(){
        totalWatchtime = 0
        breaksTaken = 0
        sessionsDone = 0
        timesOvertime = 0
    }
    
    var totalWatchtime : Double {
        set {
            defaults.setValue(newValue, forKey: TOTAL_WATCHTIME_KEY)
        }
        get {
            return defaults.double(forKey: TOTAL_WATCHTIME_KEY)
        }
    }
    
    var breaksTaken : Double {
        set {
            defaults.setValue(newValue, forKey: BREAKS_TAKEN_KEY)
        }
        get {
            return defaults.double(forKey: BREAKS_TAKEN_KEY)
        }
    }
    
    var sessionsDone : Double {
        set {
            defaults.setValue(newValue, forKey: SESSIONS_DONE_KEY)
        }
        get {
            return defaults.double(forKey: SESSIONS_DONE_KEY)
        }
    }
    
    var timesOvertime : Double {
        set {
            defaults.setValue(newValue, forKey: TIMES_OVERTIME_KEY)
        }
        get {
            return defaults.double(forKey: TIMES_OVERTIME_KEY)
        }
    }
    
    class var shared: UserPerformance {
        struct Static {
            static let instance = UserPerformance()
        }
      
        return Static.instance
    }
    
    func isDayInCurrentWeek(date: Date) -> Bool? {
        let currentComponents = Calendar.current.dateComponents([.weekOfYear], from: Date())
        let dateComponents = Calendar.current.dateComponents([.weekOfYear], from: date)
        guard let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear else { return nil }
        return currentWeekOfYear == dateWeekOfYear
    }
   
}


